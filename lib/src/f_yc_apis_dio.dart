import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:f_yc_config/f_yc_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'f_yc_apis_intercept.dart' as interceptor;
import 'f_yc_apis_ base_response.dart';
import 'f_yc_apis_wrapper.dart';

class FYcApisDio {
  static final FYcApisDio _instance = FYcApisDio._();

  static FYcApisDio get instance => FYcApisDio();

  factory FYcApisDio() => _instance;

  static late Dio _dio;

  Dio get dio => _dio;

  FYcApisDio._() {
    FYcConfigApiConfig apiConfig = FYcConfigConfigurator.instance
        .getConfig(configId: KIT_CONFIG_ID)
        .apiConfig;
    final BaseOptions options = BaseOptions(
        connectTimeout: 15000,
        receiveTimeout: 15000,
        sendTimeout: 10000,
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
        baseUrl: apiConfig.host);

    // 实例化 Dio
    _dio = Dio(options);

    // 忽略 https 证书校验
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // 添加迭代器
    _dio.interceptors.add(interceptor.FYcAuthInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(interceptor.LogInterceptor());
    }
  }

  Future<FYcApisBaseResponse> _request(
    String url, {
    String? method = 'POST',
    dynamic params,
    bool tips = false,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late FYcApisBaseResponse response;
    try {
      if (tips) {
        EasyLoading.show(status: '加载中...');
      }
      late Response<dynamic> res;
      if (method == 'GET') {
        res = await _dio.get(url, queryParameters: params);
      } else if (method == 'UPLOAD') {
        FormData formData = FormData.fromMap(params);
        res = await _dio.post(
          url,
          data: formData,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      } else {
        res = await _dio.post(
          url,
          data: params,
        );
      }
      response = FYcWrapper.responseWrapper(res);
    } catch (e) {
      response = FYcWrapper.errorWrapper(e);
    } finally {
      EasyLoading.dismiss();
    }
    return response;
  }

  // GET
  Future<FYcApisBaseResponse> get(
    String url, {
    dynamic params,
    bool tips = false,
  }) async {
    return _request(
      url,
      method: 'GET',
      params: params,
      tips: tips,
    );
  }

  // POST
  Future<FYcApisBaseResponse> post(
    String url, {
    dynamic params,
    bool tips = false,
  }) async {
    return _request(
      url,
      method: 'POST',
      params: params,
      tips: tips,
    );
  }

  // UPLOAD
  Future<FYcApisBaseResponse> upload(
    String url, {
    dynamic params,
    bool tips = false,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return _request(
      url,
      method: 'UPLOAD',
      params: params,
      tips: tips,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
