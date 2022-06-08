// To parse this JSON data, do
//
//     final downloads = downloadsFromJson(jsonString);

import 'dart:convert';

Downloads downloadsFromJson(String str) => Downloads.fromJson(json.decode(str));

String downloadsToJson(Downloads data) => json.encode(data.toJson());

class Downloads {
  Downloads({
    required this.message,
    required this.data,
  });

  String message;
  List<Datum> data;

  factory Downloads.fromJson(Map<String, dynamic> json) => Downloads(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.referedBy,
    required this.notificationToken,
  });

  int id;
  String name;
  String phoneNumber;
  String email;
  String referedBy;
  dynamic notificationToken;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"] == null ? "" : json["name"],
        phoneNumber: json["phone_number"],
        email: json["email"] == null ? "" : json["email"],
        referedBy: json["refered_by"] == null ? "" : json["refered_by"],
        notificationToken: json["notification_token"] == null
            ? ""
            : json["notification_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "email": email,
        "refered_by": referedBy,
        "notification_token": notificationToken,
      };
}
