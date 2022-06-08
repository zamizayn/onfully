class Product {
  String category;
  String subcategory;
  String purchasingAmt;
  String name;
  String price;
  String stock;
  bool return_flag;
  String returnData;
  String description;
  List<String> tags;
  String incentive;
  String discount;

  Product(
      {required this.category,
      required this.name,
      required this.subcategory,
      required this.purchasingAmt,
      required this.price,
      required this.stock,
      required this.return_flag,
      required this.description,
      required this.returnData,
      required this.tags,
      required this.incentive,
      required this.discount});
}
