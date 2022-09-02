import 'dart:async';

import 'package:f_yc_utils/f_yc_utils.dart';

class YcApisResponseInterceptor {
  static FutureOr<dynamic> apiResponseInterceptor(
      Request request, Response response) async {
    return response;
  }
}
