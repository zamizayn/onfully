import 'dart:convert';

import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/creditPojo.dart';
import 'package:ecom_app/services/webService.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ShopPaymentRepo {
  WebService service = WebService();

  Future<String?> savePaymentDetails(
      BuildContext context, String paymentId) async {
    String products;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    User user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {
      "shop_id": user.shopID,
      "payment_id": paymentId,
      "amount": "100"
    };

    final response = await service.postResponse(
        "digistore/pay-digistore-shop/", body, headers);
    var responseData = json.decode(response.body);
    if (responseData["message"] == "success") {
      showToast("Payment successfull");
      statusCheck(context);
    }
    Navigator.pop(context);

    return "products";
  }

  Future<String?> statusCheck(BuildContext context) async {
    getLoading(context);
    String products;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    User user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {
      "shop_id": user.shopID,
    };

    final response = await service.postResponse(
        "digistore/status-digistore-shop/", body, headers);
    Map<String, dynamic> responseData = json.decode(response.body);
    Provider.of<NotificationProvider>(context, listen: false).setIsDigistore(
        responseData["is_digistore"], responseData["digi_payment"]);
    Navigator.pop(context);

    return "products";
  }

  Future<String?> getLoanStatus(BuildContext context) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    User user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {
      "shop_id": user.shopID,
    };

    final response = await service.getResponse(
        "credit_details/list-credit-details/" + user.shopID + "/", headers);
    Map<String, dynamic> responseData = json.decode(response.body);
    CreditPojo pojo = CreditPojo.fromJson(responseData);
    Provider.of<NotificationProvider>(context, listen: false)
        .setCreditDetails(pojo);

    Navigator.pop(context);

    return "products";
  }
}
