import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:f_yc_config/f_yc_config.dart';

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
      options.headers['appkey'] = apiConfig.appkey;
      options.headers['sign'] = _getSign(options.data, apiConfig.appSecret);
    }
    super.onRequest(options, handler);
  }

  ///获取接口签名
  String _getSign(Map parameter, String appSecret) {
    /// 存储所有key
    List<String> allKeys = [];
    parameter.forEach((key, value) {
      allKeys.add(key + value);
    });
    log('-----allKeys----$allKeys');

    /// key排序
    allKeys.sort((obj1, obj2) {
      return obj1.compareTo(obj2);
    });
    log('---key排序--allKeys----$allKeys');

    /// 数组转string
    String pairsString = allKeys.join("");
    log('-----pairsString----$pairsString');

    /// 拼接 ABC 是你的秘钥
    String sign = appSecret + pairsString + appSecret;
    log('-----sign----$sign');

    String signString =
        md5.convert(utf8.encode(sign)).toString().toUpperCase(); //直接写也可以
    log('-----signString----$signString');
    return signString;
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
