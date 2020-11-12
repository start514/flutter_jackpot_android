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
  final Quiz quiz;
  final int correctAnswer;
  final SubmitQuiz submitQuiz;

  QuestionSuccessDialog({this.quiz, this.correctAnswer, this.submitQuiz});

  @override
  _QuestionSuccessDialogState createState() => _QuestionSuccessDialogState();
}

class _QuestionSuccessDialogState extends State<QuestionSuccessDialog> {
  SubmitQuiz quizResponse = new SubmitQuiz();
  int score = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      quizResponse = widget.submitQuiz;
      score =
          int.parse(quizResponse.quizScore) + int.parse(quizResponse.quizBonus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 502.0,
        margin: EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: whiteColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    widget.quiz.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 10.0,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Congratulations!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27.0,
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Quiz Completed.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19.0,
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        child: layoutBuilderDot(blackColor),
                      ),
                      Text(
                        "Watch this short ad while we calculate your result",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: greenColor,
                    border: Border.all(
                      color: blackColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    //score
                    "Score - ${score.toString()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: whiteColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _scoreBordRow(
                          name: "Correct Answers",
                          value: widget.correctAnswer != 0
                              ? "${widget.correctAnswer} out of 10"
                              : "0 out of 10",
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        _scoreBordRow(
                          name: "Quiz Score",
                          value: quizResponse.quizScore != null
                              ? quizResponse.quizScore
                              : "0",
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        _scoreBordRow(
                          name: "Quiz Bonus",
                          value: quizResponse.quizBonus != null
                              ? "+${quizResponse.quizBonus}"
                              : "0",
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        _scoreBordRow(
                          name: "My Quiz Rank",
                          value: quizResponse.rank != null
                              ? quizResponse.rank
                              : "0",
                        ),
                        Row(
                          children: <Widget>[],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _roundedButtons(
                              title: "Done",
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
                              title: "Play Again!",
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JackpotTriviaDetailsScreen(
                                      quiz: widget.quiz,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreBordRow({String name, String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AutoSizeText(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greenColor,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        Container(
          width: 85.0,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: greenColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(29.5),
          ),
          child: AutoSizeText(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _roundedButtons({String title, Color color, void onTap()}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: color != null ? color : whiteColor,
          border: Border.all(
            color: greenColor,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                child: AutoSizeText(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
