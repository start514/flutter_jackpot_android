import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_category_screen.dart';

class TriviaStreakScreen extends StatefulWidget {
  @override
  _TriviaStreakScreenState createState() => _TriviaStreakScreenState();
}

class _TriviaStreakScreenState extends State<TriviaStreakScreen> {
  JackpotCategoriesAndQuizController jackpotCategoriesController =
      new JackpotCategoriesAndQuizController();

  final searchController = new TextEditingController();

  List<Categories>? categories;
  List<Quiz>? quiz;
  List<Quiz> searchQuiz = [];

  String? searchWord;
  bool isSearch = false;

  bool _isLoading = false;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
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
            children: <Widget>[
              sizedBoxAddMob(unitHeightValue * 42.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: unitHeightValue * 45.0,
                      width: unitWidthValue * 100,
                      child: RaisedButton(
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: greenColor,
                          size: unitHeightValue * 24.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: blackColor,
                        textColor: blackColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: greenColor, width: unitWidthValue * 2.0),
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
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 15.0),
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
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) =>
                          //       GameRulesDialog(),
                          // );
                        },
                        padding: EdgeInsets.all(0),
                        color: blackColor,
                        textColor: blackColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: greenColor, width: unitWidthValue * 2.0),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 10),
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: 30),
              _titleView(),
              SizedBox(height: 30),
              _leadersView(),
              SizedBox(height: 30),
              _myStreakView(),
              SizedBox(height: 30),
              _footerView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleView() {
    return Row(children: [
      Container(
        child: Text("ENDS 8/31/21",
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
                              "8",
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
                              "13",
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
                                  "5",
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TriviaStreakCategoryScreen(),
                        ),
                      );
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Row(
            children: [
              Image.asset("assets/red_heart.png"),
              Text("IN 1:22",
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
        Container(
          child: Text(
            "LEADERBOARD",
            style: TextStyle(
                fontSize: unitWidthValue * 18, fontWeight: FontWeight.bold),
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
        Container(
          child: Text(
            "WINNERS",
            style: TextStyle(
                fontSize: unitWidthValue * 18, fontWeight: FontWeight.bold),
          ),
          height: unitHeightValue * 60,
          padding: EdgeInsets.all(unitWidthValue * 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: unitWidthValue * 3),
            borderRadius: BorderRadius.circular(unitWidthValue * 15),
          ),
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
    return Column(
      children: [
        _leaderView("1ST", 100, 19, "R Natanalov"),
        SizedBox(height: 10),
        _leaderView("2ND", 50, 13, "Bvron Linnet"),
        SizedBox(height: 10),
        _leaderView("3RD", 25, 9, "John Dieck"),
      ],
    );
  }
}
