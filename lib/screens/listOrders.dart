import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:ecom_app/pojo/orderspojo.dart';
import 'package:ecom_app/screens/listDeliveryBoys.dart';
import 'package:ecom_app/screens/orderdetails.dart';
import 'package:ecom_app/viewModel/orderVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ListOrders extends StatefulWidget {
  @override
  _ListOrdersState createState() => _ListOrdersState();
}

class _ListOrdersState extends State<ListOrders> {
  OrdersPojo? pojo;
  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      listOrders();
    });
  }

  void listOrders() async {
    OrdersVm ordersVm = OrdersVm();
    pojo = await ordersVm.listOrders(context);
    pojo!.results.sort((a, b) => b.id.compareTo(a.id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: pojo != null
          ? pojo!.results.any((e) => e.isSelected == true)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    backgroundColor: purple,
                    icon: Icon(Icons.chevron_right_rounded),
                    label: Text("Assign to Delivery Boy"),
                    onPressed: () {
                      pojo!.results.forEach((element) {
                        if (element.isSelected) {
                          Provider.of<NotificationProvider>(context,
                                  listen: false)
                              .addOrderIds(element.id.toString());
                        }
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListDeliveryBoys()));
                    },
                  ),
                )
              : Container()
          : null,
      appBar: appBarContent("ORDERS"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Neumorphic(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: searchWidget(),
                      ),
                      pojo != null ? list(context) : Container(),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container list(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: pojo!.results.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 2,
                right: 2,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetails(
                                id: pojo!.results[index].id.toString(),
                              )));
                },
                child: Neumorphic(
                    child: Container(
                        child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: NeumorphicCheckbox(
                                style: NeumorphicCheckboxStyle(
                                    selectedColor: purple),
                                value: pojo!.results[index].isSelected,
                                onChanged: (value) {
                                  pojo!.results[index].isSelected =
                                      !pojo!.results[index].isSelected;
                                  setState(() {});
                                },
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0, left: 8, right: 8, bottom: 8),
                        child: Text(
                          "Order ID : " + pojo!.results[index].id.toString(),
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0, left: 8, right: 8, bottom: 8),
                        child: Text(
                          "Customer ID : " +
                              pojo!.results[index].customer["id"].toString(),
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, left: 8, right: 8, bottom: 8),
                        child: Text(
                          "Customer Name : " +
                              pojo!.results[index].address["name"],
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, left: 8, right: 8, bottom: 8),
                        child: Text(
                          "Payment Mode : " + pojo!.results[index].paymentMode,
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 8, right: 8, bottom: 8),
                            child: pojo!.results[index].product.discount
                                        .length ==
                                    0
                                ? Text(
                                    "Amount Rs. : " +
                                        pojo!.results[index].product.price,
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Amount Rs. : " +
                                        pojo!.results[index].product.discount,
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          Spacer(),
                          Text(
                            pojo!.results[index].deliveryStatus,
                            style: TextStyle(
                                color: purple,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ))),
              ),
            );
          }),
    );
  }

  Neumorphic searchWidget() {
    return Neumorphic(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        child: TextField(
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            hintText: "Search Orders",
            hintStyle: TextStyle(fontSize: 15),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                borderRadius: BorderRadius.circular(14)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                borderRadius: BorderRadius.circular(14)),
          ),
          maxLines: 1,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
