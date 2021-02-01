import 'package:flutter/foundation.dart';
import 'constants.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class Unity {
  Unity._();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static void initialize() {
    UnityAds.init(
      gameId: Constants.gameIdAndroid,
      testMode: kDebugMode,
      listener: (state, args) => print('Init Listener: $state => $args'),
    );
  }

  static showRewardedAd() async {
    await UnityAds.isReady(placementId: Constants.rewardedAdId)
        ? UnityAds.showVideoAd(
            placementId: Constants.rewardedAdId,
            listener: (state, args) =>
                print('Rewarded Video Listener: $state => $args'),
          )
        : UnityAds.showVideoAd(
            placementId: Constants.interstitialAdId,
            listener: (state, args) =>
                print('Rewarded Video Listener: $state => $args'),
          );
  }

  static showbannerAd() => UnityBannerAd(
        placementId: Constants.bannerAdId,
        listener: (state, args) {
          print('Banner Listener: $state => $args');
        },
      );
}
