import 'dart:convert';
import 'package:f_yc_config/f_yc_config.dart';
import 'package:f_yc_utils/f_yc_utils.dart';
import 'package:flutter/foundation.dart';
import 'yc_base_provider.dart';

class ApisProvider extends ApisBaseProvider {
  static ApisProvider get to => Get.find();

  Future<dynamic> doPost(String path,
      {Map<String, dynamic>? query, bool showLoading = true}) async {
    Response response = await post(path, Map.from({}),
        query: query ?? {},
        headers: Map.from({
          "uniidtoken": YcConfig.userToken(),
          "showLoading": showLoading.toString(),
          "platform": StringUtils.platform(),
          "os": StringUtils.os(),
          "User-Agent": YcConfig.ua(),
          "HOST": YcConfig.apiHost(),
          "X-Bce-Signature": _getXBceSignature(path, query ?? {}),
          "X-Bce-Stage": "release", //release，pre-online，test
        }));
    LoadingUtils.dismiss();
    if (kDebugMode) {
      LoggerUtils.write('【api请求日志】请求URL:${response.request!.url}');
      LoggerUtils.write('【api请求日志】收到结果:${response.body}');
    }
    if (!response.isOk) {
      SnackbarUtils.showError('请求失败，请稍后重试！');
      LoadingUtils.dismiss();
      return null;
    }
    if (response.statusCode == 200) {
      var token = response.body["token"];
      var tokenExpired = response.body["tokenExpired"];
      if (token is String &&
          tokenExpired is int &&
          token.isNotEmpty &&
          tokenExpired > 0) {
        YcConfig.setUserToken(token);
        YcConfig.setUserTokenExpiredTimestamp(tokenExpired);
      }
      var code = response.body["code"];
      var msg = response.body["msg"];
      if (code is int) {
        if (code == 0) {
          var returnResult =
              response.body['data'] ?? Map<String, dynamic>.from({});
          if (returnResult is Map<String, dynamic>) {
            Map<String, dynamic>? adTips =
                returnResult['adTips'] ?? Map<String, dynamic>.from({});
            if (adTips != null) {
              Future.delayed(const Duration(seconds: 3), () {
                String image = adTips['image'] ?? '';
                String url = adTips['url'] ?? '';
                String path = adTips['path'] ?? '';
                if (image.isNotEmpty) {
                  // Get.dialog(WidgetsAdTips(
                  //   imageUrl: image,
                  //   onTap: () {
                  //     if (path.isNotEmpty) {
                  //       Get.toNamed(path);
                  //     } else if (url.isNotEmpty) {}
                  //   },
                  // ));
                }
              });
            }
          }
          return returnResult;
        }
        if (code == 30203) {
          YcConfig.cleanAllLoginInfo();
          Get.offNamed('/login');
          return null;
        }
        if (code == 501) {
          LoadingUtils.dismiss();
          return null;
        }
        SnackbarUtils.showError(msg ?? '请求失败，请稍后重试！');
        LoadingUtils.dismiss();
        return null;
      }
    } else {
      SnackbarUtils.showError('请求失败，请稍后重试！');
      LoadingUtils.dismiss();
      return null;
    }
  }
}

String _getXBceSignature(String path, Map<String, dynamic>? query) {
  String timestampStr = DateTime.now().toUtc().toIso8601String();
  timestampStr = '${timestampStr.substring(0, timestampStr.length - 8)}Z';
  String authStringPrefix =
      'bce-auth-v1/${YcConfig.apiAppkey()}/$timestampStr/1800';

  List<String> encodeStringList = [];
  query!.forEach((key, value) {
    encodeStringList
        .add('${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}');
  });
  encodeStringList.sort();
  String canonicalQueryString = '';
  for (var element in encodeStringList) {
    if (canonicalQueryString.isEmpty) {
      canonicalQueryString = element;
    } else {
      canonicalQueryString = '$canonicalQueryString&$element';
    }
  }

  String canonicalHeaders =
      '${Uri.encodeComponent('host')}:${Uri.encodeComponent(YcConfig.apiHost())}';
  String canonicalRequest =
      'POST\n${Uri.encodeComponent(path).replaceAll('%2F', '/')}\n$canonicalQueryString\n$canonicalHeaders';

  var signingKeyHmacSha256 = Hmac(sha256, utf8.encode(YcConfig.apiAppSecret()));
  String signingKey = signingKeyHmacSha256
      .convert(utf8.encode(authStringPrefix))
      .toString()
      .toLowerCase();
  var signatureHmacSha256 = Hmac(sha256, utf8.encode(signingKey));
  String signature = signatureHmacSha256
      .convert(utf8.encode(canonicalRequest))
      .toString()
      .toLowerCase();
  return '$authStringPrefix/host/$signature';
}
