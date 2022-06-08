// To parse this JSON data, do
//
//     final creditPojo = creditPojoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreditPojo creditPojoFromJson(String str) =>
    CreditPojo.fromJson(json.decode(str));

String creditPojoToJson(CreditPojo data) => json.encode(data.toJson());

class CreditPojo {
  CreditPojo({
    required this.data,
    required this.totalAmountRepaid,
    required this.equatedAmount,
  });

  List<dynamic> data;
  TotalAmountRepaid totalAmountRepaid;
  dynamic equatedAmount;

  factory CreditPojo.fromJson(Map<String, dynamic> json) => CreditPojo(
        data: List<dynamic>.from(json["data"].map((x) => x)),
        totalAmountRepaid:
            TotalAmountRepaid.fromJson(json["total_amount_repaid"]),
        equatedAmount: json["equated_amount"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
        "total_amount_repaid": totalAmountRepaid.toJson(),
        "equated_amount": equatedAmount,
      };
}

class TotalAmountRepaid {
  TotalAmountRepaid({
    @required this.asFloatSum,
  });

  dynamic asFloatSum;

  factory TotalAmountRepaid.fromJson(Map<String, dynamic> json) =>
      TotalAmountRepaid(
        asFloatSum: json["as_float__sum"],
      );

  Map<String, dynamic> toJson() => {
        "as_float__sum": asFloatSum,
      };
}
