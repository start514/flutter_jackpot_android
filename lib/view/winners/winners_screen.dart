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

  bool _isTrivia = true;

  GetWinnersImagesModel winnersImagesModel;

  List<WinnersImages> winners = new List();

  @override
  void initState() {
    super.initState();
    getWinnersImagesRecord();
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
            sizedBoxAddMob(90.0),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: blackColor,
                border: Border.all(
                  color: whiteColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Winners",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: greenColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: layoutBuilderDot(whiteColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: 130.0,
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(29.5),
                    ),
                    child: Text(
                      "Trivia",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isTrivia = true;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: 130.0,
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(29.5),
                    ),
                    child: Text(
                      "Giveaways",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isTrivia = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 215,
              decoration: BoxDecoration(
                color: whiteColor,
                image: DecorationImage(
                    image: _isTrivia
                        ? NetworkImage(
                            winners[0].filename != null
                                ? UrlWinnersImagePrefixUrl + winners[0].filename
                                : "",
                          )
                        : NetworkImage(
                            winners[1].filename != null
                                ? UrlWinnersImagePrefixUrl + winners[1].filename
                                : "",
                          )),
                border: Border.all(
                  color: blackColor,
                  width: 4,
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
      winners = winnersImagesModel.winnersImages;
      _isLoading = false;
    });
  }
}
