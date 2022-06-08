import 'dart:developer';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/addProduct.dart';
import 'package:ecom_app/pojo/categories.dart';
import 'package:ecom_app/pojo/subcategoriespojo.dart';
import 'package:ecom_app/viewModel/loginVm.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController purchasingAmt = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController returnController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController incentiveController = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController profit = TextEditingController();
  bool return_flag = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];
  Categories? categories;
  String category = "";
  String categoryId = "";
  List<String> datas = [];
  List<String> subcats = [];
  List<String> tags = [];
  SubcategoriesPojo? subcat;
  String subcategory = "";
  String subcategoryId = "";

  void addImages() async {
    PermissionStatus storageAccess = await Permission.storage.status;
    if (storageAccess.isGranted) {
      List<XFile>? imgs = await _picker.pickMultiImage(imageQuality: 50);
      imgs!.forEach((element) {
        images!.add(element);
      });
      print("IMAGES" + images!.length.toString());
      setState(() {});
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  void addImageFromCamera() async {
    PermissionStatus cameraAccess = await Permission.camera.status;
    if (cameraAccess.isGranted) {
      PickedFile? img = await ImagePicker.platform
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      XFile file = XFile(img!.path);
      images!.add(file);
      setState(() {});
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
    }
  }

  void chooseType(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            color: Colors.white,
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pick Image by using two options"),
                  SizedBox(
                    height: 20,
                  ),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            addImageFromCamera();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                size: 50,
                              ),
                              Text("CAMERA")
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("OR")],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            addImages();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Text("GALLERY")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    new Future.delayed(new Duration(seconds: 0), () {
      loadCategories();
    });
    discount.addListener(() {
      discountListen();
    });
    incentiveController.addListener(() {
      discountListen();
    });
    purchasingAmt.addListener(() {
      discountListen();
    });
  }

  void discountListen() {
    log('eneterdd');
    if (purchasingAmt.text.length > 0 &&
        discount.text.length > 0 &&
        incentiveController.text.length > 0) {
      String profitval = (int.parse(purchasingAmt.text.toString()) -
              int.parse(discount.text.toString()) -
              int.parse(incentiveController.text.toString()))
          .toString();
      if (profitval.contains("-")) {
        profit.text = "0";
      } else {
        profit.text = profitval;
      }
      setState(() {});
    } else if (purchasingAmt.text.length > 0 &&
        discount.text.length > 0 &&
        incentiveController.text.length == 0) {
      String profitval = (int.parse(purchasingAmt.text.toString()) -
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

  loadCategories() async {
    LoginVM viewModel = LoginVM();
    getLoading(context);
    categories = await viewModel.fetchCategories(context);
    categories!.results.forEach((e) => datas.add(e.categoryName));
    category = datas.first;
    categoryId = categories!.results[0].id.toString();
    getSubcategories();
    setState(() {});
  }

  getSubcategories() async {
    subcats.clear();
    LoginVM viewModel = LoginVM();
    subcat = await viewModel.subcategories(context, categoryId);
    if (subcat!.data.length > 0) {
      subcategory = subcat!.data.first.categoryName.toString();
      subcategoryId = subcat!.data.first.id.toString();
      print("SUB" + subcategoryId);
      subcat!.data.forEach((element) {
        subcats.add(element.categoryName);
      });
    } else {
      subcats.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("ADD PRODUCT"),
      body: SafeArea(
        child: Neumorphic(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                //     customHeader(context, "ADD PRODUCT"),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: deviceWidth * responsiveMargin()),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          //  addImages();
                          chooseType(context);
                        },
                        child: Neumorphic(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Add Images")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      images!.length > 0
                          ? Container(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: images!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Stack(
                                              children: [
                                                Image.file(
                                                  File(images![index].path),
                                                  height: 80,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 5,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      images!.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .remove_circle_outline_sharp,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : Container(),
                      images!.length > 0
                          ? SizedBox(
                              height: 15,
                            )
                          : Container(),
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
                                              element.categoryName == category);
                                      categoryId = categories!.results[index].id
                                          .toString();
                                      getLoading(context);
                                      getSubcategories();
                                    },
                                    selectedItem: datas.first),
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
                                      getLoading(context);
                                      getSubcategories();
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
                        controller: purchasingAmt,
                        isEnabled: true,
                        hint: "Enter your Purchasing Rate",
                        inputType: TextInputType.number,
                        formatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: priceController,
                        isEnabled: true,
                        hint: "Enter MRP of your product",
                        inputType: TextInputType.number,
                        formatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: discount,
                        isEnabled: true,
                        hint: "Price in Onfully",
                        inputType: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(
                              new RegExp(r"\s\b|\b\s"))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: incentiveController,
                        isEnabled: true,
                        hint: "Enter incentive for your product",
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
                      Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: CustomTextField(
                              controller: tagsController,
                              isEnabled: true,
                              hint: "Add tags for your product (Optional)",
                              inputType: TextInputType.name,
                              formatters: [],
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Neumorphic(
                              child: GestureDetector(
                                onTap: () {
                                  if (tagsController.text.toString().length >
                                      0) {
                                    tags.add(tagsController.text.toString());
                                    tagsController.text = "";
                                    print("TAGGGSSS" + tags.length.toString());
                                    setState(() {});
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Icon(Icons.add)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: tags.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8),
                                    child: Container(
                                      height: 50,
                                      child: Neumorphic(
                                          child: Center(
                                              child: Text(
                                        tags[index],
                                        textAlign: TextAlign.left,
                                      ))),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        tags.removeAt(index);
                                        setState(() {});
                                      },
                                      child: Neumorphic(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            );
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (nameController.text.toString().length == 0) {
                            showToast("Please add name for the product");
                          } else if (discount.text.toString().length == 0) {
                            showToast(
                                "Please add price for product in Onfully");
                          } else if (priceController.text.toString().length ==
                              0) {
                            showToast("Please enter the price of the product");
                          } else if (stockController.text.toString().length ==
                              0) {
                            showToast("Please enter the stock of the product");
                          } else if (int.parse(discount.text.toString()) >
                              int.parse(priceController.text.toString())) {
                            showToast(
                                "Discounted price must be lesser than the original price");
                          } else if (images!.length == 0) {
                            showToast("Please add images");
                          } else if (descriptionController.text
                                  .toString()
                                  .length ==
                              0) {
                            showToast("Please add description ");
                          } else if (return_flag == false &&
                              nameController.text.toString().length > 0 &&
                              priceController.text.toString().length > 0 &&
                              stockController.text.toString().length > 0 &&
                              int.parse(discount.text.toString()) <=
                                  int.parse(priceController.text.toString()) &&
                              descriptionController.text.toString().length >
                                  0 &&
                              images!.length > 0) {
                            getLoading(context);
                            print("suvcart" + subcategoryId);
                            Product productPojo = Product(
                                category: categoryId,
                                subcategory: subcategoryId,
                                purchasingAmt: purchasingAmt.text.toString(),
                                name: nameController.text.toString(),
                                price: priceController.text.toString(),
                                stock: stockController.text.toString(),
                                return_flag: return_flag,
                                incentive: incentiveController.text.toString(),
                                tags: tags,
                                discount: discount.text.toString(),
                                description:
                                    descriptionController.text.toString(),
                                returnData: returnController.text.toString());
                            String? response = await ProductsVM()
                                .addproduct(context, productPojo, images!);
                            if (response == "success") {
                              Navigator.pop(context);

                              CoolAlert.show(
                                context: context,
                                confirmBtnColor: purple,
                                type: CoolAlertType.success,
                                onConfirmBtnTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context, "added");
                                },
                                widget: WillPopScope(
                                  child: Container(),
                                  onWillPop: () async => false,
                                ),
                                barrierDismissible: false,
                                text:
                                    "You have added your product successfully",
                              );
                            }
                          } else if (return_flag == true &&
                              nameController.text.toString().length > 0 &&
                              priceController.text.toString().length > 0 &&
                              descriptionController.text.toString().length >
                                  0 &&
                              images!.length > 0 &&
                              stockController.text.toString().length > 0) {
                            if (returnController.text.toString().length > 0) {
                              getLoading(context);
                              Product productPojo = Product(
                                  category: categoryId,
                                  subcategory: subcategoryId,
                                  purchasingAmt: purchasingAmt.text.toString(),
                                  name: nameController.text.toString(),
                                  price: priceController.text.toString(),
                                  tags: tags,
                                  stock: stockController.text.toString(),
                                  return_flag: return_flag,
                                  discount: discount.text.toString(),
                                  incentive:
                                      incentiveController.text.toString(),
                                  description:
                                      descriptionController.text.toString(),
                                  returnData: returnController.text.toString());
                              String? response = await ProductsVM()
                                  .addproduct(context, productPojo, images!);
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
                                    Navigator.pop(context);
                                    Navigator.pop(context, "added");
                                  },
                                  barrierDismissible: false,
                                  type: CoolAlertType.success,
                                  text:
                                      "You have added your product successfully",
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
