import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/addProduct.dart';
import 'package:ecom_app/pojo/categories.dart';
import 'package:ecom_app/pojo/productdetail.dart';
import 'package:ecom_app/pojo/subcategoriespojo.dart';
import 'package:ecom_app/screens/editproductimages.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

import 'dashboard.dart';

class EditProduct extends StatefulWidget {
  final String productId;
  final String name;
  final String price;
  final String purchased;
  final String stock;
  final String returncontroller;
  final String description;
  List<TagDetail> tags = [];
  List<ImageDetail> images = [];
  final String category;
  final String incentive;
  final String discount;

  @override
  _EditProductState createState() => _EditProductState();
  EditProduct(
      {required this.productId,
      required this.name,
      required this.price,
      required this.stock,
      required this.returncontroller,
      required this.description,
      required this.purchased,
      required this.tags,
      required this.images,
      required this.category,
      required this.incentive,
      required this.discount});
}

class _EditProductState extends State<EditProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController returnController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController incentiveController = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController purchasing = TextEditingController();
  TextEditingController profit = TextEditingController();
  List<XFile>? images = [];
  List<String> savedImages = [];
  List<String> datas = [];
  Categories? categories;
  List<String> tags = [];
  String category = "";
  String categoryId = "";
  bool return_flag = false;
  List<String> subcats = [];
  SubcategoriesPojo? subcat;
  String subcategory = "";
  String subcategoryId = "";

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 0), () {
      loadCategories();
    });
    discountListen();
    discount.addListener(() {
      discountListen();
    });
    incentiveController.addListener(() {
      discountListen();
    });
    purchasing.addListener(() {
      discountListen();
    });
  }

  getSubcategories() async {
    subcats.clear();
    LoginVM viewModel = LoginVM();
    subcat = await viewModel.subcategories(context, categoryId);
    if (subcat!.data.length > 0) {
      subcategory = subcat!.data.first.id.toString();
      subcategoryId = subcat!.data.first.categoryName;
      subcat!.data.forEach((element) {
        subcats.add(element.categoryName);
      });
    } else {
      subcats.clear();
    }
    setState(() {});
  }

  loadCategories() async {
    LoginVM viewModel = LoginVM();
    getLoading(context);
    categories = await viewModel.fetchCategories(context);
    categories!.results.forEach((e) => datas.add(e.categoryName));
    int index = categories!.results
        .indexWhere((element) => element.categoryName == widget.category);
    category = widget.category;
    //categoryId = categories!.results[0].id.toString();
    categoryId = categories!.results.elementAt(index).id.toString();
    getSubcategories();
    print("JHVHJVHJV" + categoryId);
    nameController.text = widget.name;

    priceController.text = widget.price;
    descriptionController.text = widget.description;
    stockController.text = widget.stock;
    returnController.text = widget.returncontroller;
    incentiveController.text = widget.incentive;
    discount.text = widget.discount;
    purchasing.text = widget.purchased;
    if (returnController.text.toString().length > 0) {
      return_flag = true;
    }
    widget.tags.forEach((element) {
      tags.add(element.productTag);
    });
    setState(() {});
  }

  void discountListen() {
    if (purchasing.text.length > 0 &&
        discount.text.length > 0 &&
        incentiveController.text.length > 0) {
      String profitval = (int.parse(purchasing.text.toString()) -
              int.parse(discount.text.toString()) -
              int.parse(incentiveController.text.toString()))
          .toString();
      if (profitval.contains("-")) {
        profit.text = "0";
      } else {
        profit.text = profitval;
      }
      setState(() {});
    } else if (purchasing.text.length > 0 &&
        discount.text.length > 0 &&
        incentiveController.text.length == 0) {
      String profitval = (int.parse(purchasing.text.toString()) -
              int.parse(discount.text.toString()))
          .toString();
      if (profitval.contains("-")) {
        profit.text = "0";
      } else {
        profit.text = profitval;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("EDIT PRODUCT"),
      body: SafeArea(
        child: Neumorphic(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // customHeader(context, "EDIT PRODUCT"),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: deviceWidth * responsiveMargin()),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        datas.length > 0
                            ? SizedBox(
                                height: 50,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      border: NeumorphicBorder.none()),
                                  child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSelectedItem: true,
                                      dropdownSearchTextAlign: TextAlign.start,
                                      dropdownSearchTextAlignVertical:
                                          TextAlignVertical.top,
                                      showSearchBox: true,
                                      items: datas,
                                      label: "",
                                      hint: "Choose Shop Category",
                                      popupItemDisabled: (String s) =>
                                          s.startsWith('I'),
                                      onChanged: (data) {
                                        category = data.toString();
                                        int index = categories!.results
                                            .indexWhere((element) =>
                                                element.categoryName ==
                                                category);
                                        categoryId = categories!
                                            .results[index].id
                                            .toString();
                                        getLoading(context);
                                        getSubcategories();
                                      },
                                      selectedItem: widget.category),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 15,
                        ),
                        subcats.length > 0
                            ? SizedBox(
                                height: 50,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      border: NeumorphicBorder.none()),
                                  child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSelectedItem: true,
                                      dropdownSearchTextAlign: TextAlign.start,
                                      dropdownSearchTextAlignVertical:
                                          TextAlignVertical.top,
                                      showSearchBox: true,
                                      items: subcats,
                                      label: "",
                                      hint: "Choose Product SubCategory",
                                      popupItemDisabled: (String s) =>
                                          s.startsWith('I'),
                                      onChanged: (data) {
                                        subcategory = data.toString();
                                        int index = subcat!.data.indexWhere(
                                            (element) =>
                                                element.categoryName ==
                                                subcategory);
                                        subcategoryId =
                                            subcat!.data[index].id.toString();
                                      },
                                      selectedItem: subcats.first),
                                ),
                              )
                            : Container(),
                        subcats.length > 0
                            ? SizedBox(
                                height: 15,
                              )
                            : Container(),
                        CustomTextField(
                          controller: nameController,
                          isEnabled: true,
                          hint: "Enter your Product Name",
                          inputType: TextInputType.name,
                          formatters: [],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: purchasing,
                          isEnabled: true,
                          hint: "Enter your purchasing rate",
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: priceController,
                          isEnabled: true,
                          hint: "Enter MRP of product",
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: discount,
                          isEnabled: true,
                          hint: "Enter price on Onfully",
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: incentiveController,
                          isEnabled: true,
                          hint: "Enter your Product incentive",
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: profit,
                          isEnabled: false,
                          hint: "Profit from this product (single unit)",
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: stockController,
                          isEnabled: true,
                          hint: "Enter your Product Available Stock",
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Neumorphic(
                          child: TextField(
                            maxLines: 8,
                            keyboardType: TextInputType.name,
                            controller: descriptionController,
                            inputFormatters: [],
                            enabled: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Add description for your product",
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.all(10)),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              "Does this product has return period ?",
                              style: TextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            NeumorphicSwitch(
                              isEnabled: true,
                              value: return_flag,
                              height: 30,
                              onChanged: (boolval) {
                                return_flag = boolval;
                                if (return_flag == false) {
                                  returnController.text = "";
                                }
                                setState(() {});
                              },
                              style: NeumorphicSwitchStyle(
                                  activeThumbColor: Colors.green,
                                  activeTrackColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey,
                                  inactiveThumbColor: Colors.red),
                            ),
                          ],
                        ),
                        return_flag
                            ? SizedBox(
                                height: 15,
                              )
                            : Container(),
                        return_flag
                            ? CustomTextField(
                                controller: returnController,
                                isEnabled: true,
                                hint: "Enter Return Period (in Days) ",
                                inputType: TextInputType.number,
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (nameController.text.toString().length == 0) {
                              showToast("Please add name for the product");
                            } else if (priceController.text.toString().length ==
                                0) {
                              showToast(
                                  "Please enter the price of the product");
                            } else if (stockController.text.toString().length ==
                                0) {
                              showToast(
                                  "Please enter the stock of the product");
                            } else if (descriptionController.text
                                    .toString()
                                    .length ==
                                0) {
                              showToast("Please add description ");
                            } else if (return_flag == false &&
                                nameController.text.toString().length > 0 &&
                                priceController.text.toString().length > 0 &&
                                stockController.text.toString().length > 0 &&
                                descriptionController.text.toString().length >
                                    0) {
                              print("FIRST");
                              getLoading(context);
                              Product productPojo = Product(
                                  category: categoryId,
                                  subcategory: subcategoryId,
                                  purchasingAmt: purchasing.text.toString(),
                                  name: nameController.text.toString(),
                                  price: priceController.text.toString(),
                                  stock: stockController.text.toString(),
                                  discount: discount.text.toString(),
                                  return_flag: return_flag,
                                  incentive:
                                      incentiveController.text.toString(),
                                  tags: tags,
                                  description:
                                      descriptionController.text.toString(),
                                  returnData: returnController.text.toString());
                              String? response = await ProductsVM().editProduct(
                                  context, productPojo, widget.productId);
                              if (response == "success") {
                                Navigator.pop(context);

                                CoolAlert.show(
                                  context: context,
                                  confirmBtnColor: purple,
                                  type: CoolAlertType.success,
                                  onConfirmBtnTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Dashboard(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  widget: WillPopScope(
                                    child: Container(),
                                    onWillPop: () async => false,
                                  ),
                                  barrierDismissible: false,
                                  text:
                                      "You have edited your product successfully",
                                );
                              }
                            } else if (return_flag == true &&
                                nameController.text.toString().length > 0 &&
                                priceController.text.toString().length > 0 &&
                                descriptionController.text.toString().length >
                                    0 &&
                                stockController.text.toString().length > 0) {
                              print("SECOND");
                              if (returnController.text.toString().length > 0) {
                                getLoading(context);
                                Product productPojo = Product(
                                    category: categoryId,
                                    name: nameController.text.toString(),
                                    subcategory: subcategoryId,
                                    purchasingAmt: purchasing.text.toString(),
                                    price: priceController.text.toString(),
                                    discount: discount.text.toString(),
                                    tags: tags,
                                    stock: stockController.text.toString(),
                                    return_flag: return_flag,
                                    description:
                                        descriptionController.text.toString(),
                                    incentive:
                                        incentiveController.text.toString(),
                                    returnData:
                                        returnController.text.toString());
                                String? response = await ProductsVM()
                                    .editProduct(
                                        context, productPojo, widget.productId);
                                if (response == "success") {
                                  Navigator.pop(context);

                                  CoolAlert.show(
                                    context: context,
                                    confirmBtnColor: purple,
                                    widget: WillPopScope(
                                      child: Container(),
                                      onWillPop: () async => false,
                                    ),
                                    onConfirmBtnTap: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Dashboard(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    barrierDismissible: false,
                                    type: CoolAlertType.success,
                                    text:
                                        "You have edited your product successfully",
                                  );
                                }
                              } else {
                                showToast("Enter the return period");
                              }
                            }
                          },
                          child: CustomIcon(
                              icon: Icon(
                            Icons.check,
                            color: Colors.black,
                          )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProductImages(
                                        images: widget.images,
                                        id: widget.productId)));
                          },
                          child: Neumorphic(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "EDIT PRODUCT IMAGES",
                                style: TextStyle(
                                    color: purple, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
