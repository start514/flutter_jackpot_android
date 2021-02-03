import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/leaderbord/leaderbord_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/leaderbord/leaderbored_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/questions_screen.dart';

class JackpotTriviaDetailsScreen extends StatefulWidget {
  final Quiz quiz;

  JackpotTriviaDetailsScreen({this.quiz});

  @override
  _JackpotTriviaState createState() => _JackpotTriviaState();
}

class _JackpotTriviaState extends State<JackpotTriviaDetailsScreen> {
  GetLeaderBordController getLeaderBordController =
      new GetLeaderBordController();

  List<LeaderBordRecord> lbList = new List();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLeaderBord(widget.quiz);
  }

  @override
  Widget build(BuildContext context) {
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
              : _bodyWidget(widget.quiz),
        ),
      ],
    );
  }

  Widget _bodyWidget(Quiz quiz) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              sizedBoxAddMob(85.0),
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: blackColor,
                  border: Border.all(
                    color: greenColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(29.5),
                ),
                child: Text(
                  "Jackpot Trivia",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 130.0,
                        width: 130.0,
                        margin: EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27.0),
                          border: Border.all(
                            color: blackColor,
                            width: 2.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                                UrlQuizImageJackpotTriviaPrefixUrl +
                                    quiz.photoThumb),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 110.0,
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(
                              color: blackColor,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: AutoSizeText(
                            quiz.title ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 115.0, left: 10.0),
                          child: Container(
                            width: 110.0,
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
                              "\$ ${quiz.amount}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(29.5),
                        ),
                        child: Text(
                          "Ends ${quiz.end_date}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      InkWell(
                        child: Container(
                          height: 92.0,
                          width: 92.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: greenColor,
                            border: Border.all(
                              color: blackColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Text(
                            "Play \n Now!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          _playNowButtonTap(quiz);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 17.0, horizontal: 15.0),
                child: layoutBuilderDot(whiteColor),
              ),
              _leaderBoard(),
            ],
          ),
        ),
      ),
    );
  }

  void _playNowButtonTap(Quiz quiz) {
    setState(() {
      _isLoading = true;
    });
    AdMobClass.showVideoAdd(
      isSpin: false,
      isInterstitial: true,
      afterVideoEnd: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionsScreen(quiz),
          ),
        ).then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      },
    );
  }

  Widget _leaderBoard() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: blackColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        "assets/winner_cup.png",
                        height: 30.0,
                        width: 30.0,
                        color: blackColor,
                      ),
                      Text(
                        " Leaderboard ",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        "assets/winner_cup.png",
                        height: 30.0,
                        width: 30.0,
                        color: blackColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: lbList
                        .map<TableRow>(
                          (element) => TableRow(
                            decoration: BoxDecoration(
                              color: element.color,
                            ),
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5.0),
                                  child: Text(
                                    element.rank.toString(),
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5.0),
                                  child: Text(
                                    element.userDetail.name ?? "",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5.0),
                                  child: Text(
                                    element.score ?? "0",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getLeaderBord(Quiz quiz) {
    getLeaderBordController.getLeaderBordAPI(quiz).then(
      (value) {
        if (value != null) {
          setState(() {
            lbList = value;
            for (int i = 0; i < lbList.length; i++) {
              lbList[i].rank = i + 1;
              LeaderBordRecord leaderBoard = lbList[i];
              if (i == 0) {
                leaderBoard.color = greenColor;
              } else {
                if (i % 2 == 0) {
                  leaderBoard.color = whiteColor;
                } else {
                  leaderBoard.color = lbGreyColor;
                }
              }
            }
            _isLoading = false;
          });
        }
      },
    );
  }
}
