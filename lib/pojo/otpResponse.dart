// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OtpResponse otpResponseFromJson(String str) =>
    OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  OtpResponse({
    required this.shopId,
    required this.otpStatus,
    required this.message,
    required this.token,
  });

  final int shopId;
  final bool otpStatus;
  final String message;
  final String token;

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
        shopId: json["shop_id"] != null ? json["shop_id"] : 0,
        otpStatus: json["otp_status"],
        message: json["message"],
        token: json["token"] != null ? json["token"] : "",
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "otp_status": otpStatus,
        "message": message,
        "token": token,
      };
}
