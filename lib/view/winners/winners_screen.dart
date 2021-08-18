import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';

import 'winners_controller.dart';
import 'winners_model.dart';

class WinnersScreen extends StatefulWidget {
  @override
  _WinnersState createState() => _WinnersState();
}

class _WinnersState extends State<WinnersScreen> {
  WinnerImagesController winnerImagesController = new WinnerImagesController();

  bool _isLoading = true;

  int tab = 0;

  GetWinnersImagesModel? winnersImagesModel;

  List<WinnersImages>? winners = [];
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    getWinnersImagesRecord();
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
      ],
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sizedBoxAddMob(unitHeightValue * 42.0),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
                    borderRadius: BorderRadius.circular(unitHeightValue * 29.5),
                  ),
                ),
              ),
              SizedBox(
                width: unitWidthValue * 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: unitHeightValue * 2,
                      horizontal: unitWidthValue * 8),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: greenColor,
                      width: unitWidthValue * 2,
                    ),
                    borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
                  ),
                  child: Text(
                    "WINNERS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: unitHeightValue * 32.0,
                        color: whiteColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: unitHeightValue * 10.0,
                  horizontal: unitWidthValue * 12.0),
              // child: layoutBuilderDot(whiteColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: unitWidthValue * 120.0,
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "JACKPOT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: unitHeightValue * 24,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      tab = 0;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: unitWidthValue * 120.0,
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "STREAK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: unitHeightValue * 24,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      tab = 2;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: unitWidthValue * 120.0,
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "GIVEAWAYS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: unitHeightValue * 24,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      tab = 1;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: unitHeightValue * 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width - unitWidthValue * 50,
              height:
                  MediaQuery.of(context).size.height - unitHeightValue * 215,
              decoration: BoxDecoration(
                color: whiteColor,
                image: DecorationImage(
                  image: NetworkImage(
                    winners![tab].filename != null
                        ? UrlWinnersImagePrefixUrl + winners![tab].filename!
                        : "",
                  ),
                ),
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 4,
                ),
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getWinnersImagesRecord() async {
    winnersImagesModel = await winnerImagesController.getWinnerImagesAPI();
    setState(() {
      winners = winnersImagesModel!.winnersImages;
      _isLoading = false;
    });
  }
}
