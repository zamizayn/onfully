import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/banks.dart';
import 'package:ecom_app/screens/addbank.dart';
import 'package:ecom_app/viewModel/bankVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ListBanks extends StatefulWidget {
  const ListBanks({Key? key}) : super(key: key);

  @override
  _ListBanksState createState() => _ListBanksState();
}

class _ListBanksState extends State<ListBanks> {
  Banks? pojo;
  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      getLoading(context);
      listBanks();
    });
  }

  void listBanks() async {
    BankVm bankVm = BankVm();
    pojo = await bankVm.listBanks(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("BANKS"),
      body: Neumorphic(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // customHeader(context, "BANKS"),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String? message = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Addbank()));

                      if (message != null) {
                        getLoading(context);
                        listBanks();
                      }
                    },
                    child: Neumorphic(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("ADD NEW BANK"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  pojo != null ? list() : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, int index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: purple),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(color: purple),
      ),
      onPressed: () {
        BankVm bankVm = BankVm();
        // bankVm.removeBank(context, pojo!.results[index].);
        //signOut();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Image.asset(
              "assets/images/onfully.png",
              height: 60,
              width: 80,
            ),
          ),
          Text("Confirm Removal"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Would you like to delete this bank account?"),
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Padding list() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: pojo!.results.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Neumorphic(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            pojo!.results[index].holderName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(pojo!.results[index].bankName),
                          SizedBox(
                            height: 10,
                          ),
                          Text("IFSC CODE : " + pojo!.results[index].ifscCode),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Neumorphic(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit_outlined,
                                color: purple,
                              ),
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showAlertDialog(context, index);
                              },
                              child: Neumorphic(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete_outlined,
                                  color: purple,
                                ),
                              )),
                            ),
                          ],
                        ))
                  ],
                ),
              )),
            );
          }),
    );
  }

  Container customHeader(BuildContext context, String text) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 2),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
