import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Status { LOADING, SUCCESS, FAILED, IDLE }

class BaseModel extends ChangeNotifier {
  Status _status = Status.IDLE;
  String? _message;
  String? _searchText;
  bool? _isSearch;

  Status get getStatus => _status;

  String get getMessage => _message ?? "";

  String get getSearchText => _searchText?.trim() ?? "";

  bool get getSearchStatus => _isSearch ?? false;

  bool get isLoading => _status == Status.LOADING;

  Widget get getLoader {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(radius: 15),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                getMessage,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onNotify({Status? status, String? message}) {
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    notifyListeners();
  }
}

String handleError(error) {
  String errorDescription = "";
  if (error is DioError) {
    DioError dioError = error;
    switch (dioError.type) {
      case DioErrorType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioErrorType.other:
        errorDescription =
            "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        errorDescription =
            "Received invalid status code: ${dioError.response!.statusCode}";
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
    }
  } else {
    errorDescription = "Unexpected error occured";
  }
  return errorDescription;
}
