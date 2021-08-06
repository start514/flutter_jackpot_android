import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/streak_rules_dialogs.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';
import 'package:flutterjackpot/view/trivia_streak/get_streak_model.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_category_screen.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_controller.dart';
import 'package:intl/intl.dart';

const LIFE_GENERATION_PERIOD = 120;

class TriviaStreakScreen extends StatefulWidget {
  @override
  _TriviaStreakScreenState createState() => _TriviaStreakScreenState();
}

class _TriviaStreakScreenState extends State<TriviaStreakScreen> {
  TriviaStreakController triviaStreakController = new TriviaStreakController();

  final searchController = new TextEditingController();

  List<Categories>? categories;
  List<Quiz>? quiz;
  List<Quiz> searchQuiz = [];

  String? searchWord;
  bool isSearch = false;

  bool _isLoading = true;
  double unitHeightValue = 1;
  double unitWidthValue = 1;
  String endDate = "";
  List<StreakEntry>? leaders;
  int score = 0;
  int scoreMax = 0;
  int life = 5;
  DateTime? lastConsumeDate;
  late Timer _timer;
  bool isLeaderBoardShown = false;
  bool isWinnerBoardShown = false;

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(milliseconds: 500), onTimerTick);
    triviaStreakController.getStreak(userID: userRecord?.userID).then((value) {
      setState(() {
        if (value == null) return;
        _isLoading = false;
        endDate = DateFormat("MM/dd/yy").format(value.endDate!);
        leaders = value.leaders;
        score = value.score!;
        scoreMax = value.scoreMax!;
      });
    });
    Preferences.getString(Preferences.pfKConsumableIdLife).then((value) {
      if (value != null && value != "") {
        setState(() {
          life = int.parse(value);
        });
      }
    });
    Preferences.getString(Preferences.pfKLastLifeConsumeDate).then((value) {
      if (value != null && value != "") {
        setState(() {
          lastConsumeDate = DateTime.parse(value);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return Stack(
      children: [
        bgImage(context),
        Scaffold(
          backgroundColor: transparentColor,
          body: _isLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    radius: 15.0,
                  ),
                )
              : _bodyWidget(),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(unitHeightValue * 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: isLeaderBoardShown
                ? <Widget>[
                    sizedBoxAddMob(unitHeightValue * 42.0),
                    _navigationView(),
                    SizedBox(height: 30),
                    _titleView(),
                    SizedBox(height: 20),
                    _leaderBoardView(),
                    SizedBox(height: 23),
                    _footerView(),
                  ]
                : (isWinnerBoardShown
                    ? <Widget>[
                        sizedBoxAddMob(unitHeightValue * 42.0),
                        _navigationView(),
                        SizedBox(height: 30),
                        _titleView(),
                        _winnerView(),
                        _footerView(),
                      ]
                    : <Widget>[
                        sizedBoxAddMob(unitHeightValue * 42.0),
                        _navigationView(),
                        SizedBox(height: 30),
                        _titleView(),
                        SizedBox(height: 30),
                        _leadersView(),
                        SizedBox(height: 30),
                        _myStreakView(),
                        SizedBox(height: 30),
                        _footerView(),
                      ]),
          ),
        ),
      ),
    );
  }

  Widget _leaderBoardView() {
    List<Widget> widgets = List.empty(growable: true);
    int rank = 0;
    for (StreakEntry leader in leaders ?? []) {
      rank++;
      int _score = leader.score!;
      widgets.add(_leaderBoardItemView("$rank", leader.name ?? "", "$_score"));
      widgets.add(SizedBox(height: 5));
    }
    // int minItemCount = 10;
    // if ((leaders ?? []).length < minItemCount) {
    //   int more = minItemCount - (leaders ?? []).length;
    //   for (int i = 0; i < more; i++) {
    //     widgets.add(_leaderBoardItemView("", "", ""));
    //     widgets.add(SizedBox(height: 5));
    //   }
    // }
    return Container(
      child: Column(
        children: [
          _leaderBoardItemView("RANK", "USERNAME", "STREAK"),
          SizedBox(height: 5),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: widgets,
              ),
            ),
            height: unitHeightValue * 600,
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(unitWidthValue * 20),
        color: Colors.white,
      ),
    );
  }

  Widget _leaderBoardItemView(String rank, String name, String score) {
    int fontSize = 25;
    int seperatorHeight = 4;
    return Container(
      child: Row(
        children: [
          Container(
            child: Text(
              "$rank",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.symmetric(vertical: unitHeightValue * 10),
            width: unitWidthValue * 80,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.black,
                    width: unitWidthValue * seperatorHeight),
              ),
            ),
          ),
          Container(
            child: Text(
              "$name",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.symmetric(vertical: unitHeightValue * 10),
            width: unitWidthValue * 270,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.black,
                    width: unitWidthValue * seperatorHeight),
              ),
            ),
          ),
          Container(
            child: Text(
              "$score",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.symmetric(vertical: unitHeightValue * 10),
            width: unitWidthValue * 105,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.black,
                    width: unitWidthValue * seperatorHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _winnerView() {
    return Container(height: unitHeightValue * 717);
  }

  Widget _navigationView() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      SizedBox(
        height: unitHeightValue * 45.0,
        width: unitWidthValue * 100,
        child: RaisedButton(
          child: Icon(
            Icons.arrow_back_outlined,
            color: greenColor,
            size: unitHeightValue * 24.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: blackColor,
          textColor: blackColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: greenColor, width: unitWidthValue * 2.0),
            borderRadius: BorderRadius.circular(29.5),
          ),
        ),
      ),
      SizedBox(
        width: unitWidthValue * 5,
      ),
      Expanded(
        child: Container(
          // width: unitWidthValue * double.infinity,
          padding: EdgeInsets.all(unitHeightValue * 8.0),
          decoration: BoxDecoration(
            color: blackColor,
            border: Border.all(
              color: greenColor,
              width: unitWidthValue * 2,
            ),
            borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
          ),
          child: Text(
            "TRIVIA STREAK",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: unitHeightValue * 26.0,
                color: whiteColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SizedBox(
        width: unitWidthValue * 5,
      ),
      SizedBox(
        height: unitHeightValue * 45.0,
        width: unitWidthValue * 100,
        child: RaisedButton(
          child: Text(
            "RULES",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: whiteColor,
                fontSize: unitHeightValue * 20),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => StreakRulesDialog(),
            );
          },
          padding: EdgeInsets.all(0),
          color: blackColor,
          textColor: blackColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: greenColor, width: unitWidthValue * 2.0),
            borderRadius: BorderRadius.circular(unitHeightValue * 10),
          ),
        ),
      ),
    ]);
  }

  Widget _titleView() {
    return Row(children: [
      Container(
        child: Text("ENDS $endDate",
            style: TextStyle(
                fontSize: unitHeightValue * 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.underline)),
        decoration: BoxDecoration(
            border: Border.all(width: unitWidthValue * 1, color: Colors.black),
            borderRadius: BorderRadius.circular(unitWidthValue * 15),
            color: Colors.white),
        padding: EdgeInsets.all(unitWidthValue * 6),
      ),
      Text(
        "CONTEST LEADERS    ",
        style: TextStyle(
          color: greenColor,
          fontSize: unitWidthValue * 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    ], mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  Widget _myStreakView() {
    int lifeCalculated = calcLife();
    return Stack(
      children: [
        Center(
          child: Container(
            width: unitWidthValue * 420,
            height: unitHeightValue * 350,
            decoration: BoxDecoration(
                border:
                    Border.all(width: unitWidthValue * 3, color: greenColor),
                borderRadius: BorderRadius.circular(unitWidthValue * 20),
                color: Colors.white),
            margin: EdgeInsets.only(top: unitWidthValue * 30),
            padding: EdgeInsets.only(top: unitWidthValue * 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              "$score",
                              style: TextStyle(
                                color: greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: unitWidthValue * 60,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: unitWidthValue * 3, color: greenColor),
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 30),
                          ),
                          width: unitWidthValue * 100,
                          height: unitWidthValue * 100,
                        ),
                        Text(
                          "CURRENT",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: unitWidthValue * 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: unitWidthValue * 30),
                    Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              "$scoreMax",
                              style: TextStyle(
                                color: greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: unitWidthValue * 60,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: unitWidthValue * 3, color: greenColor),
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 30),
                          ),
                          width: unitWidthValue * 100,
                          height: unitWidthValue * 100,
                        ),
                        Text(
                          "HIGHEST",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: unitWidthValue * 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: unitWidthValue * 30),
                InkWell(
                    child: Stack(
                      children: [
                        Container(
                          child: Text(
                            "PLAY NOW!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: unitHeightValue * 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 15),
                            border: Border.all(
                              color: Colors.black,
                              width: unitWidthValue * 3,
                            ),
                            color: greenColor,
                          ),
                          padding: EdgeInsets.fromLTRB(
                              unitWidthValue * 90, 0, unitWidthValue * 20, 0),
                        ),
                        Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/flat_heart.png",
                              ),
                              Container(
                                child: Text(
                                  "$lifeCalculated",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitWidthValue * 30,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                width: unitWidthValue * 78,
                                height: unitHeightValue * 78,
                                padding:
                                    EdgeInsets.only(top: unitHeightValue * 13),
                              ),
                            ],
                            alignment: Alignment.center,
                          ),
                          width: unitWidthValue * 78,
                          height: unitHeightValue * 78,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 15),
                            border: Border.all(
                              color: Colors.black,
                              width: unitWidthValue * 3,
                            ),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    onTap: () async {
                      bool ret = await consumeLife();
                      if (ret) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TriviaStreakCategoryScreen(),
                          ),
                        );
                      } else {
                        print("No life!");
                      }
                    })
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              //My Streak
              Container(
                child: Text(
                  "MY STREAK",
                  style: TextStyle(
                    fontSize: unitWidthValue * 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border:
                      Border.all(color: greenColor, width: unitWidthValue * 3),
                  borderRadius: BorderRadius.circular(unitWidthValue * 30),
                ),
                padding: EdgeInsets.fromLTRB(
                  unitWidthValue * 25,
                  0,
                  unitWidthValue * 25,
                  0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footerView() {
    String waitTimerText = calcWaitTimer();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Row(
            children: [
              Image.asset("assets/red_heart.png"),
              Text(waitTimerText,
                  style: TextStyle(
                      fontSize: unitWidthValue * 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          height: unitHeightValue * 60,
          padding: EdgeInsets.all(unitWidthValue * 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: unitWidthValue * 3),
            borderRadius: BorderRadius.circular(unitWidthValue * 15),
          ),
        ),
        SizedBox(width: unitWidthValue * 15),
        InkWell(
          child: Container(
            child: Text(
              "LEADERBOARD",
              style: TextStyle(
                  fontSize: unitWidthValue * 18, fontWeight: FontWeight.bold),
            ),
            height: unitHeightValue * 60,
            padding: EdgeInsets.all(unitWidthValue * 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: Colors.black, width: unitWidthValue * 3),
              borderRadius: BorderRadius.circular(unitWidthValue * 15),
            ),
          ),
          onTap: () {
            setState(() {
              if (isLeaderBoardShown) {
                isLeaderBoardShown = false;
                isWinnerBoardShown = false;
              } else {
                isLeaderBoardShown = true;
                isWinnerBoardShown = false;
              }
            });
          },
        ),
        SizedBox(width: unitWidthValue * 15),
        InkWell(
          child: Container(
            child: Text(
              "WINNERS",
              style: TextStyle(
                  fontSize: unitWidthValue * 18, fontWeight: FontWeight.bold),
            ),
            height: unitHeightValue * 60,
            padding: EdgeInsets.all(unitWidthValue * 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: Colors.black, width: unitWidthValue * 3),
              borderRadius: BorderRadius.circular(unitWidthValue * 15),
            ),
          ),
          onTap: () {
            if (isWinnerBoardShown) {
              isLeaderBoardShown = false;
              isWinnerBoardShown = false;
            } else {
              isLeaderBoardShown = false;
              isWinnerBoardShown = true;
            }
          },
        ),
      ],
    );
  }

  Widget _leaderView(String rank, int price, int streak, String name) {
    return Row(children: [
      Container(
        child: Row(children: [
          Text("$rank-",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: unitHeightValue * 30)),
          Text("\$$price",
              style: TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: unitHeightValue * 30))
        ]),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(unitWidthValue * 15),
          border: Border.all(color: Colors.white, width: unitWidthValue * 2),
          color: Colors.black,
        ),
        padding: EdgeInsets.fromLTRB(unitWidthValue * 15, unitWidthValue * 5,
            unitWidthValue * 15, unitWidthValue * 5),
        width: unitWidthValue * 150,
      ),
      Container(
          height: unitHeightValue * 3,
          width: unitWidthValue * 20,
          color: Colors.white),
      Container(
        child: Text(
          "$streak",
          style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: unitHeightValue * 30),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(unitWidthValue * 15),
          border: Border.all(color: Colors.white, width: unitWidthValue * 2),
          color: Colors.black,
        ),
        padding: EdgeInsets.fromLTRB(unitWidthValue * 15, unitWidthValue * 5,
            unitWidthValue * 15, unitWidthValue * 5),
        width: unitWidthValue * 75,
      ),
      Container(
          height: unitHeightValue * 3,
          width: unitWidthValue * 20,
          color: Colors.white),
      Container(
        child: Text(
          "$name",
          style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: unitHeightValue * 30),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(unitWidthValue * 15),
          border: Border.all(color: Colors.white, width: unitWidthValue * 2),
          color: Colors.black,
        ),
        padding: EdgeInsets.fromLTRB(unitWidthValue * 15, unitWidthValue * 5,
            unitWidthValue * 15, unitWidthValue * 5),
        width: unitWidthValue * 180,
      ),
    ]);
  }

  Widget _leadersView() {
    List<Widget> widgets = List.empty(growable: true);
    int rank = 0;
    for (StreakEntry leader in leaders ?? []) {
      rank++;
      if (rank > 3) break;
      String rankstr = "";
      int price = 0;
      if (rank == 1) {
        rankstr = "1ST";
        price = 100;
      } else if (rank == 2) {
        rankstr = "2ND";
        price = 50;
      } else if (rank == 3) {
        rankstr = "3RD";
        price = 25;
      }
      widgets.add(
          _leaderView(rankstr, price, leader.score ?? 0, leader.name ?? ""));
      widgets.add(SizedBox(height: 10));
    }
    return Column(
      children: widgets,
    );
  }

  int calcLife() {
    if (lastConsumeDate == null) return life;
    Duration diff = DateTime.now().difference(lastConsumeDate!);
    int generatedLife = (diff.inSeconds / LIFE_GENERATION_PERIOD).floor();
    return min(life + generatedLife, 5);
  }

  String calcWaitTimer() {
    if (lastConsumeDate == null || calcLife() == 5) return "FULL";
    Duration diff = DateTime.now().difference(lastConsumeDate!);
    int wait = diff.inSeconds % LIFE_GENERATION_PERIOD;
    wait = LIFE_GENERATION_PERIOD - wait;
    int min = (wait / 60).floor();
    int sec = wait % 60;
    return DateFormat("IN mm:ss").format(new DateTime(2000, 1, 1, 0, min, sec));
  }

  Future<bool> consumeLife() async {
    int currentLife = calcLife();
    if (currentLife == 0) {
      return false;
    }
    currentLife--;
    await Preferences.setString(
        Preferences.pfKConsumableIdLife, currentLife.toString());
    await Preferences.setString(
        Preferences.pfKLastLifeConsumeDate, DateTime.now().toIso8601String());
    setState(() {
      life = currentLife;
      lastConsumeDate = DateTime.now();
    });
    return true;
  }

  void onTimerTick(Timer timer) {
    setState(() {});
  }
}
