import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoanDetails extends StatefulWidget {
  const LoanDetails({Key? key}) : super(key: key);

  @override
  _LoanDetailsState createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  static const channel = MethodChannel("");
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("LOAN DETAILS"),
      body: Container(
        height: getHeight(context),
        width: getWidth(context),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Below are the details of your loan",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Principal Amount",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Spacer(),
                        Text(
                          "Rs. 150000/-",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Paid Amount",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Spacer(),
                        Text(
                          "Rs. 1500/-",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Amount to Pay Today",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Spacer(),
                        Text(
                          "Rs. 100",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // SizedBox(
                  //   width: getWidth(context) / 2,
                  //   child: TextButton(
                  //       style: ButtonStyle(
                  //           elevation: MaterialStateProperty.all(10),
                  //           shape: materialShape,
                  //           backgroundColor:
                  //               MaterialStateProperty.all(Colors.white)),
                  //       onPressed: () {},
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             "Pay Now ",
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //           Image.asset(
                  //             "assets/images/gpay.jpg",
                  //             height: 40,
                  //             width: 40,
                  //           )
                  //         ],
                  //       )),
                  // )
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Payment Options",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () async {
                      await channel.invokeMethod("gpay");
                    },
                    trailing: Icon(Icons.chevron_right),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/gpay.jpg",
                        height: 60,
                        width: 60,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Pay Via Google Pay",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Center noLoans() {
    return Center(
        child: Text(
      "You haven't availed any loans",
      style: TextStyle(fontWeight: FontWeight.bold),
    ));
  }
}
