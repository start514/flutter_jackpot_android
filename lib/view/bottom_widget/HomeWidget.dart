import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/models/winner_score_model.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/view/bottom_widget/winner_score_controller.dart';
import 'package:flutterjackpot/view/give_aways/giveaways_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_screen.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_with_fb_google_screen.dart';
import 'package:flutterjackpot/view/power_ups_screen.dart';
import 'package:flutterjackpot/view/ranking/ranking_screen.dart';
import 'package:flutterjackpot/view/spinner/spinner_controller.dart';
import 'package:flutterjackpot/view/spinner/spinner_screen.dart';
import 'package:flutterjackpot/view/winners/winners_screen.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/main.dart';
// import 'package:appodeal_flutter/appodeal_flutter.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  WinnerScoreController winnerScoreController = new WinnerScoreController();
  SendSpinRewardController sendSpinRewardController =
      new SendSpinRewardController();

  WinnerScore? winnerScore = new WinnerScore();

  bool _isLoading = true;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    getState().then((bool ret) => setState(() => {}));
    _getWinnerScore();
    // FirebaseAdMob.instance
    //  OLD ID : ca-app-pub-3940256099942544/6300978111
    // .initialize(appId: 'ca-app-pub-4114721748955868~2866506809');
    // AdMobClass.displayBannerAds(Platform.isIOS ? 00.0 : 40.0);
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return Scaffold(
      backgroundColor: transparentColor,
      body: _isLoading
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 15.0,
              ),
            )
          : _bodyWidget(winnerScore!),
    );
  }

  dynamic onGoBack(dynamic value) {
    setState(() {});
    print('Backed to HomeWidget');
    return value;
  }

  Widget _bodyWidget(WinnerScore winnerScore) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: unitWidthValue * 12,
            top: 0,
            right: unitWidthValue * 12,
            bottom: unitHeightValue * 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // sizedBoxAddMob(45.0),
            // AppodealBanner(),
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: unitHeightValue * 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "TRIVIA",
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: unitHeightValue * 90,
                          // height:  unitHeightValue * 90,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              child: Image.asset(
                            "assets/money.png",
                            height: unitHeightValue * 32.0,
                            width: unitWidthValue * 80.0,
                          )),
                          Text(
                            "STAX",
                            style: TextStyle(
                              color: greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: unitHeightValue * 40,
                            ),
                          ),
                        ],
                      )
                    ],
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
                          builder: (BuildContext context) {
                            return new SimpleDialog(
                              title: new Text(
                                "Are You Sure You Want To LogOut This App!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: new SimpleDialogOption(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: InkWell(
                                            child: new Text(
                                              "Cancle",
                                              style: TextStyle(
                                                  fontSize:
                                                      unitHeightValue * 18.0,
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
                                                fontSize:
                                                    unitHeightValue * 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          onTap: () {
                                            Preferences.setString(
                                                Preferences.pfUserLogin, "");
                                            Preferences.setString(
                                                Preferences.pfTapSpin, "");
                                            Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginWithFBAndGoogleScreen(),
                                                    ),
                                                    (route) => false)
                                                .then(onGoBack);
                                            print("LOGOUT SUCCESSFULLY");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: unitHeightValue * 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: unitWidthValue * 24.0,
                        right: unitWidthValue * 24.0,
                        top: unitHeightValue * 8.0,
                        bottom: unitHeightValue * 8.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: unitWidthValue * 1.5,
                      ),
                      borderRadius:
                          BorderRadius.circular(unitHeightValue * 36.0),
                    ),
                    child: Text(
                      winnerScore.winnerScore != null
                          ? winnerScore.winnerScore!
                          : "\$ 0",
                      style: TextStyle(
                        fontSize: unitHeightValue * 25.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  /*Container(
                    padding: EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: unitWidthValue * 1.5,
                      ),
                      borderRadius: BorderRadius.circular(unitHeightValue * 36.0),
                    ),
                    child: Text(
                      "Jackpot",
                      style: TextStyle(
                          fontSize: unitHeightValue * 27.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),*/
                ],
              ),
            ),
            SizedBox(
              height: unitHeightValue * 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: unitWidthValue * 12.0),
              // child: layoutBuilderDot(whiteColor),
            ),
            SizedBox(
              height: unitHeightValue * 15.0,
            ),
            _roundedRowContainer(
              title: "JACKPOT TRIVIA",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JackPotTriviaScreen(),
                  ),
                ).then(onGoBack);
              },
            ),
            SizedBox(
              height: unitHeightValue * 15.0,
            ),
            _roundedRowContainer(
              title: "GIVEAWAYS",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiveawaysScreen(),
                  ),
                ).then(onGoBack);
              },
            ),
            SizedBox(
              height: unitHeightValue * 15.0,
            ),

            _roundedRowContainer(
                title: "TRIVIA STREAK",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TriviaStreakScreen(),
                    ),
                  ).then(onGoBack);
                },
                comingSoon: false),
            SizedBox(
              height: unitHeightValue * 30.0,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _roundedRowContainer(
                    title: "POWER UPS",
                    type: 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PowerUPSScreen(),
                        ),
                      ).then(onGoBack);
                    },
                  ),
                  _roundedRowContainer(
                    title: "WINNERS",
                    type: 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WinnersScreen(),
                        ),
                      ).then(onGoBack);
                    },
                  ),
                ]),
            SizedBox(
              height: unitHeightValue * 15.0,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _roundedRowContainer(
                    title: "RANKINGS",
                    type: 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RankingScreen(),
                        ),
                      ).then(onGoBack);
                    },
                  ),
                  _roundedRowContainer(
                    title: "FREEBIES",
                    type: 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpinnerScreen(
                            winnerScore: winnerScore,
                          ),
                        ),
                      ).then(onGoBack);
                    },
                  ),
                ]),
            SizedBox(
              height: unitHeightValue * 15.0,
            ),
            _roundedRowContainer(
              title: "~ NO ADS!! ~",
              type: 2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PowerUPSScreen(),
                  ),
                ).then(onGoBack);
              },
            ),
            SizedBox(
              height: unitHeightValue * 30.0,
            ),
            roundLevel(),
          ],
        ),
      ),
    );
  }

  Widget _roundedRowContainer(
      {required String title, int? type, bool? comingSoon, void onTap()?}) {
    double width = double.infinity;
    double fontSize = 32;
    if (type == 1) {
      fontSize = 28;
      width = 200;
    } else if (type == 2) {
      fontSize = 30;
      width = 250;
    }
    return InkWell(
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: unitWidthValue * width,
            // height: unitHeightValue * 60,
            margin: type == null
                ? EdgeInsets.fromLTRB(unitWidthValue * 24, unitHeightValue * 8,
                    unitWidthValue * 24, 0)
                : EdgeInsets.fromLTRB(
                    unitWidthValue * 4, 0, unitWidthValue * 4, 0),
            decoration: BoxDecoration(
              color: blackColor,
              border: Border.all(
                color: type == null ? greenColor : whiteColor,
                width: unitWidthValue * 2,
              ),
              borderRadius: BorderRadius.circular(unitHeightValue * 27.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  unitWidthValue * 8,
                  unitHeightValue * 10,
                  unitWidthValue * 8,
                  unitHeightValue * 6),
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: type == null ? greenColor : whiteColor,
                        fontSize: unitHeightValue * fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        (comingSoon == true
            ? Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: unitWidthValue * 20),
                  width: unitHeightValue * 76,
                  height: unitHeightValue * 76,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: unitHeightValue * 4,
                    ),
                    borderRadius:
                        BorderRadius.circular(unitHeightValue * 100.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: unitHeightValue * 16),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Coming\nsoon",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: unitHeightValue * 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ))
            : Container())
      ]),
      onTap: onTap,
    );
  }

  Widget _roundedContainerImageStack(
      {required String imageName, String? image, void onTap()?}) {
    return Expanded(
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 22.0),
              width: unitWidthValue * 75.0,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 2,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 23.5),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Image.asset(
                  "assets/$image",
                  height: unitHeightValue * 40.0,
                  width: unitWidthValue * 40.0,
                ),
              ),
            ),
            SizedBox(),
            Container(
              width: unitWidthValue * 80.0,
              padding: EdgeInsets.all(unitHeightValue * 5.0),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 2,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 20.0),
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

  Widget roundLevel() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            userRecord!.name != null ? "${userRecord!.name}" : "",
            style: TextStyle(
                fontSize: unitHeightValue * 28,
                color: whiteColor,
                fontWeight: FontWeight.bold),
          ),
          Text(
            userRecord!.totalPoints != null ? "${userRecord!.totalPoints}" : "",
            style: TextStyle(
                fontSize: unitHeightValue * 28,
                color: whiteColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(
        height: unitHeightValue * 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              _detailButton(
                  text: spinDetails!.theBomb != null
                      ? spinDetails!.theBomb!
                      : "0",
                  image: "bomb.png",
                  size: 60), //spinDetails!.theBomb!
              _detailButton(
                  text: spinDetails!.thePlayer != null
                      ? spinDetails!.thePlayer!
                      : "0",
                  image: "player2.png",
                  bottom: true,
                  size: 50), //spinDetails!.thePlayer!,
              _detailButton(
                  text: spinDetails!.theTime != null
                      ? spinDetails!.theTime!
                      : "0",
                  image: "clock.png",
                  bottom: true,
                  size: 50), //spinDetails!.theTime!,
            ],
          ),
        ],
      ),
    ]);
  }

  Widget _detailButton(
      {String? image,
      required String text,
      required double size,
      bool? bottom,
      void onTap()?}) {
    size = unitHeightValue * size;
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: unitHeightValue * 18.0,
                bottom: unitHeightValue * 8.0,
                right: 0,
                left: unitWidthValue * 26.0),
            width: unitWidthValue * 104,
            padding: EdgeInsets.only(
                top: unitHeightValue * 4.0,
                bottom: unitHeightValue * 4,
                right: 1,
                left: unitWidthValue * 45),
            // decoration: BoxDecoration(
            //   // color: whiteColor,
            //   border: Border.all(
            //     // color: blackColor,
            //     width: unitWidthValue * 2,
            //   ),
            //   borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
            // ),
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: unitHeightValue * 28.0,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(
                  top: unitHeightValue * (bottom != true ? 5.0 : 15),
                  left: unitWidthValue * 20.0),
              child: Image.asset(
                "assets/$image",
                height: size,
                width: size,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        onTap!();
      },
    );
  }

  Future<void> _getWinnerScore() async {
    winnerScore = await winnerScoreController.getWinnerScoreAPI();
    setState(() => this._isLoading = false);
  }
}
