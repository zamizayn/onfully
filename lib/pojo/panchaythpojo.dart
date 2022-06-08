// To parse this JSON data, do
//
//     final panchayathPojo = panchayathPojoFromJson(jsonString);

import 'dart:convert';

PanchayathPojo panchayathPojoFromJson(String str) =>
  PanchayathPojo.fromJson(json.decode(str));

String panchayathPojoToJson(PanchayathPojo data) => json.encode(data.toJson());

class PanchayathPojo {
PanchayathPojo({
  required this.count,
  required this.next,
  required this.previous,
  required this.results,
});

int count;
dynamic next;
dynamic previous;
List<Result> results;

factory PanchayathPojo.fromJson(Map<String, dynamic> json) => PanchayathPojo(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
      results:
          List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

Map<String, dynamic> toJson() => {
      "count": count,
      "next": next,
      "previous": previous,
      "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
Result({
  required this.id,
  required this.name,
  required this.adminControllerName,
  required this.phoneNumber,
  required this.email,
  required this.address,
  required this.pincodes,
});

int id;
String name;
String adminControllerName;
String phoneNumber;
String email;
String address;
String pincodes;

factory Result.fromJson(Map<String, dynamic> json) => Result(
      id: json["id"],
      name: json["name"],
      adminControllerName: json["admin_controller_name"],
      phoneNumber: json["phone_number"],
      email: json["email"],
      address: json["address"],
      pincodes: json["pincodes"],
    );

Map<String, dynamic> toJson() => {
      "id": id,
      "name": name,
      "admin_controller_name": adminControllerName,
      "phone_number": phoneNumber,
      "email": email,
      "address": address,
      "pincodes": pincodes,
    };
}
