import 'package:flutter/cupertino.dart';
import 'package:flutterjackpot/utils/common_utils.dart';
// import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';
import 'package:unity_ads_plugin/unity_ads.dart';
import 'package:flutterjackpot/main.dart';

import 'common/shared_preferences.dart';

class AdMobClass {
  static void showVideoAdd(
      {required void afterVideoEnd(), required bool isSpin}) async {
    try {
      Preferences.getString(Preferences.pfKConsumableIdNoads).then(
        (value) {
          if (value == null || isSpin) {
            UnityAds.showVideoAd(
              placementId: 'QUIZSTART',
              listener: (state, args) {
                if (state == UnityAdState.complete) {
                  afterVideoEnd();
                  print('User watched a video. User should get a reward!');
                } else if (state == UnityAdState.skipped) {
                  print('User cancel video.');
                }
              },
            );
            // Appodeal.setInterstitialCallback((event) {
            // 	print('Interstitial ad triggered the event $event');
            // 		if (event == "onInterstitialClosed" || event == "onInterstitialFailedToLoad") {

            // 		} else if(event == "onInterstitialLoaded") {
            // 		print("=====Before show");
            // 		Appodeal.show(AdType.INTERSTITIAL);
            // 	}
            // });
            // Appodeal.cache(AdType.INTERSTITIAL);

          } else {
            afterVideoEnd();
          }
        },
      );
    } catch (er) {
      print(er);
    }
    await getState();
  }

  static void showRewardAdd(
      {required void afterVideoEnd(), required bool isSpin}) async {
    try {
      Preferences.getString(Preferences.pfKConsumableIdNoads).then(
        (value) {
          if (value == null || isSpin) {
            UnityAds.showVideoAd(
              placementId: 'QUIZEND',
              listener: (state, args) {
                if (state == UnityAdState.complete) {
                  afterVideoEnd();
                  print('User watched a video. User should get a reward!');
                } else if (state == UnityAdState.skipped) {
                  print('User cancel video.');
                  afterVideoEnd();
                }
              },
            );

        		// Appodeal.setRewardCallback((event) {
          //   	print('Reward ad triggered the event $event');
          // 		if (event == "onRewardedVideoClosed" || event == "onRewardedVideoFinished") {
          //         afterVideoEnd();
          // 		} else if(event == "onRewardedVideoLoaded") {
          //   		print("=====Before show");
          //   		Appodeal.show(AdType.REWARD);
          //   	}
          //   });
          //   Appodeal.cache(AdType.REWARD);

          } else {
            afterVideoEnd();
          }
        },
      );
    } catch (er) {
      print(er);
    }
    await getState();
  }
}
