// To parse this JSON data, do
//
//     final checkUser = checkUserFromJson(jsonString);

import 'dart:convert';

CheckUser checkUserFromJson(String str) => CheckUser.fromJson(json.decode(str));

String checkUserToJson(CheckUser data) => json.encode(data.toJson());

class CheckUser {
  CheckUser(
      {required this.registerStatus,
      required this.message,
      required this.activeStatus});

  final bool registerStatus;
  final bool activeStatus;
  final String message;

  factory CheckUser.fromJson(Map<String, dynamic> json) => CheckUser(
      registerStatus: json["register_status"],
      message: json["message"],
      activeStatus: json["active_status"]);

  Map<String, dynamic> toJson() => {
        "register_status": registerStatus,
        "message": message,
      };
}
