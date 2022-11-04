// import 'package:f_yc_config/f_yc_config.dart';
// import '../provider/yc_provider.dart';

// class YcApisAuth {
//   static Future<Map<String, dynamic>?> wxLogin(String uri, String code,
//       {String inviteCode = ''}) async {
//     Map<String, dynamic>? response = await YcApisProvider.to
//         .doPost(uri, query: {"code": code, "inviteCode": inviteCode});
//     if (response != null) {
//       YcConfig.setUserToken(response['token']);
//       YcConfig.setUserTokenExpiredTimestamp(response['tokenExpired']);

//       YcConfig.setUserInfo(YcUser.fromJson(response['userInfo'] ?? {}));
//       YcConfig.setBehaviorInfo(
//           YcBehavior.fromJson(response['behaviorInfo'] ?? {}));
//       YcConfig.setWalletInfo(YcWallet.fromJson(response['walletInfo'] ?? {}));
//       YcEvents.emit(EventsUserInfoUpdate());
//       YcEvents.emit(EventsBehaviorUpdate());
//       YcEvents.emit(EventsWalletUpdate());
//     }
//     return response;
//   }

//   static Future<Map<String, dynamic>?> mLogin(String uri) async {
//     Map<String, dynamic>? response = await YcApisProvider.to.doPost(uri);
//     if (response != null) {
//       YcConfig.setUserToken(response['token']);
//       YcConfig.setUserTokenExpiredTimestamp(response['tokenExpired']);

//       YcConfig.setUserInfo(YcUser.fromJson(response['userInfo'] ?? {}));
//       YcConfig.setBehaviorInfo(
//           YcBehavior.fromJson(response['behaviorInfo'] ?? {}));
//       YcConfig.setWalletInfo(YcWallet.fromJson(response['walletInfo'] ?? {}));
//       YcEvents.emit(EventsUserInfoUpdate());
//       YcEvents.emit(EventsBehaviorUpdate());
//       YcEvents.emit(EventsWalletUpdate());
//     }
//     return response;
//   }

//   static Future<Map<String, dynamic>?> appleLogin(String uri) async {
//     Map<String, dynamic>? response = await YcApisProvider.to.doPost(uri);
//     if (response != null) {
//       YcConfig.setUserToken(response['token']);
//       YcConfig.setUserTokenExpiredTimestamp(response['tokenExpired']);

//       YcConfig.setUserInfo(YcUser.fromJson(response['userInfo'] ?? {}));
//       YcConfig.setBehaviorInfo(
//           YcBehavior.fromJson(response['behaviorInfo'] ?? {}));
//       YcConfig.setWalletInfo(YcWallet.fromJson(response['walletInfo'] ?? {}));
//       YcEvents.emit(EventsUserInfoUpdate());
//       YcEvents.emit(EventsBehaviorUpdate());
//       YcEvents.emit(EventsWalletUpdate());
//     }
//     return response;
//   }

//   static Future<bool> logout(String uri) async {
//     Map<String, dynamic>? response =
//         await YcApisProvider.to.doPost(uri, showLoading: true);
//     if (response != null) {
//       await YcConfig.cleanAllLoginInfo();
//       YcEvents.emit(EventsUserInfoUpdate());
//       YcEvents.emit(EventsBehaviorUpdate());
//       YcEvents.emit(EventsWalletUpdate());
//     }
//     return true;
//   }
// }
