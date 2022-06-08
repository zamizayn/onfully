class User {
  String shopID;
  String name;
  String email;
  String token;
  String mobileNo;
  bool isLogined;

  User(
      {required this.shopID,
      required this.name,
      required this.email,
      required this.token,
      required this.mobileNo,
      required this.isLogined});

  static User fromJson(Map<dynamic, dynamic> json) {
    return new User(
        shopID: json["shopID"] ?? -1,
        mobileNo: json["mobileNo"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        token: json["token"] ?? 1,
        isLogined: json["isLogined"] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      "shopID": this.shopID,
      "mobileNo": this.mobileNo,
      "name": this.name,
      "email": this.email,
      "token": this.token,
      "isLogined": this.isLogined
    };
  }
}
