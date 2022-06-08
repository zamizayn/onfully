import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/pojo/User.dart';
import 'package:ecom_app/pojo/addProduct.dart';
import 'package:ecom_app/pojo/productdetail.dart';
import 'package:ecom_app/pojo/productpojo.dart';
import 'package:ecom_app/services/webService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductsVM {
  WebService service = WebService();
  Future<String?> addproduct(
      BuildContext context, Product pojo, List<XFile> files) async {
    String? message;
    User data = await getPrefrenceUser(TOKENKEY);

    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    //dio.options.headers["Authorization"] = "Bearer " + data.token;

    List multipartImageList = [];
    if (pojo.incentive.length == 0) {
      pojo.incentive = "0";
    }
    multipartImageList = await getImages(files);
    FormData formData = FormData.fromMap({
      "image": multipartImageList,
      "category": pojo.category,
      "shop": data.shopID,
      "name": pojo.name,
      "price": pojo.price,
      "sub_category": pojo.subcategory,
      "purchased_rate": pojo.purchasingAmt,
      "stock": pojo.stock,
      "description": pojo.description,
      "returnable": pojo.return_flag,
      "return_period": pojo.returnData,
      "incentive": pojo.incentive,
      "discount": pojo.discount,
      "tags": json.encode(pojo.tags)
    });

    var response = await dio.post(
        "https://app.onfullymarketing.com/app/products/product-create/",
        data: formData);
    print("hgcghc" + response.data.toString());
    if (response.statusCode == 201) {
      message = "success";
    }

    return message;
  }

  Future<String?> addBanners(BuildContext context, List<XFile> files) async {
    String? message;
    User data = await getPrefrenceUser(TOKENKEY);

    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    //dio.options.headers["Authorization"] = "Bearer " + data.token;

    List multipartImageList = [];

    multipartImageList = await getImages(files);
    FormData formData = FormData.fromMap({
      "banner": multipartImageList,
    });

    var response = await dio.post(
        "https://onfullymarketing.com/shop/shop-banner-create/" +
            data.shopID +
            "/",
        data: formData);
    print("hgcghc" + response.data.toString());
    showToast("Banner added successfully");
    Navigator.pop(context);
    Navigator.pop(context, "success");
    if (response.statusCode == 200) {
      message = "success";
    }

    return message;
  }

  Future<String?> editImages(
      BuildContext context, List<XFile> files, String id) async {
    String? message;
    User data = await getPrefrenceUser(TOKENKEY);

    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    //dio.options.headers["Authorization"] = "Bearer " + data.token;

    List multipartImageList = [];

    multipartImageList = await getImages(files);
    FormData formData = FormData.fromMap({
      "image": multipartImageList,
    });

    var response = await dio.post(
        "https://onfullymarketing.com/products/create-product-image/$id/",
        data: formData);
    print("RESPPP" + response.statusCode.toString());
    Navigator.pop(context);
    showToast("Image updated successfully");
    Navigator.pop(context);

    if (response.statusCode == 201) {
      message = "success";
    }

    return message;
  }

  Future<String?> editShopImage(BuildContext context, XFile? file) async {
    String? message;
    User data = await getPrefrenceUser(TOKENKEY);

    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    //dio.options.headers["Authorization"] = "Bearer " + data.token;

    MultipartFile multipartImageList = await getSingleImage(file!);
    FormData formData = FormData.fromMap({
      "image": multipartImageList,
    });

    var response = await dio.post(
        "https://onfullymarketing.com/shop/shop-image-create/" +
            data.shopID +
            "/",
        data: formData);
    print("RESPONSEEEE" + response.statusCode.toString());
    if (response.statusCode == 200) {
      Navigator.pop(context);
      message = "success";
    }

    return message;
  }

  Future<String?> editShopLogo(BuildContext context, XFile? file) async {
    String? message;
    User data = await getPrefrenceUser(TOKENKEY);

    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    //dio.options.headers["Authorization"] = "Bearer " + data.token;

    MultipartFile multipartImageList = await getSingleImage(file!);
    FormData formData = FormData.fromMap({
      "logo": multipartImageList,
    });

    var response = await dio.post(
        "https://onfullymarketing.com/shop/shop-logo-update/" +
            data.shopID +
            "/",
        data: formData);
    print("RESPONSEEEE" + response.statusCode.toString());
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showToast('Logo updated successfully');
      message = "success";
    }

    return message;
  }

  Future<String?> editProduct(
      BuildContext context, Product pojo, String id) async {
    String? message;
    User data = await getPrefrenceUser(TOKENKEY);
    print("HERRRRRRR");
    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "applicaton/json";
    //dio.options.headers["Authorization"] = "Bearer " + data.token;

    List multipartImageList = [];

    FormData formData = FormData.fromMap({
      "category": pojo.category,
      "shop": data.shopID,
      "name": pojo.name,
      "price": pojo.price,
      "stock": pojo.stock,
      "description": pojo.description,
      "discount": pojo.discount,
      "returnable": pojo.return_flag,
      "incentive": pojo.incentive,
      "return_period": pojo.returnData,
    });

    var response = await dio.patch(
        "https://onfullymarketing.com/products/update-product-details/" +
            id +
            "/",
        data: formData);
    print("HGGCGHCGHC" + json.encode(pojo.tags).toString());
    if (response.statusCode == 200) {
      message = "success";
    }

    return message;
  }

  Future<List<MultipartFile>> getImages(List<XFile> files) async {
    List<MultipartFile> multipartImageList = [];

    for (int i = 0; i < files.length; i++) {
      MultipartFile file =
          await MultipartFile.fromFile(files[i].path, filename: files[i].name);
      multipartImageList.add(file);
    }
    return multipartImageList;
  }

  Future<MultipartFile> getSingleImage(XFile files) async {
    //  List<MultipartFile> multipartImageList = [];

    // for (int i = 0; i < files.length; i++) {
    MultipartFile file =
        await MultipartFile.fromFile(files.path, filename: files.name);
    // multipartImageList.add(file);

    return file;
  }

  Future<ProductPojo?> listProducts(BuildContext context) async {
    ProductPojo pojo;
    Map<String, String> headers = {};
    User? user = await getPrefrenceUser(TOKENKEY);
    final response = await service.getResponse(
        "products/product-list/" + user.shopID + "/", headers);

    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    pojo = ProductPojo.fromJson(map);

    return pojo;
  }

  Future<String?> removeImage(BuildContext context, String id) async {
    ProductPojo pojo;
    Map<String, String> headers = {};
    User? user = await getPrefrenceUser(TOKENKEY);
    final response = await service.deleteResponse(
        "products/update-product-image/" + id + "/", headers);

    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    // Map<String, dynamic> map = json.decode(response.body);
    // pojo = ProductPojo.fromJson(map);

    return "pojo";
  }

  Future<String?> removeBanner(BuildContext context, String id) async {
    String pojo;
    Map<String, String> headers = {};
    User? user = await getPrefrenceUser(TOKENKEY);
    final response = await service.deleteResponse(
        "shop/shop-banner-update/" + id + "/", headers);

    print("RESPONEEEEE FROM TEMPLATESSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    pojo = map["message"];

    return pojo;
  }

  Future<ProductDetailPojo?> getProductDetails(
      BuildContext context, String productId) async {
    ProductDetailPojo pojo;
    Map<String, String> headers = {};
    // User? user = await getPrefrenceUser(TOKENKEY);
    final response = await service.getResponse(
        "products/update-product-details/" + productId + "/", headers);
    print("DETAILSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    pojo = ProductDetailPojo.fromJson(map);

    return pojo;
  }

  Future<String?> removeproduct(BuildContext context, String productId) async {
    String message;
    Map<String, String> headers = {};
    // User? user = await getPrefrenceUser(TOKENKEY);
    final response = await service.deleteResponse(
        "products/update-product-details/" + productId + "/", headers);
    print("DETAILSSS" + response.body.toString());
    Map<String, dynamic> map = json.decode(response.body);
    message = map["message"];
    // pojo = ProductDetailPojo.fromJson(map);

    return message;
  }
}
