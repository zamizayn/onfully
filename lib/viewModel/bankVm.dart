import 'dart:convert';

import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/bankpojo.dart';
import 'package:ecom_app/pojo/banks.dart';
import 'package:ecom_app/services/webService.dart';
import 'package:flutter/cupertino.dart';

class BankVm {
  WebService service = WebService();
  Future<String?> addBank(BuildContext context, BankPojo pojo) async {
    String message;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    User? user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {
      "holder_name": pojo.name,
      "shop": user.shopID,
      "bank_name": pojo.bankName,
      "account_number": pojo.accNo,
      "ifsc_code": pojo.ifsc,
      "branch": pojo.branch
    };
    //
    final response =
        await service.postResponse("banks/shop-bank-create/", body, headers);

    Navigator.pop(context);
    Navigator.pop(context, "success");
    showToast("Bank account added successfully");

    return "message";
  }

  Future<Banks?> listBanks(BuildContext context) async {
    Banks message;

    User? user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {};
    //
    final response = await service.getResponse(
        "banks/shop-bank-list/" + user.shopID + "/", body);
    Map<String, dynamic> map = json.decode(response.body);
    message = Banks.fromJson(map);
    Navigator.pop(context);

    return message;
  }

  Future<String?> removeBank(BuildContext context, String id) async {
    String message;

    User? user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {};
    //
    final response = await service.deleteResponse(
        "banks/update-shop-bank-details/" + id + "/", body);
    // Map<String, dynamic> map = json.decode(response.body);
    // message = Banks.fromJson(map);
    Navigator.pop(context);

    return "message";
  }
}
