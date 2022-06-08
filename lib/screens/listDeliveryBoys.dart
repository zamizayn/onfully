import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:ecom_app/viewModel/deliveryRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ListDeliveryBoys extends StatefulWidget {
  const ListDeliveryBoys({Key? key}) : super(key: key);

  @override
  _ListDeliveryBoysState createState() => _ListDeliveryBoysState();
}

class _ListDeliveryBoysState extends State<ListDeliveryBoys> {
  bool isLoading = true;
  DelifveryBoys? boys;
  @override
  void initState() {
    super.initState();

    listDeliveryBoys();
  }

  void listDeliveryBoys() async {
    DeliveryRepo repo = DeliveryRepo();
    boys = await repo.listDeliveryBoys(context);
    isLoading = false;
    setState(() {});
  }

  void assign(String id) async {
    Navigator.pop(context);
    setState(() {});
    isLoading = true;
    DeliveryRepo repo = DeliveryRepo();
    await repo.assignToDelivery(context, id.toString());
    isLoading = false;
    setState(() {});
  }

  Future<dynamic> showBottom(BuildContext context, int index, String type) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    child: ListTile(
                      onTap: () {
                        state(() {});
                        isLoading = true;
                        assign(boys!.results[index].id.toString());
                      },
                      title: Row(
                        children: [
                          Icon(Icons.bike_scooter),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            "Assign to " + boys!.results[index].name,
                            style: TextStyle(color: Colors.black),
                          ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: ListTile(
                      onTap: () async {},
                      title: Row(
                        children: [
                          Icon(Icons.call),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            "Call " + boys!.results[index].name,
                            style: TextStyle(color: Colors.black),
                          ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<NotificationProvider>(context, listen: false).resetOrders();
        return true;
      },
      child: Scaffold(
        appBar: appBarContent("DELIVERY BOYS"),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Neumorphic(
            child: SingleChildScrollView(
              child: isLoading == false
                  ? Column(
                      children: [
                        boys != null
                            ? ListView.builder(
                                itemCount: boys!.results.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        showBottom(context, index, 'type');
                                      },
                                      child: Neumorphic(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                boys!.results[index].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(boys!
                                                  .results[index].phoneNumber),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(boys!.results[index].email),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : showIndicator(context)
                      ],
                    )
                  : showIndicator(context),
            ),
          ),
        ),
      ),
    );
  }
}
