import 'package:f_yc_apis/src/f_yc_apis_dio.dart';
import 'package:f_yc_entity/f_yc_entity.dart';
import 'package:f_yc_storages/f_yc_storages.dart';
import 'package:f_yc_utils/f_yc_utils.dart';
import 'f_yc_apis_ base_response.dart';

class FYcApisDefault {
  static Future<Map<String, dynamic>?> appleLogin() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_auth.appleLogin', params: {}, tips: true);
    if (apisBaseResponse.success) {
      FYcStorages.setUserToken(apisBaseResponse.data['unitoken']);
      FYcStorages.setUserTokenExpired(apisBaseResponse.data['tokenExpired']);

      FYcStorages.setUserInfo(
          FYcEntitysUser.fromJson(apisBaseResponse.data['userInfo'] ?? {}));
      FYcStorages.setBehaviorInfo(FYcEntitysBehavior.fromJson(
          apisBaseResponse.data['behaviorInfo'] ?? {}));
      FYcStorages.setWalletInfo(
          FYcEntitysWallet.fromJson(apisBaseResponse.data['walletInfo'] ?? {}));
      FYcEventBus.instance.fire(FYcEntitysEventsUserInfoUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
    }
    if (apisBaseResponse.data is Map) {
      return apisBaseResponse.data;
    }
    return Map.from({});
  }

  static Future<Map<String, dynamic>?> wxLogin(String code,
      {String inviteCode = ''}) async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_auth.wxLogin', params: {code, inviteCode}, tips: true);
    if (apisBaseResponse.success) {
      FYcStorages.setUserToken(apisBaseResponse.data['unitoken']);
      FYcStorages.setUserTokenExpired(apisBaseResponse.data['tokenExpired']);

      FYcStorages.setUserInfo(
          FYcEntitysUser.fromJson(apisBaseResponse.data['userInfo'] ?? {}));
      FYcStorages.setBehaviorInfo(FYcEntitysBehavior.fromJson(
          apisBaseResponse.data['behaviorInfo'] ?? {}));
      FYcStorages.setWalletInfo(
          FYcEntitysWallet.fromJson(apisBaseResponse.data['walletInfo'] ?? {}));
      FYcEventBus.instance.fire(FYcEntitysEventsUserInfoUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
    }
    if (apisBaseResponse.data is Map) {
      return apisBaseResponse.data;
    }
    return Map.from({});
  }

  static Future<void> logout() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_auth.logout', params: {}, tips: true);
    if (apisBaseResponse.success) {
      FYcStorages.cleanAllLoginInfo();
      FYcEventBus.instance.fire(FYcEntitysEventsUserInfoUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
    }
  }

  /////

  static Future<void> getWalletInfo() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/default/pub_remoteConfig.query', params: {}, tips: true);
    if (apisBaseResponse.success) {
      Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
      if (walletInfo.isNotEmpty) {
        FYcEntitysWallet entitysWallet = FYcEntitysWallet.fromJson(walletInfo);
        FYcStorages.setWalletInfo(entitysWallet);
        FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
      }
    }
  }

