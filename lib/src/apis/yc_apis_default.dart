import 'package:f_yc_config/f_yc_config.dart';
import 'package:vibration/vibration.dart';
import '../provider/yc_provider.dart';

class YcApisDefault {
  static Future<void> remoteConfig() async {
    String apiUriRemoteConfig = YcConfig.apiUriRemoteConfig();
    if (apiUriRemoteConfig.isNotEmpty) {
      int timestamp = YcConfig.lastRemoteConfigTimestamp();
      if (DateTime.now().millisecondsSinceEpoch - timestamp <
          1000 * 60 * 60 * 12) {
        return;
      }
      YcConfig.setLastRemoteConfigTimestamp();
      Map<String, dynamic>? response = await YcApisProvider.to
          .doPost(apiUriRemoteConfig, showLoading: false);
      if (response != null) {
        YcRemoteConfig remoteConfig = YcRemoteConfig.fromJson(response);
        await YcConfig.setRemoteConfig(remoteConfig);
        YcEvents.emit(EventsRemoteConfigUpdate());
      }
    }
  }

  static Future<void> getWalletInfo() async {
    String apiUriWalletInfo = YcConfig.apiUriWalletInfo();
    if (apiUriWalletInfo.isNotEmpty) {
      Map<String, dynamic>? response =
          await YcApisProvider.to.doPost(apiUriWalletInfo);
      if (response != null) {
        Map<String, dynamic> walletInfo = response['walletInfo'];
        if (walletInfo.isNotEmpty) {
          YcWallet ycWallet = YcWallet.fromJson(walletInfo);
          await YcConfig.setWalletInfo(ycWallet);
          YcEvents.emit(EventsWalletUpdate());
        }
      }
    }
  }

  static Future<void> getBehaviorInfo() async {
    String apiUriBehaviorInfo = YcConfig.apiUriBehaviorInfo();
    if (apiUriBehaviorInfo.isNotEmpty) {
      Map<String, dynamic>? response =
          await YcApisProvider.to.doPost(apiUriBehaviorInfo, showLoading: true);
      if (response != null) {
        Map<String, dynamic> behaviorInfo = response['behaviorInfo'];
        if (behaviorInfo.isNotEmpty) {
          YcBehavior ycBehavior = YcBehavior.fromJson(behaviorInfo);
          await YcConfig.setBehaviorInfo(ycBehavior);
          YcEvents.emit(EventsBehaviorUpdate());
        }
      }
    }
  }

  static Future<bool> submitCashOut(int amount) async {
    String apiUriSubmitCashOut = YcConfig.apiUriSubmitCashOut();
    if (apiUriSubmitCashOut.isNotEmpty && amount > 0) {
      Map<String, dynamic>? response = await YcApisProvider.to.doPost(
          apiUriSubmitCashOut,
          query: {"amount": amount.toString()},
          showLoading: true);
      if (response == null) {
        return false;
      }
      Map<String, dynamic> walletInfo = response['walletInfo'];
      if (walletInfo.isNotEmpty) {
        YcWallet ycWallet = YcWallet.fromJson(walletInfo);
        await YcConfig.setWalletInfo(ycWallet);
        YcEvents.emit(EventsWalletUpdate());
      }
      Map<String, dynamic> behaviorInfo = response['behaviorInfo'];
      if (behaviorInfo.isNotEmpty) {
        YcBehavior ycBehavior = YcBehavior.fromJson(behaviorInfo);
        await YcConfig.setBehaviorInfo(ycBehavior);
        YcEvents.emit(EventsBehaviorUpdate());
      }
      return true;
    }
    return false;
  }

  static Future<List> queryWalletLog() async {
    String apiUriLogWallet = YcConfig.apiUriLogWallet();
    if (apiUriLogWallet.isNotEmpty) {
      List? response =
          await YcApisProvider.to.doPost(apiUriLogWallet, showLoading: true);
      if (response == null) {
        return [];
      }
      return response;
    }
    return [];
  }

  static Future<List> queryCashOuts() async {
    String apiUriLogCashOut = YcConfig.apiUriLogCashOut();
    if (apiUriLogCashOut.isNotEmpty) {
      List? response =
          await YcApisProvider.to.doPost(apiUriLogCashOut, showLoading: true);
      if (response == null) {
        return [];
      }
      return response;
    }
    return [];
  }

  static Future<void> reportAppPraise() async {
    String apiUriLogCashOut = YcConfig.apiUriReportAppPraise();
    if (apiUriLogCashOut.isNotEmpty) {
      Map<String, dynamic>? response =
          await YcApisProvider.to.doPost(apiUriLogCashOut, showLoading: false);
      if (response != null) {
        Map<String, dynamic> behaviorInfo = response['behaviorInfo'];
        if (behaviorInfo.isNotEmpty) {
          YcBehavior ycBehavior = YcBehavior.fromJson(behaviorInfo);
          await YcConfig.setBehaviorInfo(ycBehavior);
          YcEvents.emit(EventsBehaviorUpdate());
        }
      }
    }
  }

  static Future<void> reportAdClick(
      {String slotID = '', String adnName = '', String adnSlotID = ''}) async {
    String apiUriReportAdClick = YcConfig.apiUriReportAdClick();
    if (apiUriReportAdClick.isNotEmpty) {
      Future.delayed(const Duration(seconds: 5), () async {
        Map<String, dynamic>? response = await YcApisProvider.to.doPost(
            apiUriReportAdClick,
            query: {
              "slotID": slotID,
              "adnName": adnName,
              "adnSlotID": adnSlotID
            },
            showLoading: false);
        if (response != null && response.containsKey('isReward')) {
          bool isReward = response['isReward'];
          if (isReward && (await Vibration.hasVibrator() ?? false)) {
            Vibration.vibrate();
          }
        }
      });
    }
  }

