import 'dart:async';
import 'package:f_yc_utils/f_yc_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FYcApisRequestInterceptor {
  static FutureOr<Request> apiRequestInterceptor(Request request) async {
    if (request.headers['isLoading'] == "true") {
      EasyLoading.show(status: '加载中...');
    }
    return request;
  }
}
