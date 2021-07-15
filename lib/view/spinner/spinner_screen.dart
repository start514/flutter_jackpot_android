import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
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
import 'package:flutterjackpot/utils/url_utils.dart';

String? item;

class SpinnerScreen extends StatefulWidget {
  final WinnerScore? winnerScore;

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

  String? dateTime;

  // ignore: must_call_super
  dispose() {
    _dividerController.close();
    _wheelNotifier.close();
  }

  bool _isLoading = false;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    this._isLoading = true;
    getState().then((bool ret) => setState(() => {this._isLoading = false}));
    _getPFData();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
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
                        SendSpinRewardController controller, Widget? child) {
                      if (sendSpinRewardController == null)
                        sendSpinRewardController = controller;

                      switch (controller.getStatus) {
                        case Status.LOADING:
                          return controller.getLoader;
                        case Status.SUCCESS:
                          return _spinnerBodyWidget(widget.winnerScore!);
                        case Status.FAILED:
                          return _spinnerBodyWidget(widget.winnerScore!);
                          break;
                        case Status.IDLE:
                          break;
                      }
                      return _spinnerBodyWidget(widget.winnerScore!);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  Widget _spinnerBodyWidget(WinnerScore winnerScore) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: unitWidthValue * 12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sizedBoxAddMob(unitHeightValue * 80.0),
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
                      semanticLabel: 'Text to announce in accessibility modes',
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
                  width: unitWidthValue * 10,
                ),
                Expanded(
                    child: Container(
                  // width: unitWidthValue * double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: unitHeightValue * 2,
                      horizontal: unitWidthValue * 12.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: greenColor,
                      width: unitWidthValue * 2,
                    ),
                    borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
                  ),
                  child: Text(
                    "FREE POWER UPS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: unitHeightValue * 32.0,
                        color: whiteColor,
                        fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
            SizedBox(
              height: unitHeightValue * 60,
            ),
            _powerUp(
                image: "player2.png",
                used: userRecord?.freebiesUsed?.thePlayer,
                type: "4"),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: unitHeightValue * 25.0,
                  horizontal: unitWidthValue * 15.0),
              child: layoutBuilderLine(whiteColor),
            ),
            _powerUp(
                image: "bomb.png",
                used: userRecord?.freebiesUsed?.theBomb,
                type: "1"),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: unitHeightValue * 25.0,
                  horizontal: unitWidthValue * 15.0),
              child: layoutBuilderLine(whiteColor),
            ),
            _powerUp(
                image: "clock.png",
                used: userRecord?.freebiesUsed?.theTime,
                type: "3"),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: unitHeightValue * 10.0, horizontal: 15.0),
            ),
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
              width: unitWidthValue * 3,
            ),
            borderRadius: BorderRadius.circular(unitHeightValue * 35.0),
          ),
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: blackColor,
              border: Border.all(
                color: greenColor,
                width: unitWidthValue * 4,
              ),
              borderRadius: BorderRadius.circular(unitHeightValue * 32.0),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Daily Spin",
                  style: TextStyle(
                    fontSize: unitHeightValue * 17.0,
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  child: IgnorePointer(
                    ignoring: true,
                    child: //SpinningWheel(
                        Image.asset("assets/spinner_image.png",
                            width: unitWidthValue * unitHeightValue * 290,
                            height: unitHeightValue * 290),
                    //   initialSpinAngle: _generateRandomAngle(),
                    //   spinResistance: 0.3,
                    //   dividers: 8,
                    //   canInteractWhileSpinning: false,
                    //   onUpdate: _dividerController.add,
                    //   onEnd: onEnd,
                    //   secondaryImage: Image.asset("assets/roulette_center.png"),
                    //   secondaryImageHeight: unitHeightValue * 50,
                    //   secondaryImageWidth: unitWidthValue * 50,
                    //   shouldStartOrStop: _wheelNotifier.stream,
                    // ),
                  ),
                  onTap: () {
                    _spin();
                  },
                ),
                SizedBox(
                  height: unitHeightValue * 10.0,
                ),
                StreamBuilder(
                  stream: _dividerController.stream,
                  builder: (context, snapshot) => snapshot.hasData
                      ? RouletteScore(int.parse(snapshot.data.toString()))
                      //sendReward(snapshot.data)
                      : Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: unitHeightValue * 45.0,
                      child: RaisedButton(
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontSize: unitHeightValue * 16.0,
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
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 29.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: unitHeightValue * 45.0,
                      child: RaisedButton(
                        child: Text(
                          "Spin Again",
                          style: TextStyle(
                            fontSize: unitHeightValue * 16.0,
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
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 29.5),
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
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: layoutBuilderDot(whiteColor),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: unitWidthValue * 5.0,
              ),
              _roundedContainerImageStack(
                image: "power_ups.png",
                imageName: "Power UP",
                onTap: () {},
              ),
              SizedBox(
                width: unitWidthValue * 5.0,
              ),
              _roundedContainerImageStack(
                image: "winner_cup.png",
                imageName: "Winners",
                onTap: () {},
              ),
              SizedBox(
                width: unitWidthValue * 5.0,
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
          padding: EdgeInsets.symmetric(
              vertical: unitHeightValue * 15.0, horizontal: 20.0),
          child: layoutBuilderDot(whiteColor),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: unitHeightValue * 10.0, horizontal: 10.0),
          child: roundLevel(),
        ),
      ],
    );
  }

  onEnd(int value) {
    print("##########################$item");
    // sendReward(item: item, count: "1");
  }

  _spinAgainButtonTap() {
    setState(() {
      this._isLoading = true;
    });
    AdMobClass.showVideoAdd(
      isSpin: true,
      afterVideoEnd: () {
        setState(() {
          this._isLoading = false;
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
    if (dateTime == null || dateTime == "") {
      _wheelNotifier.sink.add(
        _generateRandomVelocity(),
      );
      Preferences.setString(
        Preferences.pfTapSpin,
        DateTime.now().toString(),
      );
      _getPFData();
    } else {
      DateTime time = DateTime.parse(dateTime!);
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
      {required String imageName, String? image, void onTap()?}) {
    return Expanded(
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: unitHeightValue * 22.0),
              width: unitWidthValue * 75.0,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 2,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 23.5),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Image.asset(
                  "assets/$image",
                  height: unitHeightValue * 40.0,
                  width: unitWidthValue * 40.0,
                ),
              ),
            ),
            SizedBox(),
            Container(
              width: unitWidthValue * 80.0,
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 2,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 20.0),
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

  Widget _powerUp(
      {required String image, required String? used, required String type}) {
    int used_freebies = int.parse(used == null ? "0" : used);
    int remain = 3 - used_freebies;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: unitHeightValue * 160.0,
          width: unitWidthValue * 160.0,
          alignment: Alignment.center,
          padding: EdgeInsets.all(0.0),
          margin: EdgeInsets.symmetric(vertical: unitHeightValue * 10.0),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: greenColor,
              width: unitWidthValue * 2,
            ),
            borderRadius: BorderRadius.circular(unitHeightValue * 8),
          ),
          child: Container(
            child: Image.asset(
              "assets/${image}",
              height: unitHeightValue * 120.0,
              width: unitWidthValue * 120.0,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: unitHeightValue * 60.0,
              width: unitWidthValue * 200.0,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: unitHeightValue * 8.0,
                  horizontal: unitWidthValue * 12.0),
              decoration: BoxDecoration(
                color: blackColor,
                border: Border.all(
                  color: greenColor,
                  width: unitWidthValue * 2,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 8),
              ),
              child: Text(
                "${remain} REMAINING",
                style: TextStyle(
                  fontSize: unitHeightValue * 24.0,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: unitHeightValue * 15.0,
            ),
            InkWell(
              child: Container(
                height: unitHeightValue * 60.0,
                width: unitWidthValue * 200.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: greenColor,
                  border: Border.all(
                    color: greenColor,
                    width: unitWidthValue * 2.0,
                  ),
                  borderRadius: BorderRadius.circular(unitHeightValue * 8.0),
                ),
                child: Text(
                  "Watch Video",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: unitHeightValue * 26.0,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                AdMobClass.showVideoAdd(
                  isSpin: false,
                  afterVideoEnd: () async {
                    await addFreebie(type: type);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class RouletteScore extends StatelessWidget {
  final int? selected;

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

  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    item = labels[selected!];
    return Text(
      "",
//      "${labels[selected]}",
      style: TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic,
          fontSize: unitHeightValue * 24.0),
    );
  }
}

Future<bool> addFreebie({required String type}) async {
  try {
    Map<String, dynamic> body = {
      "type": type,
      "user_id": userRecord!.userID,
    };
    dynamic response = await net.getWithDio(url: UrlAddFreebie, body: body);

    if (response == true) {
      await getState();
      return true;
    } else {}
  } catch (error, st) {
    print(st);
  }
  return false;
}
