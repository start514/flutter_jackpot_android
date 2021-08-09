import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/question_seccess_dialog.dart';
import 'package:flutterjackpot/dialogs/streak_success_dialog.dart';
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
import 'package:flutterjackpot/view/trivia_streak/submit_streak_model.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_controller.dart';

class QuestionsScreen extends StatefulWidget {
  final Quiz quiz;
  final bool isStreak;
  final int? originalScore;

  QuestionsScreen(this.quiz, this.isStreak, this.originalScore);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  QuestionsController questionsController = new QuestionsController();

  SubmitQuizController submitQuizController = new SubmitQuizController();
  TriviaStreakController triviaStreakController = new TriviaStreakController();

  int currentIndex = 0;

  int? _length;

  int correctAnswer = 0;

  int bonus = 0;

  bool _isLoading = true;

  bool _isBomb = false;
  bool _isBombClick = false;
  int count = 0;

  late List<Record> record;

  late Timer _timer;
  int _start = 16;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  SubmitQuiz? submitQuizResponse = new SubmitQuiz();

  SubmitStreakResponse? submitStreakResponse = new SubmitStreakResponse();

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
              : record.length != 0
                  ? _questionsBodyWidget(record, widget.quiz)
                  : Center(
                      child: Text(
                        "This Quiz Is Not Available Now",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: unitHeightValue * 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _questionsBodyWidget(List<Record> record, Quiz quiz) {
    Record rec = record[currentIndex];
    _length = widget.isStreak ? 1 : record.length;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
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
                        borderRadius: BorderRadius.circular(
                            unitHeightValue * unitHeightValue * 29.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: unitWidthValue * 10,
                  ),
                  Expanded(
                      child: Container(
                    // width: unitWidthValue * double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        unitWidthValue * 8.0,
                        unitHeightValue * 2.0,
                        unitWidthValue * 8.0,
                        unitHeightValue * 2.0),
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
                      quiz.title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: unitHeightValue * 32.0,
                          color: whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: unitHeightValue * 10.0),
                child: questions(rec),
              ),
              SizedBox(
                height: unitHeightValue * 20.0,
              ),
              widget.isStreak
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _roundedTools(
                            image: "bomb.png",
                            value: spinDetails!.theBomb != null
                                ? spinDetails!.theBomb!
                                : "0",
                            onTap: () {
                              useGadgets(item: "1", count: "-1");
                            }),
                        _roundedTools(
                            image: "player2.png",
                            value: spinDetails!.thePlayer != null
                                ? spinDetails!.thePlayer!
                                : "0",
                            onTap: () {
                              useGadgets(item: "4", count: "-1");
                            }),
                        _roundedTools(
                            image: "clock.png",
                            value: spinDetails!.theTime != null
                                ? spinDetails!.theTime!
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
        SizedBox(
          height: unitHeightValue * 20.0,
        ),
        Stack(
          children: [
            widget.isStreak
                ? Container()
                : Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: unitHeightValue * 1.0,
                          bottom: unitHeightValue * 1.0,
                          right: unitWidthValue * 9.0,
                          left: unitWidthValue * 9.0),
                      margin: EdgeInsets.only(
                          right: unitWidthValue * 30,
                          top: unitHeightValue * 20),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: greenColor,
                          width: unitWidthValue * 2,
                        ),
                        borderRadius:
                            BorderRadius.circular(unitHeightValue * 8.0),
                      ),
                      child: AutoSizeText(
                        "${currentIndex + 1} / $_length",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: unitHeightValue * 26.0,
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(1000),
                    topRight: Radius.circular(1000),
                  ),
                  border: Border.all(
                    color: blackColor,
                    width: unitWidthValue * 4,
                  ),
                  color: greenColor,
                ),
                width: unitWidthValue * 160,
                height: unitHeightValue * 80,
              ),
            ]),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(
                    top: unitHeightValue * 1.0,
                    bottom: unitHeightValue * 1.0,
                    right: unitWidthValue * 9.0,
                    left: unitWidthValue * 9.0),
                margin: EdgeInsets.only(top: unitHeightValue * 12),
                child: AutoSizeText(
                  "$_start",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: unitHeightValue * 36.0,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: unitWidthValue * double.infinity,
              padding: EdgeInsets.only(
                  left: unitWidthValue * 17.0,
                  right: unitWidthValue * 17.0,
                  top: unitHeightValue * 30.0,
                  bottom: unitHeightValue * 30.0),
              margin: EdgeInsets.only(top: unitHeightValue * 60),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 4,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
              ),
              child: AutoSizeText(
                rec.question!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: unitHeightValue * 22,
                  color: blackColor,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              top: unitHeightValue * 20.0,
              bottom: unitHeightValue * 0.0,
              right: unitWidthValue * 20.0,
              left: unitWidthValue * 20.0),
          // child: layoutBuilderDot(greenColor),
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
        itemCount: record.options!.length,
        itemBuilder: (context, index) {
          Option _option = record.options![index];
          return Column(
            children: <Widget>[
              InkWell(
                child: _isBomb
                    ? _option.isAnswer == "1"
                        ? Container(
                            width: unitWidthValue * double.infinity,
                            margin: EdgeInsets.only(
                                bottom: unitHeightValue * 10.0,
                                top: unitHeightValue * 10.0),
                            padding: EdgeInsets.only(
                                left: unitWidthValue * 10.0,
                                right: unitWidthValue * 10.0,
                                top: unitHeightValue * 15.0,
                                bottom: unitHeightValue * 15.0),
                            decoration: BoxDecoration(
                              color:
                                  _option.isAnswer == "1" && _option.isSelected
                                      ? greenColor
                                      : _option.isSelected
                                          ? redColor
                                          : blackColor,
                              border: Border.all(
                                color: whiteColor,
                                width: unitWidthValue * 2.5,
                              ),
                              borderRadius:
                                  BorderRadius.circular(unitHeightValue * 15.0),
                            ),
                            child: AutoSizeText(
                              _option.options!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: unitHeightValue * 22,
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                        : emptyContainer()
                    : Container(
                        width: unitWidthValue * double.infinity,
                        margin: EdgeInsets.only(
                            bottom: unitHeightValue * 10.0,
                            top: unitHeightValue * 10.0),
                        padding: EdgeInsets.only(
                            left: unitWidthValue * 10.0,
                            right: unitWidthValue * 10.0,
                            top: unitHeightValue * 15.0,
                            bottom: unitHeightValue * 15.0),
                        decoration: BoxDecoration(
                          color: _option.isAnswer == "1" && _option.isSelected
                              ? greenColor
                              : _option.isSelected
                                  ? redColor
                                  : blackColor,
                          border: Border.all(
                            color: whiteColor,
                            width: unitWidthValue * 2.5,
                          ),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 15.0),
                        ),
                        child: AutoSizeText(
                          _option.options!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: unitHeightValue * 22,
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
                        assetsAudioPlayer.open(
                          Audio("assets/audios/correct_answer_trivia.m4a"),
                          autoStart: true,
                          showNotification: false,
                        );
                        correctAnswer++;
                        record.points = _start * 100;
                        print(record.points);
                      } else {
                        assetsAudioPlayer.open(
                          Audio("assets/audios/wrong_answer_trivia.m4a"),
                          autoStart: true,
                          showNotification: false,
                        );
                      }
                      if (_start > 3) {
                        nextQuestionTimer(widget.quiz);
                      }
                      for (Option o in record.options!) {
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

  Widget _roundedTools({String? image, required String value, void onTap()?}) {
    return InkWell(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.only(
                left: unitWidthValue * 12.0,
                right: unitWidthValue * 12,
                top: unitHeightValue * 12,
                bottom: unitHeightValue * 12),
            margin: EdgeInsets.only(
                bottom: unitHeightValue * 13.0,
                right: unitWidthValue * 12,
                left: unitWidthValue * 12),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: greenColor,
                width: unitWidthValue * 3.0,
              ),
              borderRadius: BorderRadius.circular(unitHeightValue * 8),
            ),
            child: Image.asset(
              "assets/$image",
              height: unitHeightValue * 60.0,
              width: unitWidthValue * 60.0,
            ),
          ),
          Align(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: unitWidthValue * 20),
              // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              width: unitWidthValue * 40,
              height: unitHeightValue * 40,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 2.0,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 50.0),
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: unitHeightValue * 20),
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  void nextQuestionTimer(Quiz quiz, {int? sec}) {
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
              if (widget.isStreak) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (route) => false);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => StreakSuccessDialog(
                    result: submitStreakResponse,
                  ),
                ).then((value) {
                  setState(() {
                    _isLoading = false;
                  });
                });
              } else {
                getBonus();
                AdMobClass.showRewardAdd(
                  isSpin: false,
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
              }
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

  void startTimer(Quiz quiz, {int? time}) {
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
                  if (widget.isStreak) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                        (route) => false);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => StreakSuccessDialog(
                        result: submitStreakResponse,
                      ),
                    ).then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  } else {
                    getBonus();
                    AdMobClass.showRewardAdd(
                      isSpin: false,
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
                  }
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

    if (widget.isStreak) {
      SubmitStreakResponse? streakResponse = await triviaStreakController
          .submitStreak(userID: userRecord!.userID, score: correctAnswer);
      submitStreakResponse = streakResponse;
    } else {
      SubmitQuiz? quiz =
          await submitQuizController.submitQuiz(record, widget.quiz, bonus);
      submitQuizResponse = quiz;
    }
  }

  Future<void> useGadgets({String? item, String? count}) async {
    Record rec = record[currentIndex];

    if (item == "1" && spinDetails!.theBomb == "0") {
      Common.showErrorToastMsg("No More Bomb");
      return;
    } else if (item == "4" && spinDetails!.thePlayer == "0") {
      Common.showErrorToastMsg("No More Player");
      return;
    } else if (item == "3" && spinDetails!.theTime == "0") {
      Common.showErrorToastMsg("No More Time");
      return;
    } else {
      setState(() {
        _isLoading = false;
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
        bool isEnable = rec.isEnable;
        print("isEnable$isEnable");
        if (_start > 3 && rec.isEnable == true) {
          rec.nextButton = true;
          rec.isEnable = false;
          rec.finalSelectAnswerIsTrue = true;
          correctAnswer++;
          rec.points = 1000;
          isEnable = rec.isEnable;
          assetsAudioPlayer.open(
            Audio("assets/audios/correct answer-trivia.m4a"),
            autoStart: true,
            showNotification: false,
          );
          for (Option o in rec.options!) {
            if (o.isAnswer == "1") {
              o.isSelected = true;
              break;
            }
          }
          if (_start > 3) {
            nextQuestionTimer(widget.quiz);
          }
          setState(
            () {},
          );
        }
      } else if (item == "3") {
        setState(() {
          _start = 15;
        });
      }
    }
  }
}
