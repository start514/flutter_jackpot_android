import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_triva_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/submit_quiz_model.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_category_screen.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_screen.dart';

class StreakSuccessDialog extends StatefulWidget {
  final int? score;
  final int? originalScore;
  final int? rank;

  StreakSuccessDialog({this.score, this.rank, this.originalScore});

  @override
  _StreakSuccessDialogState createState() => _StreakSuccessDialogState();
}

class _StreakSuccessDialogState extends State<StreakSuccessDialog> {
  double unitHeightValue = 1;
  double unitWidthValue = 1;
  late bool isFailed;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFailed = widget.score == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        height: unitHeightValue * double.infinity,
        width: unitWidthValue * double.infinity,
        margin: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: unitHeightValue * 42,
                ),
                Stack(
                  children: [
                    isFailed
                        ? Container()
                        : Align(
                            child: Container(
                              child: AutoSizeText(
                                "RANKING - ${widget.rank}",
                                style: TextStyle(
                                  fontSize: unitWidthValue * 40,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              width: unitWidthValue * 280,
                              height: unitHeightValue * 70,
                              margin:
                                  EdgeInsets.only(top: unitHeightValue * 400),
                              padding: EdgeInsets.fromLTRB(
                                unitWidthValue * 10,
                                unitWidthValue * 10,
                                unitWidthValue * 10,
                                0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: greenColor,
                                    width: unitWidthValue * 4),
                                borderRadius:
                                    BorderRadius.circular(unitWidthValue * 12),
                              ),
                            ),
                          ),
                    Container(
                      // width: unitWidthValue * double.infinity,
                      padding: EdgeInsets.fromLTRB(
                          0, unitHeightValue * 8.0, 0, unitWidthValue * 8.0),
                      decoration: BoxDecoration(
                        color: blackColor,
                        border: Border.all(
                          color: Colors.white,
                          width: unitWidthValue * 3,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isFailed ? "WRONG ANSWER" : "CORRECT ANSWER!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: unitHeightValue * 50.0,
                                color: isFailed ? Colors.red : greenColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: unitHeightValue * 10),
                          Container(
                            height: unitHeightValue * 3,
                            color: Colors.white,
                          ),
                          SizedBox(height: unitHeightValue * 20),
                          Text(
                            isFailed
                                ? "YOUR STREAK IS OVER"
                                : "YOUR STREAK IS NOW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: unitHeightValue * 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: unitHeightValue * 10),
                          Container(
                            child: AutoSizeText(
                              "${widget.score}",
                              style: TextStyle(
                                color: isFailed ? Colors.red : greenColor,
                                fontSize: unitWidthValue * 80,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isFailed ? Colors.red : greenColor,
                                width: unitWidthValue * 3,
                              ),
                              borderRadius:
                                  BorderRadius.circular(unitWidthValue * 12),
                            ),
                            padding: EdgeInsets.all(unitWidthValue * 10),
                            width: unitWidthValue * 120,
                            height: unitWidthValue * 120,
                          ),
                          SizedBox(height: unitHeightValue * 20),
                          Container(
                            padding: EdgeInsets.only(left: 18, right: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _roundedButtons(
                                  title: "HOME",
                                  color: Colors.black,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TriviaStreakScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _roundedButtons(
                                  title: isFailed ? "RESTART" : "CONTINUE",
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TriviaStreakCategoryScreen(
                                          score: widget.originalScore,
                                          // quiz: widget.quiz,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                isFailed
                    ? Container(
                        child: Stack(
                          children: [
                            Align(
                              child: Container(
                                child: AutoSizeText(
                                  "ERASES THE WRONG ANSWER AND CONTINUES YOUR STREAK!",
                                  style: TextStyle(
                                    fontSize: unitWidthValue * 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                width: unitWidthValue * 420,
                                height: unitHeightValue * 100,
                                padding: EdgeInsets.fromLTRB(
                                  unitWidthValue * 5,
                                  unitWidthValue * 10,
                                  unitWidthValue * 5,
                                  0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: greenColor,
                                      width: unitWidthValue * 4),
                                  borderRadius: BorderRadius.circular(
                                      unitWidthValue * 12),
                                ),
                              ),
                            ),
                            Align(
                              child: Container(
                                child: AutoSizeText(
                                  "~ CONTINUE YOUR STREAK ~",
                                  style: TextStyle(
                                    fontSize: unitWidthValue * 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                width: unitWidthValue * 350,
                                height: unitHeightValue * 50,
                                padding: EdgeInsets.fromLTRB(
                                  unitWidthValue * 5,
                                  unitWidthValue * 5,
                                  unitWidthValue * 5,
                                  0,
                                ),
                                decoration: BoxDecoration(
                                  color: greenColor,
                                  border: Border.all(
                                      color: Colors.black,
                                      width: unitWidthValue * 3),
                                  borderRadius: BorderRadius.circular(
                                      unitWidthValue * 12),
                                ),
                                transform: Matrix4.translationValues(
                                    0, -unitHeightValue * 40, 0),
                              ),
                            ),
                            Align(
                              child: Container(
                                child: AutoSizeText(
                                  "ONLY \$0.99 CENTS",
                                  style: TextStyle(
                                    fontSize: unitWidthValue * 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                width: unitWidthValue * 250,
                                height: unitHeightValue * 50,
                                padding: EdgeInsets.fromLTRB(
                                  unitWidthValue * 5,
                                  unitWidthValue * 5,
                                  unitWidthValue * 5,
                                  0,
                                ),
                                decoration: BoxDecoration(
                                  color: greenColor,
                                  border: Border.all(
                                      color: Colors.black,
                                      width: unitWidthValue * 3),
                                  borderRadius: BorderRadius.circular(
                                      unitWidthValue * 12),
                                ),
                                transform: Matrix4.translationValues(
                                    0, unitHeightValue * 90, 0),
                              ),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.fromLTRB(
                            0,
                            isFailed
                                ? unitHeightValue * 60
                                : unitHeightValue * 30,
                            0,
                            unitHeightValue * 70),
                      )
                    : Container(),
                Container(
                  child: Column(
                    children: [
                      Align(
                        child: Container(
                          child: AutoSizeText(
                            "ENJOY OUR AD FREE VERSION!",
                            style: TextStyle(
                              fontSize: unitWidthValue * 40,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          width: unitWidthValue * 400,
                          height: unitHeightValue * 70,
                          padding: EdgeInsets.fromLTRB(
                            unitWidthValue * 5,
                            unitWidthValue * 10,
                            unitWidthValue * 5,
                            0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: greenColor, width: unitWidthValue * 4),
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 12),
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                          child: AutoSizeText(
                            "ONLY \$3.99 A MONTH!!!",
                            style: TextStyle(
                              fontSize: unitWidthValue * 40,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          width: unitWidthValue * 350,
                          height: unitHeightValue * 70,
                          padding: EdgeInsets.fromLTRB(
                            unitWidthValue * 5,
                            unitWidthValue * 10,
                            unitWidthValue * 5,
                            0,
                          ),
                          decoration: BoxDecoration(
                            color: greenColor,
                            border: Border.all(
                                color: Colors.black, width: unitWidthValue * 3),
                            borderRadius:
                                BorderRadius.circular(unitWidthValue * 12),
                          ),
                          transform: Matrix4.translationValues(
                              0, -unitHeightValue * 10, 0),
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(0, unitHeightValue * 30, 0, 0),
                ),
                isFailed
                    ? Container()
                    : Container(
                        child: Column(
                          children: [
                            Text(
                              "CAN YOU WIN THE CASH?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: unitWidthValue * 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              "assets/money.png",
                              width: unitWidthValue * 350,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(top: unitHeightValue * 20),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundedButtons({required String title, Color? color, void onTap()?}) {
    return InkWell(
      child: Container(
        width: unitWidthValue * 180,
        height: unitHeightValue * 80,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: color != null ? color : greenColor,
          border: Border.all(
            color: whiteColor,
            width: unitWidthValue * 3,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          child: AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color != null ? Colors.white : blackColor,
              fontSize: unitHeightValue * 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
