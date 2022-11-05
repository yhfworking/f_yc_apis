import 'dart:developer';
import 'package:dio/dio.dart';

class FYcAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 此处根据业务逻辑，自行判断处理
    if ('token' != '') {
      options.headers['token'] = 'token';
    }
    super.onRequest(options, handler);
  }
}

class LogInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    // 此处根据业务逻辑，自行增加 requestUrl requestMethod headers queryParameters 等参数的打印
    log('---【开始】【接口请求】------【$_startTime】-----------');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    log('---【结束】【接口请求】------【耗时:$duration毫秒】-----------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('---【报错】【接口请求】------【${err.toString()}】-----------');
    super.onError(err, handler);
  }
}
