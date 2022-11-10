// ignore: file_names
import 'package:dio/dio.dart';

class FYcApisBaseResponse {
  // 通用参数，可根据实际业务修改
  late int code;
  late String msg;
  late String refreshToken;
  late int tokenExpired;
  late dynamic data;
  // 业务请求是否成功
  late bool success;
  // Dio 返回的原始 Response 数据
  Response? ores;

  FYcApisBaseResponse({
    required this.code,
    required this.msg,
    required this.refreshToken,
    required this.tokenExpired,
    required this.data,
    required this.success,
    required this.ores,
  });

  FYcApisBaseResponse.fromJson(dynamic json) {
    code = json?['code'] ?? -1;
    msg = json?['msg'] ?? '';
    refreshToken = json?['refreshToken'] ?? '';
    tokenExpired = json?['tokenExpired'] ?? 0;
    data = json?['data'] ?? '';
    success = code == 0 ? true : false;
  }
}
