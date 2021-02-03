import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterjackpot/utils/common_utils.dart';
import 'package:applovin/applovin.dart';

import 'common/shared_preferences.dart';

class AdMobClass {
  static BannerAd myBanner;

  static void displayBannerAds(double anchorOffset) {
    try {
      Preferences.getString(Preferences.pfKConsumableIdNoads).then(
        (value) {
          if (value == null) {
            MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
              keywords: <String>[
                'dmv',
                'driving licence',
                'dmv practice test',
                'practice permit test',
                'driving test',
                'permit',
                'dmv driving test',
                'drivers license test',
                'dmv test',
                'dmv permit test',
              ],
              contentUrl: 'https://equitysoft.in',
              childDirected: false,
              testDevices: <String>[
                test_device_id1,
                test_device_id2,
                test_device_id3,
                test_device_id4,
                test_device_id5,
                test_device_id6,
                test_device_id7,
              ],
            );
            myBanner = BannerAd(
              adUnitId: "ca-app-pub-4114721748955868/8381206291",
              size: AdSize.banner,
              targetingInfo: targetingInfo,
              listener: (MobileAdEvent event) {},
            );

            myBanner
              ..load()
              ..show(
                anchorOffset: anchorOffset,
                anchorType: AnchorType.top,
              );

            myBanner.listener = (MobileAdEvent event) {
              switch (event) {
                case MobileAdEvent.loaded:
                  print("An ad has loaded successfully in memory.");
                  break;
                case MobileAdEvent.failedToLoad:
                  print("The ad failed to load into memory.");
                  break;
                case MobileAdEvent.clicked:
                  print("The opened ad was clicked on.");
                  break;
                case MobileAdEvent.impression:
                  print(
                      "The user is still looking at the ad. A new ad came up.");
                  break;
                case MobileAdEvent.opened:
                  print("The Ad is now open.");
                  break;
                case MobileAdEvent.leftApplication:
                  print("You've left the app after clicking the Ad.");
                  break;
                case MobileAdEvent.closed:
                  print("You've closed the Ad and returned to the app.");
                  break;
                default:
                  print("There's a 'new' MobileAdEvent?!");
              }
            };
          } else {}
        },
      );
    } catch (er) {
      print(er);
    }
  }

  static Future<void> hideBannerAd() async {
    await myBanner.dispose();
    myBanner = null;
  }

  static void showVideoAdd(
      {@required void afterVideoEnd(),
      @required bool isSpin,
      @required bool isInterstitial}) {
    try {
      Preferences.getString(Preferences.pfKConsumableIdNoads).then(
        (value) {
          if (value == null || isSpin) {
            AppLovin.requestInterstitial((AppLovinAdListener event) {
              print(event);
              if (event == AppLovinAdListener.adReceived) {
                AppLovin.showInterstitial(interstitial: isInterstitial);
              } else if (event == AppLovinAdListener.videoPlaybackEnded) {
                afterVideoEnd();
              }
            }, interstitial: isInterstitial);
          } else {
            afterVideoEnd();
          }
        },
      );
    } catch (er) {
      print(er);
    }
  }

  static MobileAdTargetingInfo _getMobileAdTargetingInfo() {
    return MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[
        test_device_id1,
        test_device_id2,
        test_device_id3,
        test_device_id4,
        test_device_id5,
        test_device_id6,
        test_device_id7,
      ],
    );
  }

//  static void displayFullScreenAds(String fulladId) {
//    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//      keywords: <String>[
//        'dmv',
//        'driving licence',
//        'dmv practice test',
//        'practice permit test',
//        'driving test',
//        'permit',
//        'dmv driving test',
//        'drivers license test',
//        'dmv test',
//        'dmv permit test',
//      ],
//      contentUrl: 'https://equitysoft.in',
//      childDirected: false,
//      testDevices: <String>[
//        test_device_id1,
//        test_device_id2,
//        test_device_id3,
//        test_device_id4,
//        test_device_id5
//      ],
//    );
//
//    InterstitialAd myInterstitial = InterstitialAd(
//      adUnitId: fulladId,
//      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {},
//    );
//
//    myInterstitial
//      ..load()
//      ..show(
//        anchorType: AnchorType.bottom,
//        anchorOffset: 0.0,
//      );
//  }
}
