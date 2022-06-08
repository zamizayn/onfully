import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/otpResponse.dart';
import 'package:ecom_app/screens/dashboard.dart';
import 'package:ecom_app/screens/signup.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTP extends StatefulWidget {
  final bool flag;
  final String mobileNumber;
  const OTP({required this.flag, required this.mobileNumber});

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String otp = "";
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Neumorphic(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: deviceWidth * responsiveMargin()),
            child: Center(
              child: SingleChildScrollView(
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
                      "Authentication Required",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Enter One Time Password (OTP) sent to " +
                          widget.mobileNumber,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PinCodeTextField(
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 60,
                          selectedColor: purple,
                          activeFillColor: Colors.white,
                          activeColor: purple),
                      animationDuration: Duration(milliseconds: 300),
                      controller: otpController,
                      onCompleted: (v) async {
                        print("Completed");
                        otp = v.toString();
                        getLoading(context);
                        LoginVM vm = LoginVM();
                        OtpResponse? response = await vm.verifyOTP(
                            widget.mobileNumber, v.toString(), context);
                        if (response!.otpStatus == true &&
                            widget.flag == false) {
                          User user = User(
                              shopID: response.shopId.toString(),
                              name: "",
                              email: "",
                              isLogined: false,
                              token: response.token,
                              mobileNo: widget.mobileNumber);
                          setPrefrenceUser("onfully_token", user);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUP(
                                      mobileNumber: widget.mobileNumber,
                                    )),
                          );
                        }
                        if (response.otpStatus == true && widget.flag == true) {
                          User user = User(
                              shopID: response.shopId.toString(),
                              name: "",
                              email: "",
                              isLogined: true,
                              token: response.token,
                              mobileNo: widget.mobileNumber);
                          setPrefrenceUser(TOKENKEY, user);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Dashboard(),
                            ),
                            (route) => false,
                          );
                        }
                        if (response.otpStatus == false) {
                          showToast("Invalid OTP");
                        }
                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {});
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");

                        return true;
                      },
                      appContext: context,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (otp.length == 4) {
                          getLoading(context);
                          LoginVM vm = LoginVM();
                          OtpResponse? response = await vm.verifyOTP(
                              widget.mobileNumber, otp.toString(), context);
                          print("OTPPPP" + response.toString());
                          if (response!.otpStatus == true &&
                              widget.flag == false) {
                            User user = User(
                                shopID: response.shopId.toString(),
                                name: "",
                                email: "",
                                isLogined: false,
                                token: response.token,
                                mobileNo: widget.mobileNumber);
                            setPrefrenceUser("onfully_token", user);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUP(
                                        mobileNumber: widget.mobileNumber,
                                      )),
                            );
                          }
                          if (response.otpStatus == true &&
                              widget.flag == true) {
                            User user = User(
                                shopID: response.shopId.toString(),
                                name: "",
                                email: "",
                                isLogined: true,
                                token: response.token,
                                mobileNo: widget.mobileNumber);
                            setPrefrenceUser(TOKENKEY, user);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Dashboard(),
                              ),
                              (route) => false,
                            );
                          }
                          if (response.otpStatus == false) {
                            showToast("Invalid OTP");
                          }
                        } else {
                          showToast("Enter the correct OTP");
                        }
                      },
                      child: CustomIcon(
                          icon: Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
