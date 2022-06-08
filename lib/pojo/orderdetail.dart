// To parse this JSON data, do
//
//     final orderDetails = orderDetailsFromJson(jsonString);

import 'dart:convert';

OrderDetailsPojo orderDetailsFromJson(String str) =>
    OrderDetailsPojo.fromJson(json.decode(str));

String orderDetailsToJson(OrderDetailsPojo data) => json.encode(data.toJson());

class OrderDetailsPojo {
  OrderDetailsPojo({
    required this.id,
    required this.customer,
    required this.shopDetails,
    required this.cusaddress,
    required this.product,
    required this.count,
    required this.deliveryStatus,
    required this.paymentMode,
    required this.createdOn,
    required this.imageDetails,
    required this.updatedOn,
    required this.categoryDetails,
    required this.deliveredOn,
    required this.dispatchedOn,
    required this.acceptedOn,
    required this.cancelledOn,
    required this.returnedOn,
  });

  int id;
  Map customer;
  ShopDetails shopDetails;
  Map cusaddress;
  Product product;
  String count;
  String deliveryStatus;
  String paymentMode;
  DateTime createdOn;
  List<OrderDetailsImageDetail> imageDetails;
  DateTime updatedOn;
  dynamic categoryDetails;
  DateTime deliveredOn;
  DateTime dispatchedOn;
  DateTime acceptedOn;
  DateTime cancelledOn;
  DateTime returnedOn;

  factory OrderDetailsPojo.fromJson(Map<String, dynamic> json) =>
      OrderDetailsPojo(
        id: json["id"],
        customer: json["customer"],
        shopDetails: ShopDetails.fromJson(json["shop_details"]),
        cusaddress: json["address"],
        product: Product.fromJson(json["product"]),
        count: json["count"],
        deliveryStatus: json["delivery_status"],
        paymentMode: json["payment_mode"],
        createdOn: DateTime.parse(json["created_on"]),
        imageDetails: List<OrderDetailsImageDetail>.from(json["image_details"]
            .map((x) => OrderDetailsImageDetail.fromJson(x))),
        updatedOn: DateTime.parse(json["updated_on"]),
        categoryDetails: json["category_details"],
        deliveredOn: DateTime.parse(json["delivered_on"]),
        dispatchedOn: DateTime.parse(json["dispatched_on"]),
        acceptedOn: DateTime.parse(json["accepted_on"]),
        cancelledOn: DateTime.parse(json["cancelled_on"]),
        returnedOn: DateTime.parse(json["returned_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer": customer,
        "shop_details": shopDetails.toJson(),
        "product": product.toJson(),
        "count": count,
        "delivery_status": deliveryStatus,
        "payment_mode": paymentMode,
        "created_on": createdOn.toIso8601String(),
        "image_details":
            List<dynamic>.from(imageDetails.map((x) => x.toJson())),
        "updated_on": updatedOn.toIso8601String(),
        "category_details": categoryDetails,
        "delivered_on": deliveredOn.toIso8601String(),
        "dispatched_on": dispatchedOn.toIso8601String(),
        "accepted_on": acceptedOn.toIso8601String(),
        "cancelled_on": cancelledOn.toIso8601String(),
        "returned_on": returnedOn.toIso8601String(),
      };
}

class OrderDetailsImageDetail {
  OrderDetailsImageDetail({
    required this.id,
    required this.productImage,
  });

  int id;
  String productImage;

  factory OrderDetailsImageDetail.fromJson(Map<String, dynamic> json) =>
      OrderDetailsImageDetail(
        id: json["id"],
        productImage: json["product_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.discount,
    required this.description,
    required this.shopDetails,
    required this.categoryDetails,
    required this.imageDetails,
    required this.returnPeriod,
    required this.returnable,
    required this.tagDetails,
  });

  int id;
  String name;
  String price;
  String discount;
  String stock;
  String description;
  ShopDetails shopDetails;
  CategoryDetails categoryDetails;
  List<OrderDetailsImageDetail> imageDetails;
  String returnPeriod;
  bool returnable;
  List<TagDetail> tagDetails;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        discount: json["discount"] == null ? "" : json["discount"],
        stock: json["stock"],
        description: json["description"],
        shopDetails: ShopDetails.fromJson(json["shop_details"]),
        categoryDetails: CategoryDetails.fromJson(json["category_details"]),
        imageDetails: List<OrderDetailsImageDetail>.from(json["image_details"]
            .map((x) => OrderDetailsImageDetail.fromJson(x))),
        returnPeriod: json["return_period"],
        returnable: json["returnable"],
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

  int id;
  String categoryName;

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

class ShopDetails {
  ShopDetails({
    required this.id,
    required this.name,
    required this.shopName,
    required this.phoneNumber,
    required this.pincode,
    required this.email,
    required this.address,
    required this.deliveryDistance,
    required this.shopCategory,
    required this.imageDetails,
  });

  int id;
  String name;
  String shopName;
  String phoneNumber;
  String pincode;
  String email;
  String address;
  int deliveryDistance;
  int shopCategory;
  List<ShopDetailsImageDetail> imageDetails;

  factory ShopDetails.fromJson(Map<String, dynamic> json) => ShopDetails(
        id: json["id"],
        name: json["name"],
        shopName: json["shop_name"],
        phoneNumber: json["phone_number"],
        pincode: json["pincode"],
        email: json["email"],
        address: json["address"],
        deliveryDistance: json["delivery_distance"],
        shopCategory: json["shop_category"],
        imageDetails: List<ShopDetailsImageDetail>.from(json["image_details"]
            .map((x) => ShopDetailsImageDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "shop_name": shopName,
        "phone_number": phoneNumber,
        "pincode": pincode,
        "email": email,
        "address": address,
        "delivery_distance": deliveryDistance,
        "shop_category": shopCategory,
        "image_details":
            List<dynamic>.from(imageDetails.map((x) => x.toJson())),
      };
}

class ShopDetailsImageDetail {
  ShopDetailsImageDetail({
    required this.id,
    required this.shopImage,
  });

  int id;
  String shopImage;

  factory ShopDetailsImageDetail.fromJson(Map<String, dynamic> json) =>
      ShopDetailsImageDetail(
        id: json["id"],
        shopImage: json["shop_image"] != null ? json["shop_image"] : "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_image": shopImage,
      };
}

class TagDetail {
  TagDetail({
    required this.id,
    required this.productTag,
  });

  int id;
  String productTag;

  factory TagDetail.fromJson(Map<String, dynamic> json) => TagDetail(
        id: json["id"],
        productTag: json["product_tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_tag": productTag,
      };
}
