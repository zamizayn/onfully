import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/pojo/downloadspojo.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MyCustomers extends StatefulWidget {
  const MyCustomers({Key? key}) : super(key: key);

  @override
  _MyCustomersState createState() => _MyCustomersState();
}

class _MyCustomersState extends State<MyCustomers> {
  Downloads? pojo;
  @override
  void initState() {
    super.initState();
    getDownloads();
  }

  void getDownloads() async {
    LoginVM loginVM = LoginVM();
    pojo = await loginVM.getDownloads(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("My CUSTOMERS"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Neumorphic(
          child: SingleChildScrollView(
            child: Column(
              children: [
                pojo != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: pojo!.data.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
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
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(pojo!.data[index].name
                                              .toUpperCase()),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Joined on 24/12/2021"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Image.asset(
                                        "assets/images/onfully.png",
                                        height: 100,
                                        width: 100,
                                      )
                                    ],
                                  ),
                                )),
                              );
                            }))
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: CircularProgressIndicator()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
