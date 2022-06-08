abstract class BaseService {
  final String BASEURL = "https://app.onfullymarketing.com/app/";
    static String IMAGEURL = "https://app.onfullymarketing.com/app";

  Future<dynamic> getResponse(String url, var headers);
  Future<dynamic> postResponse(String url, var body, var headers);
  Future<dynamic> putResponse(String url);
  Future<dynamic> deleteResponse(String url, var headers);
  Future<dynamic> patchResponse(String url, var body, var headers);
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised Request: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}
