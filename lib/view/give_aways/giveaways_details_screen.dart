import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutterjackpot/dialogs/earned_dialog.dart';
import 'package:flutterjackpot/dialogs/rules_dialog.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/give_aways/give_aways_controller.dart';
import 'package:flutterjackpot/view/give_aways/give_aways_model_class.dart';
import 'package:flutterjackpot/view/give_aways/giveaways_details_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GiveWaysDetailsScreen extends StatefulWidget {
  final GiveAWaysRecord? giveAWaysRecord;

  GiveWaysDetailsScreen({this.giveAWaysRecord});

  @override
  _GiveWaysDetailsScreenState createState() => _GiveWaysDetailsScreenState();
}

class _GiveWaysDetailsScreenState extends State<GiveWaysDetailsScreen> {
  GiveAWaysController giveAWaysController = new GiveAWaysController();

  List<GiveAWaysDetailsModelRecord>? giveAWaysDetails = List.empty();

  bool _isLoading = true;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    getGiveAWaysDetails(widget.giveAWaysRecord!);
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
              : _bodyWidget(giveAWaysDetails!),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<GiveAWaysDetailsModelRecord> giveAWaysDetails) {
    GiveAWaysDetailsModelRecord details = giveAWaysDetails[0];
    String formattedDate = DateFormat("M/d/yy").format(details.endDate!);
    print("DATETIME");
    print(formattedDate);
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: SingleChildScrollView(
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
                        side: BorderSide(color: greenColor, width: unitWidthValue * 2.0),
                        borderRadius: BorderRadius.circular(unitHeightValue * 29.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: unitWidthValue * 10,
                  ),
                  Expanded(
                      child: Container(
                    // width: unitWidthValue * double.infinity,
                    padding: EdgeInsets.fromLTRB( unitWidthValue * 8.0, unitHeightValue * 2.0, unitWidthValue * 8.0, unitHeightValue * 2.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
                    ),
                    child: Text(
                      "GIVEAWAYS",
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
                height: unitHeightValue * 20.0,
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: unitHeightValue * 0.0),
                    margin: EdgeInsets.fromLTRB( unitWidthValue * 15, unitHeightValue * 0, unitWidthValue * 15.0, unitHeightValue * 15.0),
                    height: unitHeightValue * 160.0,
                    width: unitWidthValue * double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(unitHeightValue * 27.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(unitHeightValue * 25.0),
                          border: Border.all(
                            color: blackColor,
                            width: unitWidthValue * 1.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              UrlImageGiveAWaysPrefixUrl + details.photoThumb!,
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width:  MediaQuery.of(context).size.width - unitWidthValue * 150,
                    padding: EdgeInsets.all(unitHeightValue * 2.0),
                    decoration: BoxDecoration(
                      color: greenColor,
                      border: Border.all(
                        color: blackColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(unitHeightValue * 6.0),
                    ),
                    child: AutoSizeText(
                      details.name!.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: unitHeightValue * 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: unitHeightValue * 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                  Expanded(
                    child: _roundedButtons(
                      title: "ENDS " + formattedDate,
                    ),
                  ),
                  SizedBox(
                    width: unitWidthValue * 40,
                  ),
                  Expanded(
                    child: _roundedButtons(
                      title: "GAME RULES",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => RulesDialog(
                            details: details,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                ],
              ),
              SizedBox(height: unitHeightValue * 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                  Expanded(
                    child: _entryButton(
                      title: "FREE ENTRY",
                      entryCount: 1,
                      onTap: () {
                        giveAWaysController.submitfreeEntryGiveaway(
                            giveaway_id: widget.giveAWaysRecord!.id);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => EarnedDialog(
                            details: details,
                            isEntry: true,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: unitWidthValue * 40,
                  ),
                  Expanded(
                    child: _entryButton(
                      entryCount: 3,
                      image: "play.png",
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        AdMobClass.showVideoAdd(
                          isSpin: false,
                          afterVideoEnd: () {
                            setState(() {
                              _isLoading = false;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => EarnedDialog(
                                details: details,
                                isEntry: false,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                ],
              ),
              SizedBox(
                height: unitHeightValue * 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                  Expanded(
                    child: _entryButton(
                        entryCount: 5,
                        image: "tiktok.png",
                        onTap: () {
                          _launchURL(details.task![4].url);
                        }),
                  ),
                  SizedBox(
                    width: unitWidthValue * 40,
                  ),
                  Expanded(
                    child: _entryButton(
                        entryCount: 5,
                        image: "facebook_.png",
                        onTap: () {
                          _launchURL(details.task![1].url);
                        }),
                  ),
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                ],
              ),
              SizedBox(
                height: unitHeightValue * 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                  Expanded(
                    child: _entryButton(
                        entryCount: 5,
                        image: "share.png",
                        onTap: () {
                          _launchURL(details.task![2].url);
                        }),
                  ),
                  SizedBox(
                    width: unitWidthValue * 40,
                  ),
                  Expanded(
                    child: _entryButton(
                        entryCount: 5,
                        image: "youtube.png",
                        onTap: () {
                          _launchURL(details.task![3].url);
                        }),
                  ),
                  SizedBox(
                    width: unitWidthValue * 20,
                  ),
                ],
              ),
              SizedBox(
                height: unitHeightValue * 10.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundedButtons(
      {String? title, String? subTitle, Color? color, void onTap()?}) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width - unitWidthValue * 60,
        padding: EdgeInsets.only(top: unitHeightValue * 6.0, bottom: unitHeightValue * 3.0, right: unitWidthValue *2.0, left: unitWidthValue *2.0),
        decoration: BoxDecoration(
          color: blackColor,
          border: Border.all(
            color: greenColor,
            width: unitWidthValue * 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(unitHeightValue * 6.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(unitHeightValue * 5.0),
          child: Column(
            children: <Widget>[
              title != null
                  ? AutoSizeText(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: greenColor,
                        fontSize: unitHeightValue * 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              subTitle != null
                  ? Html(
                      data: subTitle,
                      style: {
                        "html": Style(
                          textAlign: TextAlign.center,
                          color: blackColor,
                          fontSize: FontSize(unitHeightValue * 16.0),
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _entryButton(
      {String? title,
      int? entryCount,
      String? image,
      bool? plus,
      void onTap()?}) {
    return Container(
      padding: EdgeInsets.all(unitHeightValue * 5.0),
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Align(
              child: Container(
                height: unitHeightValue * 140,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(0.0),
                margin: EdgeInsets.only(top: unitHeightValue * 10),
                decoration: BoxDecoration(
                  color: blackColor,
                  border: Border.all(
                    color: whiteColor,
                    width: unitWidthValue * 2,
                  ),
                  borderRadius: BorderRadius.circular(unitHeightValue * 8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: unitHeightValue * 40),
                  child: title != null
                      ? AutoSizeText(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: greenColor,
                            fontSize: unitHeightValue * 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Image.asset(
                          "assets/$image",
                          height: unitHeightValue * 80.0,
                          // width: unitWidthValue * 100.0,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: plus == true
                    ? Container(
                        width: unitWidthValue * 60.0,
                        margin: EdgeInsets.fromLTRB( unitWidthValue * 10, unitHeightValue * 2.0, 0, 0),
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: blackColor,
                          border: Border.all(
                            color: greenColor,
                            width: unitWidthValue * 2,
                          ),
                          borderRadius: BorderRadius.circular(unitHeightValue * 4.0),
                        ),
                        child: AutoSizeText(
                          "+",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: greenColor,
                            fontSize: unitHeightValue * 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container()),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all( unitHeightValue * 2 ),
                           margin: EdgeInsets.all( 0 ),
                           decoration: BoxDecoration(
                            color: blackColor,
                            border: Border.all(
                              color: whiteColor,
                              width: unitWidthValue * 2,
                            ),
                            borderRadius: BorderRadius.circular(unitHeightValue * 8),
                          ),
                          child: AutoSizeText(
                            "+" +
                                entryCount.toString() +
                                (entryCount == 1 ? " ENTRY" : " ENTRIES"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                color: whiteColor,
                                fontSize: unitHeightValue * 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ])),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _roundedAddOption(
      {required String title, String? image, String? entries, void onTap()?}) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: unitHeightValue * 10.0, bottom: unitHeightValue * 8.0, right: 8.0, left: 8.0),
            width: unitWidthValue * double.infinity,
            padding: EdgeInsets.only(top: unitHeightValue * 10.0, bottom: unitHeightValue * 11.5),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: blackColor,
                width: unitWidthValue * 2,
              ),
              borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
            ),
            child: AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: unitHeightValue * 16.0,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: unitHeightValue * 4.0, left: 5.0),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 2,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 29.5),
              ),
              child: Image.asset(
                "assets/$image",
                height: unitHeightValue * 50.0,
                width: unitWidthValue * unitHeightValue * 50.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(top: unitHeightValue * 7.5, right: 4.5, bottom: unitHeightValue * 2.0),
              padding: EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                color: greenColor,
                border: Border.all(
                  color: blackColor,
                  width: unitWidthValue * 2,
                ),
                borderRadius: BorderRadius.circular(unitHeightValue * 29.5),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: unitHeightValue * 0.0, bottom: unitHeightValue * 0.0, right: 8.0, left: 8.0),
                child: Text(
                  "$entries\nEntries",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        onTap!();
      },
    );
  }

  _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      print("*****$error");
    }
  }

  void getGiveAWaysDetails(GiveAWaysRecord giveAWaysRecord) {
    giveAWaysController
        .getGiveAWaysDetails(giveAWaysRecord: giveAWaysRecord)
        .then(
      (value) {
        setState(
          () {
            giveAWaysDetails = value;
            _isLoading = false;
          },
        );
      },
    );
  }
}
