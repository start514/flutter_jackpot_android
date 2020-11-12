import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/models/winner_score_model.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/view/bottom_widget/winner_score_controller.dart';
import 'package:flutterjackpot/view/common/common_rounded_level.dart';
import 'package:flutterjackpot/view/give_aways/giveaways_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_with_fb_google_screen.dart';
import 'package:flutterjackpot/view/power_ups_screen.dart';
import 'package:flutterjackpot/view/ranking/ranking_screen.dart';
import 'package:flutterjackpot/view/spinner/spinner_controller.dart';
import 'package:flutterjackpot/view/spinner/spinner_screen.dart';
import 'package:flutterjackpot/view/winners/winners_screen.dart';
import 'package:applovin/applovin.dart';
import 'package:applovin/banner.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  WinnerScoreController winnerScoreController = new WinnerScoreController();
  SendSpinRewardController sendSpinRewardController =
      new SendSpinRewardController();

  WinnerScore winnerScore = new WinnerScore();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getWinnerScore();
    AppLovin.init();
    // FirebaseAdMob.instance
    //  OLD ID : ca-app-pub-3940256099942544/6300978111
    // .initialize(appId: 'ca-app-pub-4114721748955868~2866506809');
    // AdMobClass.displayBannerAds(Platform.isIOS ? 00.0 : 40.0);
  }

  listener(AppLovinAdListener event, bool isInter) {
    print(event);
    if (event == AppLovinAdListener.adReceived) {
      AppLovin.showInterstitial(interstitial: isInter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparentColor,
      body: _isLoading
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 15.0,
              ),
            )
          : _bodyWidget(winnerScore),
    );
  }

  Widget _bodyWidget(WinnerScore winnerScore) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 12, top: 50, right: 12, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // sizedBoxAddMob(45.0),
            BannerView((AppLovinAdListener event) => print(event),
                BannerAdSize.banner),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      color: transparentColor,
                      border: Border.all(
                        color: transparentColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    child: Text(
                      "Trivia \$tax",
                      style: TextStyle(
                          color: greenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 36.5,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      size: 35.5,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        child: new SimpleDialog(
                          title: new Text(
                            "Are You Sure You Want To LogOut This App!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: new SimpleDialogOption(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: InkWell(
                                        child: new Text(
                                          "Cancle",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      onTap: () {
                                        Preferences.setString(
                                            Preferences.pfUserLogin, null);
                                        Preferences.setString(
                                            Preferences.pfTapSpin, null);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginWithFBAndGoogleScreen(),
                                            ),
                                            (route) => false);
                                        print("LOGOUT SUCCESSFULLY");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    child: Text(
                      winnerScore.winnerScore != null
                          ? winnerScore.winnerScore
                          : "\$ 0",
                      style: TextStyle(
                          fontSize: 25.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  /*Container(
                    padding: EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    child: Text(
                      "Jackpot",
                      style: TextStyle(
                          fontSize: 27.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),*/
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
              child: layoutBuilderDot(whiteColor),
            ),
            _roundedRowContainer(
              title: "Game of the Month",
              titleTxtSize: 17.0,
              color: whiteColor,
              subTitle: "Jackpot Trivia",
              buttonName: "PLAY NOW!",
              buttonWidth: double.infinity,
              buttonTextSize: 18.0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JackPotTriviaScreen(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _roundedRowContainer(
                    title: "Trivia Streak",
                    color: whiteColor,
                    buttonName: "Coming Soon!",
                    titleTxtSize: 17.0,
                    buttonWidth: null,
                    buttonTextSize: 16.0,
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: _roundedRowContainer(
                    title: "Giveaways",
                    color: whiteColor,
                    buttonName: "     Let's Go!     ",
                    titleTxtSize: 17.0,
                    buttonWidth: null,
                    buttonTextSize: 16.0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiveawaysScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
              child: layoutBuilderDot(whiteColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _roundedContainerImageStack(
                  image: "spin.png",
                  imageName: "Spin",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpinnerScreen(
                          winnerScore: winnerScore,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                _roundedContainerImageStack(
                  image: "power_ups.png",
                  imageName: "Power UP",
                  onTap: () {
                    /*showDialog(
                        context: context,
                        builder: (BuildContext context) => PowerUsDialog(),
                      );*/
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PowerUPSScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                _roundedContainerImageStack(
                  image: "winner_cup.png",
                  imageName: "Winners",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WinnersScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                _roundedContainerImageStack(
                  image: "ranking.png",
                  imageName: "Rankings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RankingScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
              child: layoutBuilderDot(whiteColor),
            ),
            roundLevel(),
          ],
        ),
      ),
    );
  }

  Widget _roundedRowContainer(
      {String title,
      String subTitle,
      String buttonName,
      double titleTxtSize,
      Color color,
      double buttonWidth,
      double buttonTextSize,
      void onTap()}) {
    return Container(
      decoration: BoxDecoration(
        color: color != null ? color : whiteColor,
        border: Border.all(
          color: blackColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(27.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: blackColor,
                  fontSize: titleTxtSize,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
              child: Divider(
                height: 2.5,
                thickness: 1.5,
                color: blackColor,
              ),
            ),
            subTitle != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 45.0,
              width: buttonWidth,
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: Text(
                    buttonName,
                    style: TextStyle(
                      fontSize: buttonTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: onTap,
                color: greenColor,
                textColor: blackColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: blackColor),
                  borderRadius: BorderRadius.circular(29.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundedContainerImageStack(
      {String imageName, String image, void onTap()}) {
    return Expanded(
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 22.0),
              width: 75.0,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(23.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  "assets/$image",
                  height: 40.0,
                  width: 40.0,
                ),
              ),
            ),
            SizedBox(),
            Container(
              width: 80.0,
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: AutoSizeText(
                imageName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _getWinnerScore() async {
    winnerScore = await winnerScoreController.getWinnerScoreAPI();
    setState(() {
      _isLoading = false;
    });
  }
}
