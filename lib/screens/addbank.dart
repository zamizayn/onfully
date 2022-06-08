import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/bankpojo.dart';
import 'package:ecom_app/viewModel/bankVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Addbank extends StatefulWidget {
  const Addbank({Key? key}) : super(key: key);

  @override
  _AddbankState createState() => _AddbankState();
}

class _AddbankState extends State<Addbank> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController accountnumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController branch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("ADD BANK ACCOUNT"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // customHeader(context, "ADD BANK ACCOUNT"),
              Neumorphic(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: namecontroller,
                          hint: "Enter your name",
                          isEnabled: true,
                          inputType: TextInputType.name,
                          formatters: [],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: accountnumber,
                          hint: "Enter your Account Number",
                          isEnabled: true,
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: bankName,
                          hint: "Enter your Bank Name",
                          isEnabled: true,
                          inputType: TextInputType.name,
                          formatters: [],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: ifsc,
                          hint: "Enter your Bank IFSC code",
                          isEnabled: true,
                          inputType: TextInputType.name,
                          formatters: [],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: branch,
                          hint: "Enter your Bank Branch",
                          isEnabled: true,
                          inputType: TextInputType.name,
                          formatters: [],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (namecontroller.text.toString().length == 0) {
                              showToast("Name cannot be empty");
                            } else if (accountnumber.text.toString().length ==
                                0) {
                              showToast("Account Number cannot be empty");
                            } else if (bankName.text.toString().length == 0) {
                              showToast("Bank Name cannot be empty");
                            } else if (ifsc.text.toString().length == 0) {
                              showToast("IFSC code cannot be emtpy");
                            } else if (branch.text.toString().length == 0) {
                              showToast("Branch cannot be empty");
                            } else {
                              BankPojo pojo = BankPojo(
                                  name: namecontroller.text.toString(),
                                  bankName: bankName.text.toString(),
                                  accNo: accountnumber.text.toString(),
                                  ifsc: ifsc.text.toString(),
                                  branch: branch.text.toString());
                              getLoading(context);
                              BankVm bankVm = BankVm();
                              bankVm.addBank(context, pojo);
                            }
                          },
                          child: CustomIcon(
                              icon: Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                          )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
