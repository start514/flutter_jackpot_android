import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/dialogs/game_rules_dialogs.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/leaderbord/leaderbord_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/leaderbord/leaderbored_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/questions_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class JackpotTriviaDetailsScreen extends StatefulWidget {
  final Quiz? quiz;

  JackpotTriviaDetailsScreen({this.quiz});

  @override
  _JackpotTriviaState createState() => _JackpotTriviaState();
}

class _JackpotTriviaState extends State<JackpotTriviaDetailsScreen> {
  GetLeaderBordController getLeaderBordController =
      new GetLeaderBordController();

  List<LeaderBordRecord> lbList = List.empty();

  bool _isLoading = true;
  bool _playVideo = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    getLeaderBord(widget.quiz!);
    _controller = VideoPlayerController.asset(
      'assets/videos/count.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Plays the video once the widget is build and loaded.
      //_controller.play();
    });
    _initializeVideoPlayerFuture.then((value) => {
          _controller.addListener(() {
            if (_controller.value.duration == _controller.value.position &&
                this._playVideo) {
              this._playVideo = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionsScreen(widget.quiz!, false, 0),
                ),
              ).then((value) {
                setState(() {
                  _isLoading = false;
                  _controller.seekTo(Duration());
                });
              });
            }
          })
        });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
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
              : _bodyWidget(widget.quiz!),
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

  Widget _bodyWidget(Quiz quiz) {
    String? endDate =
        DateFormat("M/d/yy").format(DateTime.parse(quiz.end_date!));
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(unitHeightValue * 10.0),
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
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 29.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: unitWidthValue * 5,
                    ),
                    Expanded(
                      child: Container(
                        // width: unitWidthValue * double.infinity,
                        padding: EdgeInsets.all(unitWidthValue * 8.0),
                        decoration: BoxDecoration(
                          color: blackColor,
                          border: Border.all(
                            color: greenColor,
                            width: unitWidthValue * 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 15.0),
                        ),
                        child: AutoSizeText(
                          (quiz.title ?? "").toUpperCase(),
                          textAlign: TextAlign.center,
                          minFontSize: 8,
                          maxLines: 1,
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
                                GameRulesDialog(List<Categories>.empty()),
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
              SizedBox(
                height: unitHeightValue * 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: unitHeightValue * 200.0,
                        width: unitHeightValue * 200.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0.0),
                        margin: EdgeInsets.symmetric(
                            vertical: unitHeightValue * 10.0),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: unitWidthValue * 1.5,
                          ),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 10.5),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(unitHeightValue * 10.0),
                            border: Border.all(
                              color: whiteColor,
                              width: unitWidthValue * 1.5,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                UrlQuizImageJackpotTriviaPrefixUrl +
                                    quiz.photoThumb!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: unitHeightValue * 60.0,
                          margin: EdgeInsets.fromLTRB(
                              unitWidthValue * 10, unitHeightValue * 20, 0, 0),
                          padding: EdgeInsets.all(unitHeightValue * 2.0),
                          decoration: BoxDecoration(
                            color: blackColor,
                            border: Border.all(
                              color: greenColor,
                              width: unitWidthValue * 2,
                            ),
                            borderRadius:
                                BorderRadius.circular(unitHeightValue * 4.0),
                          ),
                          child: AutoSizeText(
                            "\$${quiz.amount}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: greenColor,
                              fontSize: unitHeightValue * 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: unitHeightValue * 180, right: 1),
                          width: unitHeightValue * 200,
                          padding: EdgeInsets.all(unitHeightValue * 2),
                          decoration: BoxDecoration(
                            color: blackColor,
                            border: Border.all(
                              color: greenColor,
                              width: unitWidthValue * 2,
                            ),
                            borderRadius:
                                BorderRadius.circular(unitHeightValue * 6.0),
                          ),
                          child: AutoSizeText(
                            (quiz.title ?? "").toUpperCase(),
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: unitHeightValue * 70.0,
                        width: unitWidthValue * 200.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            left: unitWidthValue * 24,
                            right: unitWidthValue * 24,
                            top: unitHeightValue * 8,
                            bottom: unitHeightValue * 8),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: greenColor,
                            width: unitWidthValue * 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 8),
                        ),
                        child: Text(
                          "ENDS ${endDate}",
                          style: TextStyle(
                            fontSize: unitHeightValue * 22.0,
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: unitHeightValue * 15.0,
                      ),
                      InkWell(
                        child: Container(
                          height: unitHeightValue * 120.0,
                          width: unitWidthValue * 200.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: greenColor,
                            border: Border.all(
                              color: greenColor,
                              width: unitWidthValue * 2.0,
                            ),
                            borderRadius:
                                BorderRadius.circular(unitHeightValue * 8.0),
                          ),
                          child: Text(
                            "PLAY NOW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: unitHeightValue * 32.0,
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
                padding: EdgeInsets.symmetric(
                    vertical: unitHeightValue * 17.0,
                    horizontal: unitWidthValue * 15.0),
                // child: layoutBuilderDot(whiteColor),
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
      _playVideo = true;
    });
    _controller.play();
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
                width: unitWidthValue * 2,
              ),
              borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(unitHeightValue * 8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: unitHeightValue * 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        "assets/winner_cup.png",
                        height: unitHeightValue * 30.0,
                        width: unitWidthValue * 30.0,
                        color: blackColor,
                      ),
                      Text(
                        " Leaderboard ",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: unitHeightValue * 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        "assets/winner_cup.png",
                        height: unitHeightValue * 30.0,
                        width: unitWidthValue * 30.0,
                        color: blackColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: unitHeightValue * 20.0,
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
                                  padding: EdgeInsets.only(
                                      top: unitHeightValue * 5.0,
                                      bottom: unitHeightValue * 5.0),
                                  child: Text(
                                    element.rank.toString(),
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: unitHeightValue * 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: unitHeightValue * 5.0,
                                      bottom: unitHeightValue * 5.0),
                                  child: AutoSizeText(
                                    element.userDetail!.name ?? "",
                                    minFontSize: 8,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: unitHeightValue * 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: unitHeightValue * 5.0,
                                      bottom: unitHeightValue * 5.0),
                                  child: Text(
                                    element.score ?? "0",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: unitHeightValue * 20.0,
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
