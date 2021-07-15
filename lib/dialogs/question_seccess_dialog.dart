import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_triva_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/submit_quiz_model.dart';

class QuestionSuccessDialog extends StatefulWidget {
  final Quiz? quiz;
  final int? correctAnswer;
  final SubmitQuiz? submitQuiz;

  QuestionSuccessDialog({this.quiz, this.correctAnswer, this.submitQuiz});

  @override
  _QuestionSuccessDialogState createState() => _QuestionSuccessDialogState();
}

class _QuestionSuccessDialogState extends State<QuestionSuccessDialog> {
  SubmitQuiz? quizResponse = new SubmitQuiz();
  int score = 0;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();

    setState(() {
      quizResponse = widget.submitQuiz;
      score = int.parse(quizResponse!.quizScore!) +
          int.parse(quizResponse!.quizBonus!);
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
                Container(
                  // width: unitWidthValue * double.infinity,
                  padding: EdgeInsets.fromLTRB(unitWidthValue * 32.0, unitHeightValue * 8.0, unitHeightValue * 32.0, unitWidthValue *8.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: greenColor,
                      width: unitWidthValue * 2,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    "QUIZ RESULTS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: unitHeightValue * 32.0,
                        color: greenColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    widget.quiz!.title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: unitHeightValue * 60.0,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 10.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: whiteColor,
                      width: unitWidthValue * 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    //score
                    "SCORE - ${score.toString()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: unitHeightValue * 40.0,
                      color: greenColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _scoreBordRow(
                              name: "QUIZ RANK",
                              value: quizResponse!.rank != null
                                  ? quizResponse!.rank!
                                  : "0",
                            ),
                            _scoreBordRow(
                              name: "CORRECT",
                              value: widget.correctAnswer != 0
                                  ? "${widget.correctAnswer}/10"
                                  : "0/10",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: unitHeightValue * 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _scoreBordRow(
                              name: "QUIZ SCORE",
                              value: quizResponse!.quizScore != null
                                  ? quizResponse!.quizScore!
                                  : "0",
                            ),
                            _scoreBordRow(
                              name: "QUIZ BONUS",
                              value: quizResponse!.quizBonus != null
                                  ? "+${quizResponse!.quizBonus}"
                                  : "0",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _roundedButtons(
                        title: "DONE!",
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JackPotTriviaScreen(),
                            ),
                          );
                        },
                      ),
                      _roundedButtons(
                        title: "PLAY AGAIN!",
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JackpotTriviaDetailsScreen(
                                quiz: widget.quiz,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    //score
                    "Try using some Power-ups to increase\nyour chances of winning a Jackpot!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: unitHeightValue * 22.0,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreBordRow({required String name, required String value}) {
    return Container(
        width: unitWidthValue * 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AutoSizeText(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: whiteColor, fontWeight: FontWeight.bold, fontSize: unitHeightValue * 30),
            ),
            Container(
              width: unitWidthValue * 180.0,
              height: unitHeightValue * 120,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: blackColor,
                border: Border.all(
                  color: whiteColor,
                  width: unitWidthValue * 1.5,
                ),
                borderRadius: BorderRadius.circular(29.5),
              ),
              child: AutoSizeText(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: greenColor,
                  fontSize: unitHeightValue * 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
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
            width: unitWidthValue * 2,
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
              color: blackColor,
              fontSize: unitHeightValue * (title == "DONE!" ? 32 : 26.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
