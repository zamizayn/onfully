import 'dart:convert';
import 'dart:developer';

import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/listener.dart';
import 'package:ecom_app/listener/notifyProvider.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/services/webService.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DeliveryRepo {
  WebService service = WebService();

  Future<DelifveryBoys?> listDeliveryBoys(BuildContext context) async {
    DelifveryBoys products;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    Map<String, String> body = {};
    User user = await getPrefrenceUser(TOKENKEY);
    final response = await service.postResponse(
        "admin-panchayath/deliveryboy-list/" +
            Provider.of<ShopProvider>(context, listen: false)
                .panchayath
                .toString() +
            "/",
        body,
        headers);
    products = delifveryBoysFromJson(response.body);
    return products;
  }

  Future<String?> assignToDelivery(
      BuildContext context, String deliveryBoy) async {
    String products;
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    User user = await getPrefrenceUser(TOKENKEY);
    List<String> orders =
        Provider.of<NotificationProvider>(context, listen: false).orders;
    final removedBrackets =
        orders.toString().replaceAll("[", "").replaceAll("]", ",");
    Map<String, String> body = {
      'deliveryboy': deliveryBoy,
      'shop': user.shopID,
      'orderid': removedBrackets.substring(0, removedBrackets.length - 1)
    };

    final response =
        await service.postResponse("shop/save-delivery-orders/", body, headers);

    return 'products';
  }
}

DelifveryBoys delifveryBoysFromJson(String str) =>
    DelifveryBoys.fromJson(json.decode(str));

String delifveryBoysToJson(DelifveryBoys data) => json.encode(data.toJson());

class DelifveryBoys {
  DelifveryBoys({
    required this.results,
  });

  List<Result> results;

  factory DelifveryBoys.fromJson(Map<String, dynamic> json) => DelifveryBoys(
        results: List<Result>.from(json["data"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.isActive,
    required this.image,
    required this.panchayath,
    required this.notificationToken,
  });

  int id;
  String name;
  String phoneNumber;
  String email;
  dynamic address;
  bool isActive;
  String image;
  String panchayath;
  dynamic notificationToken;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        address: json["address"],
        isActive: json["is_active"],
        image: json["image"],
        panchayath: json["panchayath"],
        notificationToken: json["notification_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "email": email,
        "address": address,
        "is_active": isActive,
        "image": image,
        "panchayath": panchayath,
        "notification_token": notificationToken,
      };
}
