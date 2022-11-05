library f_yc_apis;

export './src/f_yc_apis_dio.dart';
// export 'src/provider/f_yc_apis_provider.dart';
// export 'src/apis/yc_apis_auth.dart';
// export 'src/apis/yc_apis_default.dart';


// class FYcApi {
//   static FYcApisProvider apisProvider = FYcApisProvider();
//   static String ua = '';
//   static initializer() async {
//     FYcConfigApiConfig apiConfig = FYcConfigConfigurator.instance
//         .getConfig(configId: KIT_CONFIG_ID)
//         .apiConfig;
//     Dio dio = Dio(BaseOptions(baseUrl: apiConfig.host, method: 'POST'));
//     ua = await FYcString.ua();
//     apisProvider = FYcApisProvider();
//     dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
//       // Do something before request is sent
//       return handler.next(options); //continue
//       // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
//       // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
//       //
//       // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
//       // 这样请求将被中止并触发异常，上层catchError会被调用。
//     }, onResponse: (response, handler) {
//       // Do something with response data
//       return handler.next(response); // continue
//       // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
//       // 这样请求将被中止并触发异常，上层catchError会被调用。
//     }, onError: (DioError e, handler) {
//       // Do something with response error
//       return handler.next(e); //continue
//       // 如果你想完成请求并返回一些自定义数据，可以resolve 一个`Response`,如`handler.resolve(response)`。
//       // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
//     }));

//     Dio dio = Dio(BaseOptions(
//         baseUrl:
//             'https://4f673aa4-61ac-4428-b385-fc48bcac1be3.bspapp.com/48920c17fd7d',
//         method: 'POST'));
//     var response = await dio
//         .request('/pub/api/test.pub_getList', data: {'id': 12, 'name': 'xx'});
//     if (kDebugMode) {
//       // FYcLogger.write('------【开始】【网关请求日志】--------【${response.request!.url}');
//       FYcLogger.write('【网关请求日志】收到结果:$response');
//       // FYcLogger.write('------【结束】【网关请求日志】--------【${response.request!.url}');
//     }
//   }
// }
