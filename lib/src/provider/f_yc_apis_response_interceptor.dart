import 'dart:async';
import 'package:f_yc_utils/f_yc_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FYcApisResponseInterceptor {
  static FutureOr<dynamic> apiResponseInterceptor(
      Request request, Response response) async {
    if (GetUtils.isNull(response)) {
      return null;
    }
    if (!response.isOk) {
      EasyLoading.showError('请求失败，请稍后重试！');
      return null;
    }
    if (response.statusCode != 200) {
      EasyLoading.showError('请求失败，请稍后重试！');
      return null;
    } else {
      var token = response.body["token"];
      var tokenExpired = response.body["tokenExpired"];
      if (token is String &&
          tokenExpired is int &&
          token.isNotEmpty &&
          tokenExpired > 0) {
        // YcConfig.setUserToken(token);
        // YcConfig.setUserTokenExpiredTimestamp(tokenExpired);
      }
      var code = response.body["code"];
      var msg = response.body["msg"];
      if (code is int) {
        if (code == 0) {
          var returnResult =
              response.body['data'] ?? Map<String, dynamic>.from({});
          if (returnResult is Map<String, dynamic>) {
            // Map<String, dynamic>? adTips =
            //     returnResult['adTips'] ?? Map<String, dynamic>.from({});
            // if (adTips != null) {
            //   Future.delayed(const Duration(seconds: 3), () {
            //     String image = adTips['image'] ?? '';
            //     String url = adTips['url'] ?? '';
            //     String path = adTips['path'] ?? '';
            //     if (image.isNotEmpty) {
            //       Get.dialog(WidgetsAdTips(
            //         imageUrl: image,
            //         onTap: () {
            //           if (path.isNotEmpty) {
            //             Get.toNamed(path);
            //           } else if (url.isNotEmpty) {}
            //         },
            //       ));
            //     }
            //   });
            // }
          }
          return returnResult;
        } else if (code == -1) {
          EasyLoading.showError(msg ?? '请求失败，请稍后重试！');
        } else if (code == 30203) {
          // YcConfig.cleanAllLoginInfo();
          Get.offNamed('/login');
        } else if (code == 501) {
          EasyLoading.dismiss();
        } else {
          EasyLoading.showError('请求失败，请稍后重试！');
        }
        return null;
      }
    }
    return response;
  }
}
