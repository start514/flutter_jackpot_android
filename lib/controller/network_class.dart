import 'dart:async';

import 'package:dio/dio.dart';

class Network {
  static Dio dio = new Dio();

  Future<dynamic> postWithDio(
      {required String url,
      required Map<String, dynamic> body,
      Map<String, dynamic>? addHeaders}) {
    print(" POST URL          ==================  : $url");
    print(" POST BODY         ==================  : $body");

    if (addHeaders != null) {
      print(" POST HEADERS      ==================  : $addHeaders");
    }

    return dio
        .post(
      url,
      data: FormData.fromMap(body),
      options: Options(headers: addHeaders),
    )
        .then(
      (Response response) {
        int code = response.statusCode!;
        print("RESPONSE : $code...${response.data}");

        if (code < 200 || code > 400) {
          throw new Exception("Error While Posting Data");
        }
        return response.data;
      },
    );
  }

  Future<dynamic> getWithDio({required String url, Map? body, Map? addHeaders}) {
    print(" GET URL      ==================  : $url");

    if (body != null) {
      print(" GET BODY     ==================  : $body");
    }

    if (addHeaders != null) {
      print(" GET HEADERS  ==================  : $addHeaders");
    }

    return dio
        .get(url, queryParameters: body as Map<String, dynamic>?, options: Options(headers: addHeaders as Map<String, dynamic>?))
        .then(
      (Response response) {
        int code = response.statusCode!;
        print("RESPONSE : $code...${response.data}");

        if (code < 200 || code > 400) {
          throw new Exception("Error While Posting Data");
        }
        return response.data;
      },
    );
  }
}
