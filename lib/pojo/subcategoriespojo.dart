// To parse this JSON data, do
//
//     final subcategoriesPojo = subcategoriesPojoFromJson(jsonString);

import 'dart:convert';

SubcategoriesPojo subcategoriesPojoFromJson(String str) =>
    SubcategoriesPojo.fromJson(json.decode(str));

String subcategoriesPojoToJson(SubcategoriesPojo data) =>
    json.encode(data.toJson());

class SubcategoriesPojo {
  SubcategoriesPojo({
    required this.data,
  });

  List<Datum> data;

  factory SubcategoriesPojo.fromJson(Map<String, dynamic> json) =>
      SubcategoriesPojo(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryBanner,
  });

  int id;
  String categoryName;
  dynamic categoryImage;
  dynamic categoryBanner;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
        categoryBanner: json["category_banner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "category_image": categoryImage,
        "category_banner": categoryBanner,
      };
}
