import 'package:f_yc_config/f_yc_config.dart';
import 'package:f_yc_utils/f_yc_utils.dart';
import 'yc_request_interceptor.dart';
import 'yc_response_interceptor.dart';

class YcApisBaseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://${YcConfig.apiHost()}';
    httpClient
        .addRequestModifier(YcApisRequestInterceptor.apiRequestInterceptor);
    httpClient
        .addResponseModifier(YcApisResponseInterceptor.apiResponseInterceptor);
  }
}
