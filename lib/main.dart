import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/listener.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/checkUserPojo.dart';
import 'package:ecom_app/screens/dashboard.dart';
import 'package:ecom_app/screens/otp.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ShopProvider()),
    ChangeNotifierProvider(create: (context) => NotificationProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'rale'),
          home: Splash(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      color: background,
      width: deviceWidth,
      child: Scaffold(
        backgroundColor: background,
        body: Neumorphic(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: deviceWidth * responsiveMargin()),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/onfully.png"),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    controller: number,
                    hint: "Enter your phone number",
                    isEnabled: true,
                    inputType: TextInputType.number,
                    formatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (number.text.toString().length == 10) {
                        getLoading(context);
                        LoginVM loginVm = LoginVM();
                        CheckUser? pojo = await loginVm.checkUser(
                            number.text.toString(), context);
                        Navigator.pop(context);
                        if (pojo != null &&
                            pojo.registerStatus == false &&
                            pojo.activeStatus == false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTP(
                                    flag: pojo.registerStatus,
                                    mobileNumber: number.text.toString())),
                          );
                        } else if (pojo != null &&
                            pojo.registerStatus == true &&
                            pojo.activeStatus == false) {
                          //  showToast("Shop is not activated yet");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTP(
                                      flag: true,
                                      mobileNumber: number.text.toString())));
                        } else if (pojo != null &&
                            pojo.registerStatus == true &&
                            pojo.activeStatus == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTP(
                                      flag: pojo.activeStatus,
                                      mobileNumber: number.text.toString())));
                        }
                      }
                      if (number.text.toString().length < 10) {
                        showToast("Please enter valid number");
                      }
                    },
                    child: CustomIcon(
                        icon: Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLogined();
  }

  void checkLogined() async {
    User user = await getPrefrenceUser("onfully_token");

    Future.delayed(Duration(seconds: 3), () {
      if (user.isLogined == false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(),
          ),
          (route) => false,
        );
      }
      if (user.isLogined == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Dashboard(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(child: Image.asset("assets/images/onfully.png")),
    );
  }
}
