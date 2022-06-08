import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ecom_app/services/baseService.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class WebService extends BaseService {
  @override
  Future getResponse(String url, var headers) async {
    var logger = Logger();

    dynamic responseJson;
    try {
      responseJson = await http.get(Uri.parse(BASEURL + url));

      log("Logger is working!" + responseJson.body);
    } on Exception {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<http.Response> postResponse(String url, var body, var headers) async {
    print('headers' + body.toString());
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(BASEURL + url),
        body: body,
      );
      log('#########' + response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseJson = response;
      }
    } on Exception catch (e) {
      print(".......response....555555...$e....");

      var message = {"status": -1, "message": "request failed"};
      return http.Response(json.encode(message), HttpStatus.unauthorized);
    }

    return responseJson;
  }

  @override
  Future deleteResponse(String url, var headers) async {
    dynamic responseJson;
    try {
      responseJson = await http.delete(Uri.parse(BASEURL + url));
      print("HJVHJBHJ" + headers.toString());
    } on Exception {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future putResponse(String url) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patchResponse(String url, var body, var headers) async {
    log('body' + body.toString());
    var responseJson;
    try {
      final response = await http.patch(
        Uri.parse(BASEURL + url),
        body: body,
      );
      print('response' + body.toString() + response.body.toString());
      if (response.statusCode == 200) {
        responseJson = response;
      } else {
        responseJson = response;
      }
    } on Exception {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }
}
