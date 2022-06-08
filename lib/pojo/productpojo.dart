// To parse this JSON data, do
//
//     final productPojo = productPojoFromJson(jsonString);

import 'dart:convert';

ProductPojo productPojoFromJson(String str) =>
    ProductPojo.fromJson(json.decode(str));

String productPojoToJson(ProductPojo data) => json.encode(data.toJson());

class ProductPojo {
  ProductPojo({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<Result> results;

  factory ProductPojo.fromJson(Map<String, dynamic> json) => ProductPojo(
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
  Result(
      {required this.id,
      required this.name,
      required this.price,
      required this.stock,
      required this.purchased_rate,
      required this.discount,
      required this.description,
      required this.shopDetails,
      required this.returnable,
      required this.returnPeriod,
      required this.categoryDetails,
      required this.imageDetails,
      required this.tagDetails});

  final int id;
  final String name;
  final String price;
  final String stock;
  final String description;
  final String purchased_rate;
  final ShopDetails shopDetails;
  final bool returnable;
  final String discount;
  final String returnPeriod;
  final CategoryDetails categoryDetails;
  final List<ImageDetail> imageDetails;
  final dynamic tagDetails;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      stock: json["stock"],
      purchased_rate: json['purchased_rate'],
      discount: json["discount"] != null ? json["discount"] : "",
      description: json["description"],
      shopDetails: ShopDetails.fromJson(json["shop_details"]),
      returnable: json["returnable"],
      returnPeriod: json["return_period"],
      categoryDetails: CategoryDetails.fromJson(json["category_details"]),
      imageDetails: List<ImageDetail>.from(
          json["image_details"].map((x) => ImageDetail.fromJson(x))),
      tagDetails: json["tag_details"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "description": description,
        "shop_details": shopDetails.toJson(),
        "returnable": returnable,
        "return_period": returnPeriod,
        "category_details": categoryDetails.toJson(),
        "image_details":
            List<dynamic>.from(imageDetails.map((x) => x.toJson())),
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
  final dynamic productImage;

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
        pincode: json["pincode"] != null ? json["pincode"] : "",
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
