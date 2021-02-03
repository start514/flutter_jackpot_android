import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/models/winner_score_model.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/common/common_rounded_level.dart';
import 'package:flutterjackpot/view/home/home_screen.dart';
import 'package:flutterjackpot/view/spinner/spinner_controller.dart';
import 'package:provider/provider.dart';

String item;

class SpinnerScreen extends StatefulWidget {
  final WinnerScore winnerScore;

  SpinnerScreen({this.winnerScore});

  @override
  _SpinnerScreenState createState() => _SpinnerScreenState();
}

class _SpinnerScreenState extends State<SpinnerScreen> {
  SendSpinRewardController sendSpinRewardController =
      new SendSpinRewardController();

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;

  final StreamController<double> _wheelNotifier =
      StreamController<double>.broadcast();

  final StreamController<int> _dividerController =
      StreamController<int>.broadcast();

  DateTime currentTime = DateTime.now();

  String dateTime;

  // ignore: must_call_super
  dispose() {
    _dividerController.close();
    _wheelNotifier.close();
  }

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _getPFData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Material(
            child: Center(
            child: CupertinoActivityIndicator(
              radius: 15.0,
            ),
          ))
        : Stack(
            children: [
              bgImage(context),
              Scaffold(
                backgroundColor: transparentColor,
                body: ChangeNotifierProvider<SendSpinRewardController>(
                  create: (BuildContext context) {
                    return sendSpinRewardController =
                        new SendSpinRewardController();
                  },
                  child: new Consumer<SendSpinRewardController>(
                    builder: (BuildContext context,
                        SendSpinRewardController controller, Widget child) {
                      if (sendSpinRewardController == null)
                        sendSpinRewardController = controller;

                      switch (controller.getStatus) {
                        case Status.LOADING:
                          return controller.getLoader;
                        case Status.SUCCESS:
                          return _spinnerBodyWidget(widget.winnerScore);
                        case Status.FAILED:
                          return _spinnerBodyWidget(widget.winnerScore);
                          break;
                        case Status.IDLE:
                          break;
                      }
                      return _spinnerBodyWidget(widget.winnerScore);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  Widget _spinnerBodyWidget(WinnerScore winnerScore) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sizedBoxAddMob(70.0),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: blackColor,
                border: Border.all(
                  color: greenColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(36.0),
              ),
              child: Text(
                winnerScore.winnerScore != null
                    ? "\$ ${winnerScore.winnerScore}"
                    : "\$ 0",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            _spinner(),
          ],
        ),
      ),
    );
  }

  Widget _spinner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 17.0),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: blackColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(35.0),
          ),
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: blackColor,
              border: Border.all(
                color: greenColor,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Daily Spin",
                  style: TextStyle(
                    fontSize: 17.0,
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  child: IgnorePointer(
                    ignoring: true,
                    child: SpinningWheel(
                      Image.asset("assets/spinner_image.png"),
                      width: 290,
                      height: 290,
                      initialSpinAngle: _generateRandomAngle(),
                      spinResistance: 0.3,
                      dividers: 8,
                      canInteractWhileSpinning: false,
                      onUpdate: _dividerController.add,
                      onEnd: onEnd,
                      secondaryImage: Image.asset("assets/roulette_center.png"),
                      secondaryImageHeight: 50,
                      secondaryImageWidth: 50,
                      shouldStartOrStop: _wheelNotifier.stream,
                    ),
                  ),
                  onTap: () {
                    _spin();
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                StreamBuilder(
                  stream: _dividerController.stream,
                  builder: (context, snapshot) => snapshot.hasData
                      ? RouletteScore(snapshot.data)
                      //sendReward(snapshot.data)
                      : Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 45.0,
                      child: RaisedButton(
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false);
                        },
                        color: greenColor,
                        textColor: blackColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: blackColor),
                          borderRadius: BorderRadius.circular(29.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: RaisedButton(
                        child: Text(
                          "Spin Again",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _spinAgainButtonTap();
                        },
                        color: greenColor,
                        textColor: blackColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: blackColor),
                          borderRadius: BorderRadius.circular(29.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: layoutBuilderDot(whiteColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 5.0,
              ),
              _roundedContainerImageStack(
                image: "power_ups.png",
                imageName: "Power UP",
                onTap: () {},
              ),
              SizedBox(
                width: 5.0,
              ),
              _roundedContainerImageStack(
                image: "winner_cup.png",
                imageName: "Winners",
                onTap: () {},
              ),
              SizedBox(
                width: 5.0,
              ),
              _roundedContainerImageStack(
                image: "ranking.png",
                imageName: "Rankings",
                onTap: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: layoutBuilderDot(whiteColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: roundLevel(),
        ),
      ],
    );
  }

  onEnd(int value) {
    print("##########################$item");
    sendReward(item: item, count: "1");
  }

  Future<void> sendReward({String item, String count}) async {
    await sendSpinRewardController.sendSpinRewardAPI(item: item, count: count);
  }

  _spinAgainButtonTap() {
    setState(() {
      _isLoading = true;
    });
    AdMobClass.showVideoAdd(
      isSpin: true,
      isInterstitial: false,
      afterVideoEnd: () {
        setState(() {
          _isLoading = false;
        });
        Future.delayed(
          Duration(seconds: 1),
          () {
            _wheelNotifier.sink.add(
              _generateRandomVelocity(),
            );
            Preferences.setString(
              Preferences.pfTapSpin,
              DateTime.now().toString(),
            );
            _getPFData();
          },
        );
      },
    );
  }

  void _spin() {
    if (dateTime == null) {
      _wheelNotifier.sink.add(
        _generateRandomVelocity(),
      );
      Preferences.setString(
        Preferences.pfTapSpin,
        DateTime.now().toString(),
      );
      _getPFData();
    } else {
      DateTime time = DateTime.parse(dateTime);
      if (int.parse(time.difference(DateTime.now()).inDays.toString()) > 0) {
        _wheelNotifier.sink.add(
          _generateRandomVelocity(),
        );
        Preferences.setString(
          Preferences.pfTapSpin,
          DateTime.now().toString(),
        );
        _getPFData();
      } else {
        Common.showErrorToastMsg("You can spin again after 24 hours");
      }
    }
  }

  void _getPFData() {
    Preferences.getString(Preferences.pfTapSpin).then(
      (value) {
        setState(() {
          dateTime = value;
          _isLoading = false;
        });
      },
    );
  }

  double _generateRandomVelocity() {
    return (Random().nextDouble() * 6000) + 2000;
  }

  Widget _roundedContainerImageStack(
      {String imageName, String image, void onTap()}) {
    return Expanded(
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 22.0),
              width: 75.0,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(23.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  "assets/$image",
                  height: 40.0,
                  width: 40.0,
                ),
              ),
            ),
            SizedBox(),
            Container(
              width: 80.0,
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
                imageName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class RouletteScore extends StatelessWidget {
  final int selected;

//  1 = bomb,
//  2 = heart,
//  3 = time,
//  4 = player,

  final Map<int, String> labels = {
    1: '2',
    2: '1',
    3: '3',
    4: '1',
    5: '1',
    6: '1',
    7: '4',
    8: '1',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    item = labels[selected];
    return Text(
      "",
//      "${labels[selected]}",
      style: TextStyle(
          color: Colors.red, fontStyle: FontStyle.italic, fontSize: 24.0),
    );
  }
}
