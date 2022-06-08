// To parse this JSON data, do
//
//     final ordersPojo = ordersPojoFromJson(jsonString);

import 'dart:convert';

OrdersPojo ordersPojoFromJson(String str) =>
    OrdersPojo.fromJson(json.decode(str));

// String ordersPojoToJson(OrdersPojo data) => json.encode(data.toJson());

class OrdersPojo {
  OrdersPojo({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory OrdersPojo.fromJson(Map<String, dynamic> json) => OrdersPojo(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "count": count,
  //       "next": next,
  //       "previous": previous,
  //       "results": List<dynamic>.from(results.map((x) => x.toJson())),
  //     };
}

class Result {
  Result({
    required this.id,
    required this.customer,
    required this.shopDetails,
    required this.address,
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
    required this.isSelected
  });

  int id;
  Map customer;
  Map address;
  ShopDetails shopDetails;
  Product product;
  String count;
  String deliveryStatus;
  String paymentMode;
  DateTime createdOn;
  List<ResultImageDetail> imageDetails;
  DateTime updatedOn;
  dynamic categoryDetails;
  DateTime deliveredOn;
  DateTime dispatchedOn;
  DateTime acceptedOn;
  DateTime cancelledOn;
  DateTime returnedOn;
  bool isSelected;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        customer: json["customer"],
        isSelected: false,
        shopDetails: ShopDetails.fromJson(json["shop_details"]),
        address: json["address"] == null ? "" : json["address"],
        product: Product.fromJson(json["product"]),
        count: json["count"],
        deliveryStatus: json["delivery_status"],
        paymentMode: json["payment_mode"],
        createdOn: DateTime.parse(json["created_on"]),
        imageDetails: List<ResultImageDetail>.from(
            json["image_details"].map((x) => ResultImageDetail.fromJson(x))),
        updatedOn: DateTime.parse(json["updated_on"]),
        categoryDetails: json["category_details"],
        deliveredOn: DateTime.parse(json["delivered_on"]),
        dispatchedOn: DateTime.parse(json["dispatched_on"]),
        acceptedOn: DateTime.parse(json["accepted_on"]),
        cancelledOn: DateTime.parse(json["cancelled_on"]),
        returnedOn: DateTime.parse(json["returned_on"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "customer": customer,
  //       "shop_details": shopDetails.toJson(),
  //       "product": product.toJson(),
  //       "count": count,
  //       "delivery_status": deliveryStatusValues.reverse[deliveryStatus],
  //       "payment_mode": paymentModeValues.reverse[paymentMode],
  //       "created_on": createdOn.toIso8601String(),
  //       "image_details":
  //           List<dynamic>.from(imageDetails.map((x) => x.toJson())),
  //       "updated_on": updatedOn.toIso8601String(),
  //       "category_details": categoryDetails,
  //       "delivered_on": deliveredOn.toIso8601String(),
  //       "dispatched_on": dispatchedOn.toIso8601String(),
  //       "accepted_on": acceptedOn.toIso8601String(),
  //       "cancelled_on": cancelledOn.toIso8601String(),
  //       "returned_on": returnedOn.toIso8601String(),
  //     };
}

enum DeliveryStatus { PENDING }

// final deliveryStatusValues = EnumValues({"Pending": DeliveryStatus.PENDING});

class ResultImageDetail {
  ResultImageDetail({
    required this.id,
    required this.productImage,
  });

  int id;
  String productImage;

  factory ResultImageDetail.fromJson(Map<String, dynamic> json) =>
      ResultImageDetail(
        id: json["id"],
        productImage: json["product_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
      };
}

enum PaymentMode { COD, ONLINE }

// final paymentModeValues =
//     EnumValues({"COD": PaymentMode.COD, "ONLINE": PaymentMode.ONLINE});

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.stock,
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
  String stock;
  String discount;
  String description;
  ShopDetails shopDetails;
  CategoryDetails categoryDetails;
  List<ResultImageDetail> imageDetails;
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
        imageDetails: List<ResultImageDetail>.from(
            json["image_details"].map((x) => ResultImageDetail.fromJson(x))),
        returnPeriod: json["return_period"],
        returnable: json["returnable"],
        tagDetails: List<TagDetail>.from(
            json["tag_details"].map((x) => TagDetail.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": productNameValues.reverse[name],
  //       "price": price,
  //       "stock": stock,
  //       "description": descriptionValues.reverse[description],
  //       "shop_details": shopDetails.toJson(),
  //       "category_details": categoryDetails.toJson(),
  //       "image_details":
  //           List<dynamic>.from(imageDetails.map((x) => x.toJson())),
  //       "return_period": returnPeriod,
  //       "returnable": returnable,
  //       // "tag_details": List<dynamic>.from(tagDetails.map((x) => x.toJson())),
  //     };
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

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "category_name": categoryNameValues.reverse[categoryName],
  //     };
}

enum CategoryName { BAKERY, TEXTILES }

// final categoryNameValues = EnumValues(
//     {"Bakery": CategoryName.BAKERY, "Textiles": CategoryName.TEXTILES});

enum Description { NEW_PRODUCT, LAPTOP }

// final descriptionValues = EnumValues(
//     {"laptop": Description.LAPTOP, "new product": Description.NEW_PRODUCT});

enum ProductName { ONE_PLUS_NORD, LAPTOP }

// final productNameValues = EnumValues(
//     {"Laptop": ProductName.LAPTOP, "OnePlus Nord": ProductName.ONE_PLUS_NORD});

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

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": shopDetailsNameValues.reverse[name],
  //       "shop_name": shopNameValues.reverse[shopName],
  //       "phone_number": phoneNumber,
  //       "pincode": pincode,
  //       "email": emailValues.reverse[email],
  //       "address": addressValues.reverse[address],
  //       "delivery_distance": deliveryDistance,
  //       "shop_category": shopCategory,
  //       "image_details":
  //           List<dynamic>.from(imageDetails.map((x) => x.toJson())),
  //     };
}

enum Address { ST_GEORGE_BAKERS_KOZHENCHERRY }

// final addressValues = EnumValues(
//     {"St George bakers kozhencherry": Address.ST_GEORGE_BAKERS_KOZHENCHERRY});

enum Email { SHIJIN_MYPROJECTS_GMAIL_COM }

// final emailValues = EnumValues(
//     {"shijin.myprojects@gmail.com": Email.SHIJIN_MYPROJECTS_GMAIL_COM});

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

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "shop_image": shopImageValues.reverse[shopImage],
  //     };
}

enum ShopImage { MEDIA_MEDIA_DEFAULT_SHOP_JPEG }

// final shopImageValues = EnumValues({
//   "/media/media/default_shop.jpeg": ShopImage.MEDIA_MEDIA_DEFAULT_SHOP_JPEG
// });

enum ShopDetailsName { SHIJIN_M_SIMON }

// final shopDetailsNameValues =
//     EnumValues({"Shijin M Simon": ShopDetailsName.SHIJIN_M_SIMON});

enum ShopName { RINKU_SWEETS }

//final shopNameValues = EnumValues({"Rinku Sweets": ShopName.RINKU_SWEETS});

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

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "product_tag": productTagValues.reverse[productTag],
  //     };
}

enum ProductTag { BHH }

//final productTagValues = EnumValues({"bhh": ProductTag.BHH});

class EnumValues<T> {
  final Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues({required this.map});

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