  static Future<void> reportRewaedAdEvent(
      {String slotID = '',
      String adnName = '',
      String adnSlotID = '',
      String customData = ''}) async {
    String apiUriReportRewardAdEvent = YcConfig.apiUriReportRewardAdEvent();
    if (apiUriReportRewardAdEvent.isNotEmpty) {
      Future.delayed(const Duration(seconds: 5), () async {
        Map<String, dynamic>? response =
            await YcApisProvider.to.doPost(apiUriReportRewardAdEvent,
                query: {
                  "slotID": slotID,
                  "adnName": adnName,
                  "adnSlotID": adnSlotID,
                  "customData": customData
                },
                showLoading: false);
        if (response != null) {
          Map<String, dynamic> behaviorInfo = response['behaviorInfo'];
          if (behaviorInfo.isNotEmpty) {
            YcBehavior ycBehavior = YcBehavior.fromJson(behaviorInfo);
            await YcConfig.setBehaviorInfo(ycBehavior);
            YcEvents.emit(EventsBehaviorUpdate());
          }
        }
      });
    }
  }

  static Future<List> queryUserWelfareRe() async {
    String apiUriUserWelfareRe = YcConfig.apiUriUserWelfareRe();
    if (apiUriUserWelfareRe.isNotEmpty) {
      var response = await YcApisProvider.to
          .doPost(apiUriUserWelfareRe, showLoading: true);
      if (response != null) {
        return response;
      }
    }
    return [];
  }

  static Future<bool> receiveUserWelfareRe(int amount, String code) async {
    String apiUriReceiveUserWelfareRe = YcConfig.apiUriReceiveUserWelfareRe();
    if (apiUriReceiveUserWelfareRe.isNotEmpty) {
      Map<String, dynamic>? response = await YcApisProvider.to.doPost(
          apiUriReceiveUserWelfareRe,
          query: {'amount': amount.toString(), 'code': code},
          showLoading: true);
      if (response != null) {
        Map<String, dynamic> walletInfo = response['walletInfo'];
        if (walletInfo.isNotEmpty) {
          YcWallet ycWallet = YcWallet.fromJson(walletInfo);
          await YcConfig.setWalletInfo(ycWallet);
          YcEvents.emit(EventsWalletUpdate());
        }
        return true;
      }
    }
    return false;
  }

  static Future<int> submitSign() async {
    String apiUriSubmitSign = YcConfig.apiUriSubmitSign();
    if (apiUriSubmitSign.isNotEmpty) {
      Map<String, dynamic>? response =
          await YcApisProvider.to.doPost(apiUriSubmitSign, showLoading: true);
      if (response != null) {
        int amount = response['amount'];
        Map<String, dynamic> walletInfo = response['walletInfo'];
        if (walletInfo.isNotEmpty) {
          YcWallet ycWallet = YcWallet.fromJson(walletInfo);
          await YcConfig.setWalletInfo(ycWallet);
          YcEvents.emit(EventsWalletUpdate());
        }
        Map<String, dynamic> behaviorInfo = response['behaviorInfo'];
        if (behaviorInfo.isNotEmpty) {
          YcBehavior ycBehavior = YcBehavior.fromJson(behaviorInfo);
          await YcConfig.setBehaviorInfo(ycBehavior);
          YcEvents.emit(EventsBehaviorUpdate());
        }
        return amount;
      }
    }
    return 0;
  }

  static Future<int> receiveContinuitySign(int days) async {
    String apiUriReceiveContinuitySign = YcConfig.apiUriReceiveContinuitySign();
    if (apiUriReceiveContinuitySign.isNotEmpty) {
      Map<String, dynamic>? response = await YcApisProvider.to.doPost(
          apiUriReceiveContinuitySign,
          query: {'days': days.toString()},
          showLoading: true);
      if (response != null) {
        int amount = response['amount'];
        Map<String, dynamic> walletInfo = response['walletInfo'];
        if (walletInfo.isNotEmpty) {
          YcWallet ycWallet = YcWallet.fromJson(walletInfo);
          await YcConfig.setWalletInfo(ycWallet);
          YcEvents.emit(EventsWalletUpdate());
        }
        Map<String, dynamic> behaviorInfo = response['behaviorInfo'];
        if (behaviorInfo.isNotEmpty) {
          YcBehavior ycBehavior = YcBehavior.fromJson(behaviorInfo);
          await YcConfig.setBehaviorInfo(ycBehavior);
          YcEvents.emit(EventsBehaviorUpdate());
        }
        return amount;
      }
    }
    return 0;
  }

  static Future<int> receiveTimerRewardRe() async {
    String apiUriReceiveTimerRewardRe = YcConfig.apiUriReceiveTimerRewardRe();
    if (apiUriReceiveTimerRewardRe.isNotEmpty) {
      Map<String, dynamic>? response = await YcApisProvider.to
          .doPost(apiUriReceiveTimerRewardRe, showLoading: true);
      if (response != null) {
        int amount = response['amount'];
        Map<String, dynamic> walletInfo = response['walletInfo'];
        if (walletInfo.isNotEmpty) {
          YcWallet ycWallet = YcWallet.fromJson(walletInfo);
          await YcConfig.setWalletInfo(ycWallet);
          YcEvents.emit(EventsWalletUpdate());
        }
        Map<String, dynamic> behaviorInfo = response['behaviorInfo'];
        if (behaviorInfo.isNotEmpty) {
          YcBehavior ycBehavior = YcBehavior.fromJson(behaviorInfo);
          await YcConfig.setBehaviorInfo(ycBehavior);
          YcEvents.emit(EventsBehaviorUpdate());
        }
        return amount;
      }
    }
    return 0;
  }
}
