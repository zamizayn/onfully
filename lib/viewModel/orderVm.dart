import 'dart:convert';

import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/orderdetail.dart';
import 'package:ecom_app/pojo/orderspojo.dart';
import 'package:ecom_app/services/webService.dart';
import 'package:flutter/cupertino.dart';

class OrdersVm {
  WebService service = WebService();

  Future<OrdersPojo?> listOrders(BuildContext context) async {
    OrdersPojo message;

    User? user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {};
    //
    final response = await service.getResponse(
        "order_details/shop-order-details/" + user.shopID + "/", body);
    print("list orders" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    message = OrdersPojo.fromJson(map);
    Navigator.pop(context);

    return message;
  }

  Future<OrderDetailsPojo?> orderDetails(
      BuildContext context, String orderID) async {
    OrderDetailsPojo message;

    User? user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {};
    //
    final response = await service.getResponse(
        "order_details/update-shop-order/" + orderID + "/", body);
    print("list orders" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    message = OrderDetailsPojo.fromJson(map);
    Navigator.pop(context);

    return message;
  }

    Future<String?> listWallet(
      BuildContext context, String orderID) async {
    OrderDetailsPojo message;

    User? user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {};
    //
    final response = await service.getResponse(
        "order_details/update-shop-order/" + orderID + "/", body);
    print("list orders" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    message = OrderDetailsPojo.fromJson(map);
    Navigator.pop(context);

    return "message";
  }

  Future<String?> updateOrder(
      BuildContext context, String orderID, String status) async {
    String message;

    User? user = await getPrefrenceUser(TOKENKEY);
    Map<String, String> body = {"next_status": status};
    Map<String, String> headers = {};
    //
    final response = await service.patchResponse(
        "order_details/update-shop-order/" + orderID + "/", body, headers);
    print("order update" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    message = map["message"];
    // message = OrderDetailsPojo.fromJson(map);
    Navigator.pop(context);

    return message;
  }
}
