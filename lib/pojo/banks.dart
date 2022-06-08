// To parse this JSON data, do
//
//     final banks = banksFromJson(jsonString);

import 'dart:convert';

Banks banksFromJson(String str) => Banks.fromJson(json.decode(str));

String banksToJson(Banks data) => json.encode(data.toJson());

class Banks {
  Banks({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory Banks.fromJson(Map<String, dynamic> json) => Banks(
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
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branch,
    required this.holderName,
  });

  String bankName;
  String accountNumber;
  String ifscCode;
  String branch;
  String holderName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        branch: json["branch"],
        holderName: json["holder_name"],
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "branch": branch,
        "holder_name": holderName,
      };
}
