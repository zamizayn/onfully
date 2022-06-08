// To parse this JSON data, do
//
//     final productDetailPojo = productDetailPojoFromJson(jsonString);

import 'dart:convert';

ProductDetailPojo productDetailPojoFromJson(String str) =>
    ProductDetailPojo.fromJson(json.decode(str));

String productDetailPojoToJson(ProductDetailPojo data) =>
    json.encode(data.toJson());

class ProductDetailPojo {
  ProductDetailPojo(
      {required this.id,
      required this.name,
      required this.price,
      required this.incentive,
      required this.stock,
      required this.description,
      required this.shopDetails,
      required this.categoryDetails,
      required this.imageDetails,
      required this.returnPeriod,
      required this.returnable,
      required this.tagDetails,
      required this.discount,
      required this.purchased});

  final int id;
  final String name;
  final String price;
  final String incentive;
  String stock;
  final String description;
  final ShopDetails shopDetails;
  final CategoryDetails categoryDetails;
  final List<ImageDetail> imageDetails;
  final String returnPeriod;
  final bool returnable;
  final List<TagDetail> tagDetails;
  final String discount;
  final String purchased;

  factory ProductDetailPojo.fromJson(Map<String, dynamic> json) =>
      ProductDetailPojo(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        purchased: json["purchased_rate"] == null ? "" : json["purchased_rate"],
        incentive: json["incentive"] != null ? json["incentive"] : "0",
        stock: json["stock"],
        description: json["description"],
        shopDetails: ShopDetails.fromJson(json["shop_details"]),
        categoryDetails: CategoryDetails.fromJson(json["category_details"]),
        imageDetails: List<ImageDetail>.from(
            json["image_details"].map((x) => ImageDetail.fromJson(x))),
        returnPeriod: json["return_period"],
        returnable: json["returnable"],
        discount: json["discount"] != null ? json["discount"] : "0",
        tagDetails: List<TagDetail>.from(
            json["tag_details"].map((x) => TagDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "description": description,
        "shop_details": shopDetails.toJson(),
        "category_details": categoryDetails.toJson(),
        "image_details":
            List<dynamic>.from(imageDetails.map((x) => x.toJson())),
        "return_period": returnPeriod,
        "returnable": returnable,
        "tag_details": List<dynamic>.from(tagDetails.map((x) => x.toJson())),
      };
}

class CategoryDetails {
  CategoryDetails({
    required this.id,
    required this.categoryName,
  });

  final int id;
  final String categoryName;

  factory CategoryDetails.fromJson(Map<String, dynamic> json) =>
      CategoryDetails(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}

class ImageDetail {
  ImageDetail({
    required this.id,
    required this.productImage,
  });

  final int id;
  final String productImage;

  factory ImageDetail.fromJson(Map<String, dynamic> json) => ImageDetail(
        id: json["id"],
        productImage: json["product_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
      };
}

class ShopDetails {
  ShopDetails({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.pincode,
    required this.email,
    required this.address,
    required this.deliveryDistance,
    required this.shopCategory,
    required this.imageDetails,
  });

  final int id;
  final String name;
  final String phoneNumber;
  final String pincode;
  final String email;
  final String address;
  final int deliveryDistance;
  final int shopCategory;
  final List<dynamic> imageDetails;

  factory ShopDetails.fromJson(Map<String, dynamic> json) => ShopDetails(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        pincode: json["pincode"],
        email: json["email"],
        address: json["address"],
        deliveryDistance: json["delivery_distance"],
        shopCategory: json["shop_category"],
        imageDetails: List<dynamic>.from(json["image_details"].map((x) => x)),
      );

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
      };
}

class TagDetail {
  TagDetail({
    required this.id,
    required this.productTag,
  });

  final int id;
  final String productTag;

  factory TagDetail.fromJson(Map<String, dynamic> json) => TagDetail(
        id: json["id"],
        productTag: json["product_tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_tag": productTag,
      };
}
