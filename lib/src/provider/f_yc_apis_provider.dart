import 'dart:convert';
import 'package:f_yc_apis/f_yc_apis.dart';
import 'package:f_yc_config/f_yc_config.dart';
import 'package:f_yc_utils/f_yc_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'f_yc_apis_request_interceptor.dart';
import 'f_yc_apis_response_interceptor.dart';

class FYcApisProvider extends GetConnect {
  FYcConfigApiConfig apiConfig = FYcConfigConfigurator.instance
      .getConfig(configId: KIT_CONFIG_ID)
      .apiConfig;
  @override
  void onInit() {
    httpClient.baseUrl = apiConfig.host;
    httpClient
        .addRequestModifier(FYcApisRequestInterceptor.apiRequestInterceptor);
    httpClient
        .addResponseModifier(FYcApisResponseInterceptor.apiResponseInterceptor);
  }

  Future<dynamic> doPost(String uri,
      {Map<String, String>? header,
      Map<String, dynamic>? query,
      bool isLoading = true,
      String? stage = 'release'}) async {
    if (GetUtils.isNull(uri)) {
      return;
    }
    //release，pre-online，test
    Map<String, String> baseHeader = Map.from({
      "isLoading": "true",
      "platform": FYcString.platform(),
      "os": FYcString.os(),
      "User-Agent": FYcApi.ua,
      "HOST": apiConfig.host,
      "X-Bce-Signature": _bceApiSignature(apiConfig, uri, query ?? {}),
      "X-Bce-Stage": stage,
    });
    if (!GetUtils.isNull(header)) {
      baseHeader.addAll(header!);
    }
    EasyLoading.dismiss();
    Response response =
        await post(uri, Map.from({}), query: query ?? {}, headers: baseHeader);
    if (kDebugMode) {
      FYcLogger.write('【网关请求日志】收到结果:$response');
    }
    if (!GetUtils.isNull(response)) {
      return response.body['data'] ?? Map<String, dynamic>.from({});
    }
    return Map<String, dynamic>.from({});
  }
}

//百度api网关签名
String _bceApiSignature(
    FYcConfigApiConfig apiConfig, String uri, Map<String, dynamic>? query) {
  String timestampStr = DateTime.now().toUtc().toIso8601String();
  timestampStr = '${timestampStr.substring(0, timestampStr.length - 8)}Z';
  String authStringPrefix =
      'bce-auth-v1/${apiConfig.appkey}/$timestampStr/1800';

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
      '${Uri.encodeComponent('host')}:${Uri.encodeComponent(apiConfig.host)}';
  String canonicalRequest =
      'POST\n${Uri.encodeComponent(uri).replaceAll('%2F', '/')}\n$canonicalQueryString\n$canonicalHeaders';

  var signingKeyHmacSha256 = Hmac(sha256, utf8.encode(apiConfig.appSecret));
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
