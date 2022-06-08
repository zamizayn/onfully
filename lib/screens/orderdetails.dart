import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/orderdetail.dart';
import 'package:ecom_app/screens/listDeliveryBoys.dart';
import 'package:ecom_app/viewModel/orderVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  final String id;
  OrderDetails({required this.id});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderDetailsPojo? pojo;
  String selectedLocation = 'Please choose new order status';
  List<String> locations = [
    'Please choose new order status',
    'Pending',
    'Accepted',
    'Ready To Dispatch',
    'Dispatched',
    'Delivered',
    'Cancelled',
    'Returned'
  ];

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      getOrderDetails();
    });
  }

  void getOrderDetails() async {
    OrdersVm ordersVm = OrdersVm();
    pojo = await ordersVm.orderDetails(context, widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("ORDER DETAILS"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              pojo != null
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Neumorphic(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Neumorphic(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Customer Details",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(pojo!.cusaddress["name"]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Customer ID : " +
                                                pojo!.customer["id"]
                                                    .toString()),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(pojo!.cusaddress["address"]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Pincode : " +
                                                pojo!.cusaddress["pincode"]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Neumorphic(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Product Details",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(pojo!.product.name),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Quantity : " + pojo!.count),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              pojo!.product.discount.length == 0
                                                  ? Text("Price : Rs. " +
                                                      pojo!.product.price +
                                                      "/-")
                                                  : Text("Price : Rs. " +
                                                      pojo!.product.discount +
                                                      "/-"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Image.network(
                                              IMAGEURL +
                                                  pojo!.product.imageDetails
                                                      .first.productImage,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Ordered On : " +
                                  DateFormat('dd-MM-yyyy')
                                      .format(pojo!.createdOn)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ORDER STATUS : " +
                                    pojo!.deliveryStatus.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: Neumorphic(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        items: locations.map((String val) {
                                          return new DropdownMenuItem<String>(
                                            value: val,
                                            child: new Text(
                                              val,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            selectedLocation,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onChanged: (newVal) {
                                          selectedLocation = newVal.toString();
                                          this.setState(() {});
                                        }),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (selectedLocation ==
                                      "Please choose new order status") {
                                    showToast(
                                        "Please choose an order status to proceed");
                                  } else {
                                    getLoading(context);
                                    OrdersVm ordersVm = OrdersVm();
                                    String? msg = await ordersVm.updateOrder(
                                        context, widget.id, selectedLocation);
                                    if (msg == "Updated Successfully") {
                                      showToast("Updated successfully");
                                      pojo!.deliveryStatus = selectedLocation;
                                      setState(() {});
                                    } else {
                                      showToast("Unable to update");
                                    }
                                  }
                                },
                                child: CustomIcon(
                                    icon: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launch("tel://" +
                                          pojo!.cusaddress["phone_number"]);
                                    },
                                    child: Neumorphic(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.phone_callback_outlined,
                                              color: purple,
                                            ),
                                            Text("  CALL CUSTOMER"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Neumorphic(
                                  //   child: Text("CALL CUSTOMER"),
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              pojo!.deliveryStatus.toUpperCase() ==
                                      'READY TO DISPATCH'
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListDeliveryBoys()));
                                        },
                                        child: Neumorphic(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              "FIND DELIVERY BOYS",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
