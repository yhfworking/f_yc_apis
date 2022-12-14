import 'dart:convert';
import 'package:dio/dio.dart';
import 'f_yc_apis_ base_response.dart';

class FYcWrapper {
  static FYcApisBaseResponse errorWrapper(Object e) {
    return FYcApisBaseResponse(
      code: -1,
      msg: e is DioError ? _dioErrorWrapper(e) : '未知错误',
      refreshToken: '',
      tokenExpired: 0,
      data: '',
      success: false,
      ores: null,
    );
  }

  static String _dioErrorWrapper(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return '连接服务器超时';
      case DioErrorType.sendTimeout:
        return '连接服务器超时';
      case DioErrorType.receiveTimeout:
        return '连接服务器超时';
      case DioErrorType.cancel:
        return '连接被取消';
      default:
        return '未知错误';
    }
  }

  static FYcApisBaseResponse responseWrapper(Response response) {
    // 此处如果数据比较大，可以使用 compute 放在后台计算
    final res = jsonDecode(response.data);
    if (response.statusCode == 200) {
      final FYcApisBaseResponse wrapres = FYcApisBaseResponse.fromJson(res);
      wrapres.ores = response;
      return wrapres;
    } else {
      return FYcApisBaseResponse(
        code: -1,
        success: false,
        msg: '请求失败，请稍后重试！',
        refreshToken: '',
        tokenExpired: 0,
        data: '',
        ores: response,
      );
    }
  }
}
