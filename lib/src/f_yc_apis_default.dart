import 'package:f_yc_apis/src/f_yc_apis_dio.dart';
import 'package:f_yc_entity/f_yc_entity.dart';
import 'package:f_yc_storages/f_yc_storages.dart';
import 'package:f_yc_utils/f_yc_utils.dart';
import 'package:vibration/vibration.dart';
import 'f_yc_apis_ base_response.dart';

class FYcApisDefault {
  static Future<Map<String, dynamic>?> appleLogin() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_auth.appleLogin', params: {}, tips: true);
    if (apisBaseResponse.success) {
      await FYcStorages.setUserToken(apisBaseResponse.data['unitoken']);
      await FYcStorages.setUserTokenExpired(
          apisBaseResponse.data['tokenExpired']);

      await FYcStorages.setUserInfo(
          FYcEntitysUser.fromJson(apisBaseResponse.data['userInfo'] ?? {}));
      await FYcStorages.setBehaviorInfo(FYcEntitysBehavior.fromJson(
          apisBaseResponse.data['behaviorInfo'] ?? {}));
      await FYcStorages.setWalletInfo(
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
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance.post(
        '/api/pub_auth.wxLogin',
        params: {"code": code, "inviteCode": inviteCode},
        tips: true);
    if (apisBaseResponse.success) {
      await FYcStorages.setUserToken(apisBaseResponse.data['unitoken']);
      await FYcStorages.setUserTokenExpired(
          apisBaseResponse.data['tokenExpired']);
      await FYcStorages.setUserInfo(
          FYcEntitysUser.fromJson(apisBaseResponse.data['userInfo'] ?? {}));
      await FYcStorages.setBehaviorInfo(FYcEntitysBehavior.fromJson(
          apisBaseResponse.data['behaviorInfo'] ?? {}));
      await FYcStorages.setWalletInfo(
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
      await FYcStorages.cleanAllLoginInfo();
      FYcEventBus.instance.fire(FYcEntitysEventsUserInfoUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
      FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
    }
  }

  static Future<void> getWalletInfo() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_wallet.getWalletInfo', params: {}, tips: true);
    if (apisBaseResponse.success) {
      Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
      if (walletInfo.isNotEmpty) {
        FYcEntitysWallet entitysWallet = FYcEntitysWallet.fromJson(walletInfo);
        await FYcStorages.setWalletInfo(entitysWallet);
        FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
      }
    }
  }

  static Future<void> getBehaviorInfo() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_user.getBehaviorInfo', params: {}, tips: true);
    if (apisBaseResponse.success) {
      Map<String, dynamic> behaviorInfo = apisBaseResponse.data['behaviorInfo'];
      if (behaviorInfo.isNotEmpty) {
        FYcEntitysBehavior entitysBehavior =
            FYcEntitysBehavior.fromJson(behaviorInfo);
        await FYcStorages.setBehaviorInfo(entitysBehavior);
        FYcEventBus.instance.fire(FYcEntitysEventsBehaviorUpdate());
      }
    }
  }

  static Future<void> reportAppPraise() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_user.submitAppPraise', params: {}, tips: true);
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

  static Future<List> queryWalletLog() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_wallet.queryWalletLog', params: {}, tips: true);
    if (apisBaseResponse.success) {
      return apisBaseResponse.data;
    }
    return [];
  }

  static Future<List> queryCashOuts() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_wallet.queryCashOuts', params: {}, tips: true);
    if (apisBaseResponse.success) {
      return apisBaseResponse.data;
    }
    return [];
  }

  static Future<void> submitAdClick(
      {String slotID = '', String adnName = '', String adnSlotID = ''}) async {
    Future.delayed(const Duration(seconds: 5), () async {
      FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
          .post('/api/pub_ad.submitAdClick', params: {
        "slotID": slotID,
        "adnName": adnName,
        "adnSlotID": adnSlotID
      });
      if (apisBaseResponse.success) {
        bool isReward = apisBaseResponse.data['isReward'];
        if (isReward && (await Vibration.hasVibrator() ?? false)) {
          Vibration.vibrate();
        }
      }
    });
  }

  static Future<bool> submitCashOut(int amount) async {
    if (amount > 0) {
      FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance.post(
          '/api/pub_wallet.submitCashOut',
          params: {"amount": amount.toString()},
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

  static Future<List> queryUserWelfareRe() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_user.queryUserWelfareRe', params: {}, tips: true);
    if (apisBaseResponse.success) {
      return apisBaseResponse.data;
    }
    return [];
  }

  static Future<bool> receiveUserWelfareRe(int amount, String code) async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance.post(
        '/api/pub_user.receiveUserWelfareRe',
        params: {"amount": amount.toString(), "code": code},
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

  static Future<Map<String, dynamic>> submitLotteryRe() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_bus.submitLotteryRe', params: {}, tips: true);
    if (apisBaseResponse.success) {
      if (apisBaseResponse.data.containsKey('walletInfo')) {
        Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
        if (walletInfo.isNotEmpty) {
          FYcEntitysWallet entitysWallet =
              FYcEntitysWallet.fromJson(walletInfo);
          FYcStorages.setWalletInfo(entitysWallet);
          FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
        }
      }
      if (apisBaseResponse.data is Map) {
        return apisBaseResponse.data;
      }
    }
    return Map.from({});
  }

  static Future<int> receiveTimerRewardRe() async {
    FYcApisBaseResponse apisBaseResponse = await FYcApisDio.instance
        .post('/api/pub_bus.submitLotteryRe', params: {}, tips: true);
    if (apisBaseResponse.success) {
      int amount = apisBaseResponse.data['amount'];
      if (apisBaseResponse.data.containsKey('walletInfo')) {
        Map<String, dynamic> walletInfo = apisBaseResponse.data['walletInfo'];
        if (walletInfo.isNotEmpty) {
          FYcEntitysWallet entitysWallet =
              FYcEntitysWallet.fromJson(walletInfo);
          await FYcStorages.setWalletInfo(entitysWallet);
          FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
        }
      }
      if (apisBaseResponse.data.containsKey('behaviorInfo')) {
        Map<String, dynamic> behaviorInfo =
            apisBaseResponse.data['behaviorInfo'];
        if (behaviorInfo.isNotEmpty) {
          FYcEntitysBehavior entitysBehavior =
              FYcEntitysBehavior.fromJson(behaviorInfo);
          await FYcStorages.setBehaviorInfo(entitysBehavior);
          FYcEventBus.instance.fire(FYcEntitysEventsWalletUpdate());
        }
      }
      return amount;
    }
    return 0;
  }
}
