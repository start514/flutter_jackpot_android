import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/controller/network_class.dart';
import 'package:flutterjackpot/life_cycle_handler.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/view/home/home_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_signup_model.dart';
import 'package:flutterjackpot/view/login_signUp/login_with_fb_google_screen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';
import 'package:unity_ads_plugin/unity_ads.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'dart:io' show Platform;

final Network net = new Network();

UserRecord? userRecord;

LoginSpinDetails? spinDetails;

final assetsAudioPlayer = AssetsAudioPlayer();

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    assetsAudioPlayer.open(
      Audio("assets/audios/bg_audio.mp3"),
      autoStart: true,
      showNotification: false,
    );
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "DIN Condensed",
      ),
      home: GetAndCheckDataInSF(),
    );
  }
}

class GetAndCheckDataInSF extends StatefulWidget {
  @override
  _GetAndCheckDataInSFState createState() => _GetAndCheckDataInSFState();
}

class _GetAndCheckDataInSFState extends State<GetAndCheckDataInSF> {
  bool _isLoading = true;
  List<String> _adv_loading = ["QUIZSTART", "QUIZEND"];

  // void initAppodeal() async {

  //   Appodeal.setAppKeys(
  //     androidAppKey: '0e9e24eecc73c43716642931682a10923f19d3cd4f50f211',
  //     iosAppKey: '0e9e24eecc73c43716642931682a10923f19d3cd4f50f211'
  //   );

  //   // Request authorization to track the user
  //   await Appodeal.requestIOSTrackingAuthorization();
  //   bool shouldShow = await Appodeal.shouldShowConsent();
  //   bool hasConsent = false;
  //   print("===Should show: $shouldShow");
  //   if(shouldShow) {
  //        await Appodeal.requestConsentAuthorization();
  //        var consent = await Appodeal.fetchConsentInfo();
  //  hasConsent = consent.status == ConsentStatus.PERSONALIZED || consent.status == ConsentStatus.PARTLY_PERSONALIZED;
  //   }
  //     // Set interstitial ads to be cached manually
  //     await Appodeal.setAutoCache(AdType.INTERSTITIAL, false);
  //     await Appodeal.setAutoCache(AdType.REWARD, false);

  //     // Initialize Appodeal after the authorization was granted or not
  //     await Appodeal.initialize(
  //       hasConsent: hasConsent,
  //       adTypes: [
  //         AdType.BANNER,
  //         AdType.INTERSTITIAL,
  //         AdType.REWARD
  //       ],
  //       testMode: false
  //     );

  //     setState(() => this._isLoading = false);
  // print("====Appodeal initialized");
  // }

  @override
  void initState() {
    super.initState();

    String gameId = "3939865"; // Apple 3939864 // Android 3939865
    if (Platform.isIOS) {
      gameId = "3939864";
    }
    this._adv_loading.forEach((element) {
      UnityAds.isReady(placementId: element).then((isReady) async {
        if (isReady == null) return;
        print('Ready Listener: $element => $isReady');
        if (isReady) {
          if (this._adv_loading.isEmpty) {
            return;
          }
          this._adv_loading.remove(element.toString());
          print(this._adv_loading.toString());
          if (this._adv_loading.isEmpty) {
            await getState();
            setState(() => this._isLoading = false);
          }
        }
      });
    });
    UnityAds.init(
        gameId: gameId,
        listener: (state, args) async {
          print('Init Listener: $state => $args');
          if (state == UnityAdState.ready) {
            print(args["placementId"]);
            if (this._adv_loading.isEmpty) {
              return;
            }
            this._adv_loading.remove(args["placementId"]);
            print(this._adv_loading.toString());
            if (this._adv_loading.isEmpty) {
              await getState();
              setState(() => this._isLoading = false);
            }
          }
        });
    // Set the app keys
    //initAppodeal();
    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(resumeCallBack: () {
      return assetsAudioPlayer.open(
        Audio("assets/audios/bg_audio.mp3"),
        autoStart: true,
        showNotification: false,
      );
    }));
    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(pushedCallBack: () {
      return assetsAudioPlayer.stop();
    }));
    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(inactiveCallBack: () {
      return assetsAudioPlayer.stop();
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (this._isLoading == false) {
      Preferences.getString(Preferences.pfUserLogin).then(
        (value) async {
          if (value != null && value != "") {
            LoginSignUpModel model = LoginSignUpModel.fromJson(
              json.decode(value),
            );
            userRecord = model.userRecord;
            spinDetails = model.userRecord!.loginSpinDetails;

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginWithFBAndGoogleScreen(),
                ),
                (route) => false);
          }
        },
      );
    }
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 15.0,
        ),
      ),
    );
  }
}

Future<bool> getState() async {
  try {
    if (userRecord?.userID == null) {
      return false;
    }
    Map<String, dynamic> body = {
      "user_id": userRecord!.userID,
    };
    dynamic response = await net.getWithDio(url: UrlGetState, body: body);

    if (response["status"] == 1) {
      LoginSignUpModel model = LoginSignUpModel.fromJson(response);
      userRecord = model.userRecord;
      spinDetails = model.userRecord!.loginSpinDetails;

      await Preferences.setString(
        Preferences.pfUserLogin,
        json.encode(response),
      );

      return true;
    } else {}
  } catch (error, st) {
    print(st);
    print("SPIN CATCH ERROR : $error");
  }
  return false;
}
