import 'dart:ui';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/main.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/categories.dart';
import 'package:ecom_app/pojo/panchaythpojo.dart';
import 'package:ecom_app/pojo/registerPojo.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SignUP extends StatefulWidget {
  final String mobileNumber;
  const SignUP({required this.mobileNumber});

  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController shopName = TextEditingController();
  TextEditingController shopAddress = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController distance = TextEditingController();
  String category = "";
  String categoryId = "";
  Categories? categories;
  bool checked = false;
  List<String> datas = [];
  PanchayathPojo? panchayaths;
  List<String> panchayathdatas = [];
  String? panchayathId;

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      loadPanchayth();
      loadCategories();
    });
  }

  loadCategories() async {
    LoginVM viewModel = LoginVM();
    getLoading(context);
    categories = await viewModel.fetchCategories(context);
    categories!.results.forEach((e) => datas.add(e.categoryName));
    category = datas.first;
    categoryId = categories!.results[0].id.toString();
    setState(() {});
  }

  loadPanchayth() async {
    LoginVM loginVM = LoginVM();
    panchayaths = await loginVM.fetchPanchayath(context);
    panchayaths!.results
        .forEach((element) => panchayathdatas.add(element.name));
    panchayathId = panchayaths!.results.first.id.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Neumorphic(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: bodyContent(context),
              )),
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            "assets/images/onfully.png",
            height: 50,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Enter Remaining Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            controller: nameController,
            hint: "Enter your name",
            isEnabled: true,
            inputType: TextInputType.name,
            formatters: [],
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            controller: emailController,
            hint: "Enter your Email ID",
            isEnabled: true,
            inputType: TextInputType.emailAddress,
            formatters: [],
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            controller: numberController,
            isEnabled: false,
            hint: widget.mobileNumber,
            inputType: TextInputType.number,
            formatters: [],
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            controller: shopName,
            isEnabled: true,
            hint: "Enter your Shop Name",
            inputType: TextInputType.name,
            formatters: [],
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            isEnabled: true,
            controller: shopAddress,
            hint: "Enter Your Shop Address",
            inputType: TextInputType.text,
            formatters: [],
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            controller: pincode,
            isEnabled: true,
            hint: "Enter your Shop Pincode",
            inputType: TextInputType.number,
            formatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
            controller: distance,
            isEnabled: true,
            hint: "Enter the Delivery Distance (in KM)",
            inputType: TextInputType.number,
            formatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(
            height: 30,
          ),
          datas.length > 0
              ? Neumorphic(
                  child: DropdownSearch<String>(
                      mode: Mode.DIALOG,
                      showSelectedItem: true,
                      showSearchBox: true,
                      items: datas,
                      label: "",
                      hint: "Choose Shop Category",
                      popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (data) {
                        category = data.toString();
                        int index = categories!.results.indexWhere(
                            (element) => element.categoryName == category);
                        categoryId = categories!.results[index].id.toString();
                      },
                      selectedItem: datas.first),
                )
              : Container(),
          SizedBox(
            height: 30,
          ),
          panchayathdatas.length > 0
              ? Neumorphic(
                  child: DropdownSearch<String>(
                      mode: Mode.DIALOG,
                      showSelectedItem: true,
                      showSearchBox: true,
                      items: panchayathdatas,
                      label: "",
                      hint: "Choose Shop Panchayath",
                      popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (data) {
                        category = data.toString();
                        int index = panchayaths!.results
                            .indexWhere((element) => element.name == category);
                        panchayathId =
                            panchayaths!.results[index].id.toString();
                      },
                      selectedItem: panchayathdatas.first),
                )
              : Container(),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Checkbox(
                    activeColor: Colors.white,
                    checkColor: purple,
                    onChanged: (value) {
                      checked = !checked;
                      setState(() {});
                    },
                    value: checked,
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, _, __) =>
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      child: ClipRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            color: Colors.black.withOpacity(.1),
                                            //
                                          ),
                                        ),
                                      ),
                                    ),
                                    Dialog(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .8,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 5,
                                                color: purple,
                                              ),
                                            ]),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Center(
                                                  child: Image.asset(
                                                      "assets/images/onfully.png")),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0,
                                                    left: 8,
                                                    bottom: 15),
                                                child: Text(
                                                  "Terms & Conditions",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum,Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Center(
                                                    child: CustomIcon(
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: purple,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        opaque: false));
                  },
                  child: Text(
                      "By Signing up , you agree to the Terms & Conditions"),
                ),
                flex: 7,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              if (nameController.text.toString().length == 0) {
                showToast("Name cannot be empty");
              } else if (checked == false) {
                showToast("Please accept the terms and conditions");
              } else if (emailController.text.toString().length == 0) {
                showToast("Email cannot be empty");
              } else if (shopName.text.toString().length == 0) {
                showToast("Shop Name cannot be empty");
              } else if (shopAddress.text.toString().length == 0) {
                showToast("Shop Address cannot be empty");
              } else if (pincode.text.toString().length == 0) {
                showToast("Pincode cannot be empty");
              } else if (distance.text.toString().length == 0) {
                showToast("Delivery distance cannot be empty");
              } else if (nameController.text.toString().length > 0 &&
                  emailController.text.toString().length > 0 &&
                  shopName.text.toString().length > 0 &&
                  shopAddress.text.toString().length > 0 &&
                  pincode.text.toString().length > 0 &&
                  distance.text.toString().length > 0 &&
                  checked == true) {
                getLoading(context);
                //send data to API
                User userData = await getPrefrenceUser("onfully_token");
                RegisterPojo pojo = RegisterPojo(
                    name: nameController.text.toString(),
                    email: emailController.text.toString(),
                    phoneNumber: widget.mobileNumber.toString(),
                    shopName: shopName.text.toString(),
                    shopAdddress: shopAddress.text.toString(),
                    pincode: pincode.text.toString(),
                    distance: distance.text.toString(),
                    categoryId: categoryId,
                    token: userData.token.toString(),
                    shopId: userData.shopID.toString(),
                    panchayathId: panchayathId.toString());

                LoginVM viewModel = LoginVM();
                String? message = await viewModel.registerUser(context, pojo);
                if (message == "Updated Successfully") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(),
                    ),
                    (route) => false,
                  );
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
        ],
      ),
    );
  }
}
