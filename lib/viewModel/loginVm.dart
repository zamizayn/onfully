import 'dart:convert';
import 'dart:developer';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/categories.dart';
import 'package:ecom_app/pojo/checkUserPojo.dart';
import 'package:ecom_app/pojo/downloadspojo.dart';
import 'package:ecom_app/pojo/otpResponse.dart';
import 'package:ecom_app/pojo/panchaythpojo.dart';
import 'package:ecom_app/pojo/profilepojo.dart';
import 'package:ecom_app/pojo/registerPojo.dart';
import 'package:ecom_app/pojo/subcategoriespojo.dart';
import 'package:ecom_app/services/webService.dart';
import 'package:flutter/cupertino.dart';

class LoginVM {
  WebService service = WebService();

  Future<CheckUser?> checkUser(
      String mobileNumber, BuildContext context) async {
    CheckUser checkUser;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {"phone_number": mobileNumber};
    final response = await service.postResponse(
        "shop/shop-number-verification/", body, headers);
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    checkUser = CheckUser.fromJson(map);
    //Navigator.pop(context);

    return checkUser;
  }

  Future<String?> saveToken(BuildContext context, String token) async {
    Categories categories;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {"notification_token": token};
    User user = await getPrefrenceUser(TOKENKEY);
    final response = await service.patchResponse(
        "shop/shop-registration/" + user.shopID + "/", body, headers);
    log("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    return 'categories';
  }

  Future<Downloads?> getDownloads(BuildContext context) async {
    Downloads checkUser;
    User user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {};
    final response = await service.getResponse(
        "shop/referals-under-shop/" + user.shopID + "/", body);
    print("downloads list" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    checkUser = Downloads.fromJson(map);
    //Navigator.pop(context);

    return checkUser;
  }

  Future<PanchayathPojo?> fetchPanchayath(BuildContext context) async {
    PanchayathPojo panchayathPojo;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {};
    final response = await service.getResponse("admin-panchayath/list/", body);
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    panchayathPojo = PanchayathPojo.fromJson(map);
    // Navigator.pop(context);

    return panchayathPojo;
  }

  Future<String?> changeStatus(BuildContext context, bool flag) async {
    PanchayathPojo panchayathPojo;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, dynamic> body = {'is_online': flag.toString()};
    User user = await getPrefrenceUser(TOKENKEY);
    final response = await service.patchResponse(
        "admin-panchayath/shop-change-status/" + user.shopID + "/",
        body,
        headers);
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    if (map['message'] == 'success') {
      showToast('Status updated successfully');
    }
    // panchayathPojo = PanchayathPojo.fromJson(map);
    // // Navigator.pop(context);

    return 'panchayathPojo';
  }

  Future<ProfilePojo?> getProfileDetails(BuildContext context) async {
    ProfilePojo profilePojo;
    User user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    // Map<String, String> body = {"phone_number": mobileNumber};
    final response = await service.getResponse(
        "shop/shop-registration/" + user.shopID, headers);
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    profilePojo = ProfilePojo.fromJson(map);
    Navigator.pop(context);

    return profilePojo;
  }

  Future<OtpResponse?> verifyOTP(
      String mobileNumber, String otp, BuildContext context) async {
    OtpResponse otpResponse;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {"phone_number": mobileNumber, "otp": otp};
    final response = await service.postResponse(
        "shop/shop-otp-verification/", body, headers);
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    otpResponse = OtpResponse.fromJson(map);
    Navigator.pop(context);

    return otpResponse;
  }

  Future<Categories?> fetchCategories(BuildContext context) async {
    Categories categories;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {};
    final response = await service.getResponse("category/category-list/", body);
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    categories = Categories.fromJson(map);

    return categories;
  }

  Future<SubcategoriesPojo?> subcategories(
      BuildContext context, String categoryId) async {
    SubcategoriesPojo categories;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {};
    final response = await service.getResponse(
        "category/sub-category-list/$categoryId/", body);
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    categories = SubcategoriesPojo.fromJson(map);
    Navigator.pop(context);

    return categories;
  }

  Future<String?> registerUser(BuildContext context, RegisterPojo pojo) async {
    String message;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {
      "name": pojo.name.toString(),
      "phone_number": pojo.phoneNumber,
      "pincode": pojo.pincode,
      "email": pojo.email,
      "address": pojo.shopAdddress,
      "delivery_distance": pojo.distance,
      "shop_category": pojo.categoryId,
      "shop_name": pojo.shopName,
      "panchayath": pojo.panchayathId
    };
    final response = await service.patchResponse(
        "shop/shop-registration/" + pojo.shopId + "/", body, headers);
    User user = User(
        shopID: pojo.shopId,
        name: pojo.name,
        email: pojo.email,
        token: pojo.token,
        isLogined: false,
        mobileNo: pojo.phoneNumber);
    setPrefrenceUser("onfully_token", user);
    Map<String, dynamic> map = json.decode(response.body);
    message = map["message"];
    print("RESPONEEEEE FROM TEMPLATESSSS" + response.toString());
    // Map<String, dynamic> map = json.decode(response.body);
    // categories = Categories.fromJson(map);
    // Navigator.pop(context);

    return message;
  }
}