//   static Future<void> getBehaviorInfo() async {
//     FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
//         .post('/api/default/pub_remoteConfig.query', params: {}, tips: true);
//     if (apisBaseResponse.success) {
//       Map<String, dynamic> behaviorInfo = apisBaseResponse.data['behaviorInfo'];
//       if (behaviorInfo.isNotEmpty) {
//         FYcEntitysBehavior entitysBehavior =
//             FYcEntitysBehavior.fromJson(behaviorInfo);
//         FYcStorages.setBehaviorInfo(entitysBehavior);
//         FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
//       }
//     }
//   }

  static Future<bool> submitCashOut(int amount) async {
    if (amount > 0) {
      FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance.post(
          '/api/default/pub_remoteConfig.query',
          params: {amount: amount.toString()},
          tips: true);
      if (apisBaseResponse.success) {
        Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
        if (walletInfo.isNotEmpty) {
          FYcEntitysWallet entitysWallet =
              FYcEntitysWallet.fromJson(walletInfo);
          FYcStorages.setWalletInfo(entitysWallet);
          FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
        }
        Map<String, dynamic> behaviorInfo =
            apisBaseResponse.data['behaviorInfo'];
        if (behaviorInfo.isNotEmpty) {
          FYcEntitysBehavior entitysBehavior =
              FYcEntitysBehavior.fromJson(behaviorInfo);
          FYcStorages.setBehaviorInfo(entitysBehavior);
          FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
        }
        return true;
      }
    }
    return false;
  }

  static Future<List> queryWalletLog() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/default/pub_remoteConfig.query', params: {}, tips: true);
    if (apisBaseResponse.success) {
      return apisBaseResponse.data;
    }
    return [];
  }

  static Future<List> queryCashOuts() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/default/pub_remoteConfig.query', params: {}, tips: true);
    if (apisBaseResponse.success) {
      return apisBaseResponse.data;
    }
    return [];
  }

  static Future<void> reportAppPraise() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/default/pub_remoteConfig.query', params: {}, tips: true);
    if (apisBaseResponse.success) {
      Map<String, dynamic> behaviorInfo = apisBaseResponse.data['behaviorInfo'];
      if (behaviorInfo.isNotEmpty) {
        FYcEntitysBehavior entitysBehavior =
            FYcEntitysBehavior.fromJson(behaviorInfo);
        FYcStorages.setBehaviorInfo(entitysBehavior);
        FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
      }
    }
  }

  // static Future<void> reportAdClick(
  //     {String slotID = '', String adnName = '', String adnSlotID = ''}) async {
  //   Future.delayed(const Duration(seconds: 5), () async {
  //     FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance.post(
  //         '/api/default/pub_remoteConfig.query',
  //         params: {slotID: slotID, adnName: adnName, adnSlotID: adnSlotID});
  //     if (apisBaseResponse.success) {
  //       bool isReward = apisBaseResponse.data['isReward'];
  //       if (isReward && (await Vibration.hasVibrator() ?? false)) {
  //         Vibration.vibrate();
  //       }
  //     }
  //   });
  // }

  static Future<List> queryUserWelfareRe() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/default/pub_remoteConfig.query', params: {}, tips: true);
    if (apisBaseResponse.success) {
      return apisBaseResponse.data;
    }
    return [];
  }

  static Future<bool> receiveUserWelfareRe(int amount, String code) async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance.post(
        '/api/default/pub_remoteConfig.query',
        params: {amount: amount.toString(), code: code},
        tips: true);
    if (apisBaseResponse.success) {
      Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
      if (walletInfo.isNotEmpty) {
        FYcEntitysWallet entitysWallet = FYcEntitysWallet.fromJson(walletInfo);
        FYcStorages.setWalletInfo(entitysWallet);
        FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
      }
      return true;
    }
    return false;
  }

//   static Future<int> submitSign() async {
//     FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
//         .post('/api/default/pub_remoteConfig.query', params: {}, tips: true);
//     if (apisBaseResponse.success) {
//       int amount = apisBaseResponse.data['amount'];
//       Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
//       if (walletInfo.isNotEmpty) {
//         FYcEntitysWallet entitysWallet = FYcEntitysWallet.fromJson(walletInfo);
//         FYcStorages.setWalletInfo(entitysWallet);
//         FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
//       }
//       Map<String, dynamic> behaviorInfo = apisBaseResponse.data['behaviorInfo'];
//       if (behaviorInfo.isNotEmpty) {
//         FYcEntitysBehavior entitysBehavior =
//             FYcEntitysBehavior.fromJson(behaviorInfo);
//         FYcStorages.setBehaviorInfo(entitysBehavior);
//         FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
//       }
//       return amount;
//     }
//     return 0;
//   }

//   static Future<int> receiveContinuitySign(int days) async {
//     FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance.post(
//         '/api/default/pub_remoteConfig.query',
//         params: {days: days.toString()},
//         tips: true);
//     if (apisBaseResponse.success) {
//       int amount = apisBaseResponse.data['amount'];
//       Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
//       if (walletInfo.isNotEmpty) {
//         FYcEntitysWallet entitysWallet = FYcEntitysWallet.fromJson(walletInfo);
//         FYcStorages.setWalletInfo(entitysWallet);
//         FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
//       }
//       Map<String, dynamic> behaviorInfo = apisBaseResponse.data['behaviorInfo'];
//       if (behaviorInfo.isNotEmpty) {
//         FYcEntitysBehavior entitysBehavior =
//             FYcEntitysBehavior.fromJson(behaviorInfo);
//         FYcStorages.setBehaviorInfo(entitysBehavior);
//         FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
//       }
//       return amount;
//     }
//     return 0;
//   }
}
