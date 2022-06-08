// To parse this JSON data, do
//
//     final profilePojo = profilePojoFromJson(jsonString);

import 'dart:convert';

ProfilePojo profilePojoFromJson(String str) =>
    ProfilePojo.fromJson(json.decode(str));

String profilePojoToJson(ProfilePojo data) => json.encode(data.toJson());

class ShopBanner {
  ShopBanner({
    required this.id,
    required this.banner,
    required this.isActive,
  });

  int id;
  String banner;
  bool isActive;

  factory ShopBanner.fromJson(Map<String, dynamic> json) => ShopBanner(
        id: json["id"],
        banner: json["banner"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "banner": banner,
        "is_active": isActive,
      };
}

class ProfilePojo {
  ProfilePojo(
      {required this.id,
      required this.name,
      required this.shop_name,
      required this.referal,
      required this.phoneNumber,
      required this.pincode,
      required this.email,
      required this.address,
      required this.deliveryDistance,
      required this.shopCategory,
      required this.imageDetails,
      required this.shopBanners,
      required this.panchayath,
      required this.isOnline,
      required this.shopLogo});

  int id;
  String name;
  String shop_name;
  String referal;
  dynamic phoneNumber;
  dynamic pincode;
  dynamic email;
  dynamic address;
  dynamic deliveryDistance;
  dynamic shopCategory;
  List<dynamic> imageDetails;
  dynamic panchayath;
  List<ShopBanner> shopBanners;
  dynamic shopLogo;
  bool isOnline;

  factory ProfilePojo.fromJson(Map<String, dynamic> json) => ProfilePojo(
      id: json["id"],
      name: json["name"],
      shop_name: json["shop_name"],
      referal: json["shop_referal_id"] == null ? "" : json["shop_referal_id"],
      phoneNumber: json["phone_number"],
      panchayath: json["panchayath"],
      pincode: json["pincode"],
      email: json["email"],
      address: json["address"],
      deliveryDistance: json["delivery_distance"],
      isOnline: json["is_online"],
      shopCategory: json["shop_category"],
      imageDetails: List<dynamic>.from(json["image_details"].map((x) => x)),
      shopBanners: json["shop_banners"] != null
          ? List<ShopBanner>.from(
              json["shop_banners"].map((x) => ShopBanner.fromJson(x)))
          : [],
      shopLogo: json['shop_logo'] != null
          ? json['shop_logo']
          : "/static/dashboard_templates/theme/assets/images/layout-2/logo/onfully.png");

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "pincode": pincode,
        "email": email,
        "address": address,
        "delivery_distance": deliveryDistance,
        "shop_category": shopCategory,
        "image_details": List<dynamic>.from(imageDetails.map((x) => x)),
        "shop_banners": List<dynamic>.from(shopBanners.map((x) => x.toJson())),
      };
}
