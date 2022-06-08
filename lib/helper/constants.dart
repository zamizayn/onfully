import 'dart:convert';

import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

double deviceHeight = 0;
double deviceWidth = 0;
String TOKENKEY = "onfully_token";
String IMAGEURL = "https://app.onfullymarketing.com";
const String ONESIGNAL_KEY = "b478a8e9-6d8e-48f1-adee-ddd0f1be40d1";
const String MAPBOX_KEY =
    "pk.eyJ1Ijoic2hpamluOTA3MjEyNzc1OSIsImEiOiJja3Ric2x3NjAxejVxMm9uOTdkZ3N6cjJoIn0.6vNnhR9JnlHP6Hcq0X3MVQ";

const String logoUrl =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS_UM_NnYdGWlz51IxkO4gN3FVhpLihVpAsA&usqp=CAU";

double responsiveMargin() {
  if (kIsWeb) {
    if (deviceWidth < 650) {
      return 0.05;
    } else if (deviceWidth >= 650 && deviceWidth < 1100) {
      return 0.10;
    } else if (deviceWidth > 1100) {
      return 0.20;
    }
  } else {
    return 0.07;
  }
  return 0.07;
}

AppBar appBarContent(String title) {
  return AppBar(
    backgroundColor: purple,
    centerTitle: true,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16),
    ),
  );
}

setPrefrenceUser(String key, User value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = jsonEncode(User.fromJson(value.toJson()));
  print(".......set preference....44444.....$user.....");
  await prefs.setString('user', user);
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<User> getPrefrenceUser(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userString = prefs.getString('user');
  print(".......get preference....$userString....");
  if (userString != null) {
    Map userMap = jsonDecode(userString);
    return User.fromJson(userMap);
  } else {
    return User(
        shopID: '',
        name: '',
        email: '',
        mobileNo: '',
        token: '',
        isLogined: false);
  }
}
