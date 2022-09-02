import 'dart:async';
import 'package:f_yc_utils/f_yc_utils.dart';

class ApisRequestInterceptor {
  static FutureOr<Request> apiRequestInterceptor(Request request) async {
    if (request.headers['showLoading'] == "true") {
      LoadingUtils.show();
    }
    return request;
  }
}
