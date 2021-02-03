import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/question_seccess_dialog.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/home/home_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/questions_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/questions_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/submit_quiz_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/submit_quiz_model.dart';

class QuestionsScreen extends StatefulWidget {
  final Quiz quiz;

  QuestionsScreen(this.quiz);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  QuestionsController questionsController = new QuestionsController();

  SubmitQuizController submitQuizController = new SubmitQuizController();

  int currentIndex = 0;

  int _length;

  int correctAnswer = 0;

  int bonus = 0;

  bool _isLoading = true;

  bool _isBomb = false;
  bool _isBombClick = false;
  int count = 0;

  List<Record> record;

  Timer _timer;
  int _start = 16;

  SubmitQuiz submitQuizResponse = new SubmitQuiz();

  @override
  void initState() {
    super.initState();
    questionsController.getQuestionAPI(widget.quiz).then(
      (value) {
        if (value != null) {
          setState(
            () {
              record = value;
              _isLoading = false;
            },
          );
        } else {
          print("++ RECORED IS NULL ++");
        }
      },
    );

    startTimer(widget.quiz);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
              : record.length != 0
                  ? _questionsBodyWidget(record, widget.quiz)
                  : Center(
                      child: Text(
                        "This Quiz Is Not Available Now",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _questionsBodyWidget(List<Record> record, Quiz quiz) {
    Record rec = record[currentIndex];
    _length = record.length;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              sizedBoxAddMob(90.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 65.0,
                    padding: EdgeInsets.only(bottom: 0.0),
                    margin: EdgeInsets.only(bottom: 0.0),
                    decoration: BoxDecoration(
                      color: greenColor,
                      border: Border.all(
                        color: blackColor,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: blackColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: whiteColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      quiz.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                    margin: EdgeInsets.only(right: 0.0, left: 0.0),
                    decoration: BoxDecoration(
                      color: greenColor,
                      border: Border.all(
                        color: blackColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: AutoSizeText(
                      ": $_start",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.only(
                      top: 2.0, bottom: 2.0, right: 9.0, left: 9.0),
                  margin: EdgeInsets.only(right: 0.0, left: 0.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: AutoSizeText(
                    "${currentIndex + 1} / 10",
                    textAlign: TextAlign.center,
                    style: TextStyle(
//                            fontSize: 27.0,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: questions(rec),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _roundedTools(
                      image: "bomb.png",
                      value: spinDetails.theBomb != null
                          ? spinDetails.theBomb
                          : "0",
                      onTap: () {
                        useGadgets(item: "1", count: "-1");
                      }),
                  _roundedTools(
                      image: "player2.png",
                      value: spinDetails.thePlayer != null
                          ? spinDetails.thePlayer
                          : "0",
                      onTap: () {
                        useGadgets(item: "4", count: "-1");
                      }),
                  _roundedTools(
                      image: "clock.png",
                      value: spinDetails.theTime != null
                          ? spinDetails.theTime
                          : "0",
                      onTap: () {
                        useGadgets(item: "3", count: "-1");
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget questions(Record rec) {
    return Column(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 17.0, right: 17.0, top: 17.0, bottom: 17.0),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: blackColor,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: AutoSizeText(
            rec.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 0.0, right: 20.0, left: 20.0),
          child: layoutBuilderDot(greenColor),
        ),
        options(rec),
      ],
    );
  }

  Widget options(Record record) {
    print("Option");
    if (_isBombClick) {
      _isBomb = true;
    }
    return IgnorePointer(
      ignoring: !record.isEnable,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: record.options.length,
        itemBuilder: (context, index) {
          Option _option = record.options[index];
          return Column(
            children: <Widget>[
              InkWell(
                child: _isBomb
                    ? _option.isAnswer == "1"
                        ? Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 8.0),
                            padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 15.0,
                                bottom: 15.0),
                            decoration: BoxDecoration(
                              color:
                                  _option.isAnswer == "1" && _option.isSelected
                                      ? greenColor
                                      : _option.isSelected
                                          ? redColor
                                          : blackColor,
                              border: Border.all(
                                color: whiteColor,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: AutoSizeText(
                              _option.options,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                        : emptyContainer()
                    : Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: _option.isAnswer == "1" && _option.isSelected
                              ? greenColor
                              : _option.isSelected
                                  ? redColor
                                  : blackColor,
                          border: Border.all(
                            color: whiteColor,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: AutoSizeText(
                          _option.options,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                onTap: () {
                  setState(
                    () {
                      record.nextButton = true;
                      record.isEnable = false;
                      record.finalSelectAnswerIsTrue = true;
                      _option.isSelected = true;

                      if (_option.isAnswer == "1") {
                        correctAnswer++;
                        record.points = _start * 100;
                        print(record.points);
                      }
                      if (_start > 3) {
                        nextQuestionTimer(widget.quiz);
                      }
                      for (Option o in record.options) {
                        if (o.isAnswer == "1") {
                          o.isSelected = true;
                          break;
                        }
                      }
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget emptyContainer() {
    count++;
    if (count == 2) {
      _isBomb = false;
      count = 0;
    }
    return new Container();
  }

  Widget _roundedTools({String image, String value, void onTap()}) {
    return InkWell(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 13.0),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: greenColor,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(29.5),
            ),
            child: Image.asset(
              "assets/$image",
              height: 50.0,
              width: 50.0,
            ),
          ),
          Align(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  void nextQuestionTimer(Quiz quiz, {int sec}) {
    Future.delayed(
      Duration(seconds: sec == null ? 3 : sec),
      () {
        if (currentIndex + 1 == _length) {
          setState(() {
            _timer.cancel();
            _isLoading = true;
          });
          getBonus();
          submitQuiz().then(
            (value) {
              getBonus();
              AdMobClass.showVideoAdd(
                isSpin: false,
                isInterstitial: false,
                afterVideoEnd: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => QuestionSuccessDialog(
                      quiz: quiz,
                      correctAnswer: correctAnswer,
                      submitQuiz: submitQuizResponse,
                    ),
                  ).then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                },
              );
            },
          );
        } else {
          setState(
            () {
              currentIndex++;
              _isBomb = false;
              _isBombClick = false;
              _start = 15;
            },
          );
        }
      },
    );
  }

  void startTimer(Quiz quiz, {int time}) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            _start = 15;
            if (currentIndex + 1 == _length) {
              setState(() {
                _isLoading = true;
              });
              submitQuiz().then(
                (value) {
                  getBonus();
                  AdMobClass.showVideoAdd(
                    isSpin: false,
                    isInterstitial: false,
                    afterVideoEnd: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                          (route) => false);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            QuestionSuccessDialog(
                          quiz: quiz,
                          correctAnswer: correctAnswer,
                          submitQuiz: submitQuizResponse,
                        ),
                      ).then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    },
                  );
                },
              );
            } else {
              setState(
                () {
                  currentIndex++;
                },
              );
            }
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void getBonus() {
    if (correctAnswer == 5) {
      bonus = 300;
    } else if (correctAnswer == 6) {
      bonus = 450;
    } else if (correctAnswer == 7) {
      bonus = 600;
    } else if (correctAnswer == 8) {
      bonus = 750;
    } else if (correctAnswer == 9) {
      bonus = 900;
    } else if (correctAnswer == 10) {
      bonus = 1200;
    }
    print("TOTAL BONUS : $bonus");
  }

  Future<void> submitQuiz() async {
    FocusScope.of(context).requestFocus(
      new FocusNode(),
    );

    SubmitQuiz quiz =
        await submitQuizController.submitQuiz(record, widget.quiz, bonus);
    setState(
      () {
        submitQuizResponse = quiz;
      },
    );
  }

  Future<void> useGadgets({String item, String count}) async {
    if (item == "1" && spinDetails.theBomb == "0") {
      Common.showErrorToastMsg("No More Bomb");
      return;
    } else if (item == "4" && spinDetails.thePlayer == "0") {
      Common.showErrorToastMsg("No More Player");
      return;
    } else if (item == "3" && spinDetails.theTime == "0") {
      Common.showErrorToastMsg("No More Time");
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      await questionsController.submitQuestionGadgets(item: item, count: count);
      setState(() {
        _isLoading = false;
      });
      if (item == "1") {
        setState(() {
          _isBomb = true;
          _isBombClick = true;
        });
      } else if (item == "4") {
        if (_start > 3) {
          nextQuestionTimer(widget.quiz, sec: 1);
        }
      } else if (item == "3") {
        setState(() {
          _start = _start + 12;
        });
      }
    }
  }
}
