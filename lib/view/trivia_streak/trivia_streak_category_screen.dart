import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/get_categories_dialogs.dart';
import 'package:flutterjackpot/dialogs/game_rules_dialogs.dart';
import 'package:flutterjackpot/dialogs/streak_rules_dialogs.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_triva_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/questions_screen.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

const int CATEGORY_RESET_DURATION = 120;

class TriviaStreakCategoryScreen extends StatefulWidget {
  final int? score;
  TriviaStreakCategoryScreen({this.score});
  @override
  _TriviaStreakCategoryScreenState createState() =>
      _TriviaStreakCategoryScreenState();
}

class _TriviaStreakCategoryScreenState
    extends State<TriviaStreakCategoryScreen> {
  JackpotCategoriesAndQuizController jackpotCategoriesController =
      new JackpotCategoriesAndQuizController();

  final searchController = new TextEditingController();

  List<Categories>? categories;
  List<Quiz>? quiz;
  List<int> categoryIndices = List.empty(growable: true);
  DateTime? categoryTime;

  String? searchWord;
  bool isSearch = false;

  bool _isLoading = false;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  late Timer _timer;
  bool _playVideo = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  Quiz? selectedQuiz;

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(milliseconds: 500), (timer) {
      loadCategoryIndices();
      setState(() {
      });
    });
    getQuiz();
    _controller = VideoPlayerController.asset(
      'assets/videos/count.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);
    _controller.seekTo(Duration());
    _initializeVideoPlayerFuture.then((value) {
      _controller.removeListener(onCountDownEnd);
      _controller.addListener(onCountDownEnd);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
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
        _playVideo
            ? Align(
                alignment: Alignment.center,
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the video.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            : Container()
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                StreakRulesDialog(),
                          );
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
              SizedBox(height: 10),
              _categoryResetTimerView(),
              _gridView(),
              SizedBox(height: 10),
              _reshuffleView(),
              SizedBox(height: 10),
              _unlock30DaysView(),
              SizedBox(height: 10),
              _noAdsView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reshuffleView() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text(
              "RE-SHUFFLE (WATCH AD)\n(3 REMAINING TODAY)",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greenColor, width: unitWidthValue * 3),
              borderRadius: BorderRadius.circular(unitWidthValue * 10),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: unitWidthValue * 10, vertical: unitHeightValue * 4),
          ),
          Container(
            child: Text(
              "RE-SHUFFLE\n(.99 CENTS)",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greenColor, width: unitWidthValue * 3),
              borderRadius: BorderRadius.circular(unitWidthValue * 10),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: unitWidthValue * 10, vertical: unitHeightValue * 4),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      width: unitWidthValue * 420,
    );
  }

  Widget _unlock30DaysView() {
    return Stack(
      children: [
        Align(
          child: Container(
            child: Text(
              "DOUBLE YOUR CHANCES!!!\nUNLOCK ALL THREE EXTRA CATEGORIES\nFOR THE NEXT 30 DAYS !!!",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greenColor, width: unitWidthValue * 3),
              borderRadius: BorderRadius.circular(unitWidthValue * 10),
              color: Colors.white,
            ),
            width: unitWidthValue * 420,
            height: unitHeightValue * 120,
          ),
        ),
        Align(
          child: Container(
            child: Text(
              "BUY NOW FOR ONLY \$9.99!",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              color: greenColor,
              border: Border.all(
                color: Colors.black,
                width: unitWidthValue * 3,
              ),
              borderRadius: BorderRadius.circular(unitWidthValue * 10),
            ),
            margin: EdgeInsets.only(top: unitHeightValue * 95),
            padding: EdgeInsets.symmetric(horizontal: unitWidthValue * 10),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ],
    );
  }

  Widget _noAdsView() {
    return Stack(
      children: [
        Align(
          child: Container(
            child: Text(
              "ENJOY OUR AD FREE VERSION!",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * 27,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greenColor, width: unitWidthValue * 3),
              borderRadius: BorderRadius.circular(unitWidthValue * 10),
              color: Colors.white,
            ),
            width: unitWidthValue * 420,
            height: unitHeightValue * 70,
          ),
        ),
        Align(
          child: Container(
            child: Text(
              "ONLY \$3.99 A MONTH!!!",
              style: TextStyle(
                color: Colors.black,
                fontSize: unitWidthValue * 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              color: greenColor,
              border: Border.all(
                color: Colors.black,
                width: unitWidthValue * 3,
              ),
              borderRadius: BorderRadius.circular(unitWidthValue * 10),
            ),
            margin: EdgeInsets.only(top: unitHeightValue * 45),
            padding: EdgeInsets.symmetric(horizontal: unitWidthValue * 10),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ],
    );
  }

  Widget _titleView() {
    return Text(
      "CHOOSE A CATEGORY!",
      style: TextStyle(
        color: Colors.white,
        fontSize: unitWidthValue * 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _categoryResetTimerView() {
    Duration diff = DateTime.now().difference(categoryTime ?? DateTime.now());
    int remain = CATEGORY_RESET_DURATION - diff.inSeconds;
    int min = (remain / 60).floor();
    int sec = remain % 60;
    String timer =
        DateFormat("mm:ss").format(new DateTime(2000, 1, 1, 0, min, sec));
    return Row(
      children: [
        Container(
            height: unitHeightValue * 3,
            width: unitWidthValue * 80,
            color: Colors.white),
        Container(
          child: Text(
            "CATEGORIES RESET IN $timer",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: unitHeightValue * 20),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(unitWidthValue * 15),
            border: Border.all(color: Colors.white, width: unitWidthValue * 2),
            color: greenColor,
          ),
          padding: EdgeInsets.fromLTRB(unitWidthValue * 15, unitWidthValue * 5,
              unitWidthValue * 15, unitWidthValue * 5),
          width: unitWidthValue * 270,
        ),
        Container(
            height: unitHeightValue * 3,
            width: unitWidthValue * 80,
            color: Colors.white),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _gridView() {
    if (categoryIndices.length < 6) return Container();
    if (quiz == null) return Container();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 3),
      itemCount: 6,
      itemBuilder: (BuildContext context, int position) {
        Quiz _quiz = quiz![categoryIndices[position]];
        return Container(
          padding: EdgeInsets.all(unitHeightValue * 5.0),
          child: InkWell(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0.0),
                  margin:
                      EdgeInsets.symmetric(vertical: unitHeightValue * 10.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: unitWidthValue * 1.5,
                    ),
                    borderRadius: BorderRadius.circular(unitHeightValue * 29.5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(unitHeightValue * 16.0),
                      border: Border.all(
                        color: whiteColor,
                        width: unitWidthValue * 1.5,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          UrlQuizImageJackpotTriviaPrefixUrl +
                              _quiz.photoThumb!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                position > 2
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/lock.png",
                                width: unitWidthValue * 100,
                              ),
                              Container(
                                child: Text(
                                  "\$0.99",
                                  style: TextStyle(
                                    color: greenColor,
                                    fontSize: unitWidthValue * 20,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      unitWidthValue * 10),
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: unitWidthValue * 5),
                                transform: Matrix4.translationValues(
                                    0.0, -5.0 * unitWidthValue, 0.0),
                              )
                            ],
                            alignment: Alignment.center,
                          ),
                          transform: Matrix4.translationValues(
                              -15.0 * unitWidthValue, 0.0, 0.0),
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: unitWidthValue * double.infinity,
                    padding: EdgeInsets.all(unitHeightValue * 2),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: Colors.white,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(unitHeightValue * 20),
                    ),
                    child: AutoSizeText(
                      _quiz.title!.toUpperCase(),
                      textAlign: TextAlign.center,
                      minFontSize: 8,
                      maxLines: 1,
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: unitHeightValue * 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              _controller.play();
              setState(() {
                _isLoading = true;
                _playVideo = true;
                selectedQuiz = _quiz;
              });
            },
          ),
        );
      },
    );
  }

  void getQuiz({categoryID}) {
    setState(() {
      _isLoading = true;
    });
    jackpotCategoriesController.getQuiz(categoryID: categoryID).then(
      (value) {
        quiz = value;
        loadCategoryIndices();
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  void loadCategoryIndices() {
    Preferences.getString(Preferences.pfKStreakCategories).then((value) {
      Preferences.getString(Preferences.pfKStreakCategoriesTime)
          .then((timevalue) {
        if (timevalue != null && timevalue != "") {
          categoryTime = DateTime.parse(timevalue);
        } else {
          categoryTime = DateTime.now();
        }
        Duration diff = DateTime.now().difference(categoryTime!);
        if (value != null &&
            value != "" &&
            diff.inSeconds < CATEGORY_RESET_DURATION) {
          dynamic categories = json.decode(value);
          if (categories.length == 0)
            reselectIndices();
          else {
            categoryIndices.clear();
            for (int category in categories) {
              categoryIndices.add(category);
            }
          }
        } else {
          reselectIndices();
        }
      });
    });
  }

  void reselectIndices() async {
    int quizCount = quiz?.length ?? 0;
    var selectedList = List<int>.generate(quizCount, (i) => i)..shuffle();
    selectedList = selectedList.take(6).toList();
    categoryIndices = selectedList;
    categoryTime = DateTime.now();
    await Preferences.setString(
        Preferences.pfKStreakCategories, json.encode(categoryIndices));
    await Preferences.setString(
        Preferences.pfKStreakCategoriesTime, categoryTime!.toIso8601String());
  }

  void onCountDownEnd() {
    if (_controller.value.duration == _controller.value.position &&
        this._playVideo) {
      this._playVideo = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuestionsScreen(selectedQuiz!, true, widget.score),
        ),
      ).then((value) {
        setState(() {
          _isLoading = false;
          _controller.seekTo(Duration());
        });
      });
    }
  }
}
