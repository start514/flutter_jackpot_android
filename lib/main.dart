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

final Network net = new Network();

UserRecord userRecord;

LoginSpinDetails spinDetails;

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
      builder: (BuildContext context, Widget child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      theme: ThemeData(
        fontFamily: "Baskerville Old Face",
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: () {
      return assetsAudioPlayer.open(
        Audio("assets/audios/bg_audio.mp3"),
        autoStart: true,
        showNotification: false,
      );
    }));
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(pushedCallBack: () {
      return assetsAudioPlayer.stop();
    }));
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(inactiveCallBack: () {
      return assetsAudioPlayer.stop();
    }));
  }

  @override
  Widget build(BuildContext context) {
    Preferences.getString(Preferences.pfUserLogin).then(
      (value) {
        if (value != null) {
          LoginSignUpModel model = LoginSignUpModel.fromJson(
            json.decode(value),
          );
          userRecord = model.userRecord;
          spinDetails = model.userRecord.loginSpinDetails;

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
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 15.0,
        ),
      ),
    );
  }
}
