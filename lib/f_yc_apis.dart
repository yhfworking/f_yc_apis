library f_yc_apis;

export 'src/provider/f_yc_apis_provider.dart';
export 'src/apis/yc_apis_auth.dart';
export 'src/apis/yc_apis_default.dart';
import 'src/provider/f_yc_apis_provider.dart';

class FYcApi {
  static FYcApisProvider apisProvider = FYcApisProvider();
  static initializer() async {
    apisProvider = FYcApisProvider();
  }
}
