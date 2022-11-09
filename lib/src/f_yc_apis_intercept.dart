import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:f_yc_apis/src/f_yc_apis_wrapper.dart';
import 'package:f_yc_config/f_yc_config.dart';
import 'package:f_yc_storages/f_yc_storages.dart';
// ignore: library_prefixes
import 'package:f_yc_utils/f_yc_utils.dart' as fycUtils;
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'f_yc_apis_ base_response.dart';

class FYcAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 此处根据业务逻辑，自行判断处理
    FYcConfigApiConfig apiConfig = FYcConfigConfigurator.instance
        .getConfig(configId: KIT_CONFIG_ID)
        .apiConfig;
    if (apiConfig.appkey.isNotEmpty && apiConfig.appSecret.isNotEmpty) {
      options.headers['platform'] = apiConfig.commonConfig.platform;
      options.headers['os'] = apiConfig.commonConfig.os;
      options.headers['ua'] = apiConfig.commonConfig.ua;
      options.headers['apiVersion'] = apiConfig.apiVersion;
      options.headers['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      options.headers['nonce'] = _randomNonceString(32);
      options.headers['appkey'] = apiConfig.appkey;
      options.headers['sign'] = _getSign(options.data, apiConfig.appSecret);
      String userToken = FYcStorages.userToken();
      if (userToken.isNotEmpty) {
        options.headers['unitoken'] = userToken;
      } else {
        options.headers['unitoken'] = '';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    FYcApisBaseResponse apisBaseResponse = FYcWrapper.responseWrapper(response);
    var unitoken = apisBaseResponse.unitoken;
    var tokenExpired = apisBaseResponse.tokenExpired;
    if (unitoken.isNotEmpty && tokenExpired > 0) {
      FYcStorages.setUserToken(unitoken);
      FYcStorages.setUserTokenExpired(tokenExpired);
    }
    if (apisBaseResponse.code == -1) {
      EasyLoading.showError(apisBaseResponse.msg.isNotEmpty
          ? apisBaseResponse.msg
          : '请求失败，请稍后重试！');
    } else if (apisBaseResponse.code == 30203) {
      //unitoken过期
      FYcStorages.cleanAllLoginInfo();
      // Get.offNamed('/login');
    } else if (apisBaseResponse.code == 501) {
      EasyLoading.dismiss();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    EasyLoading.showError('请求失败，请稍后重试！');
    super.onError(err, handler);
  }

  ///获取接口签名
  String _getSign(Map parameter, String appSecret) {
    List<String> allKeys = [];
    parameter.forEach((key, value) {
      allKeys.add(key + value);
    });
    allKeys.sort((obj1, obj2) {
      return obj1.compareTo(obj2);
    });
    String pairsString = allKeys.join("");
    String sign = appSecret + pairsString + appSecret;
    String signString = fycUtils.md5
        .convert(utf8.encode(sign))
        .toString()
        .toUpperCase(); //直接写也可以
    return signString;
  }

  String _randomNonceString(int length) {
    final random = math.Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();
    return randomString;
  }
}

class LogInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;
  late String _requestPath;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    _requestPath = options.path;
    // 此处根据业务逻辑，自行增加 requestUrl requestMethod headers queryParameters 等参数的打印
    if (kDebugMode) {
      log('---【开始】【接口请求】【$_startTime】---->【$_requestPath】-----');
      log('---【请求参数】---->【${options.data}】----------');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (kDebugMode) {
      log('---【返回结果】---->【${response.data}】----------');
      log('---【结束】【接口请求】【耗时:$duration毫秒】---->【$_requestPath】------');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log('---【报错】【接口请求】------【${err.toString()}】-----------');
    }
    super.onError(err, handler);
  }
}
