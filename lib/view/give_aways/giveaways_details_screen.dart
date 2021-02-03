import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_admob/firebase_admob.dart';
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
  final GiveAWaysRecord giveAWaysRecord;

  GiveWaysDetailsScreen({this.giveAWaysRecord});

  @override
  _GiveWaysDetailsScreenState createState() => _GiveWaysDetailsScreenState();
}

class _GiveWaysDetailsScreenState extends State<GiveWaysDetailsScreen> {
  RewardedVideoAd mRewardedVideoAd;

  GiveAWaysController giveAWaysController = new GiveAWaysController();

  List<GiveAWaysDetailsModelRecord> giveAWaysDetails = new List();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getGiveAWaysDetails(widget.giveAWaysRecord);
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
              : _bodyWidget(giveAWaysDetails),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<GiveAWaysDetailsModelRecord> giveAWaysDetails) {
    GiveAWaysDetailsModelRecord details = giveAWaysDetails[0];
    String formattedDate = DateFormat("M/d/yy").format(details.endDate);
    print("DATETIME");
    print(formattedDate);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              sizedBoxAddMob(90.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: blackColor,
                  border: Border.all(
                    color: whiteColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  "Giveaways",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: greenColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 0.0),
                    margin: EdgeInsets.only(bottom: 15.0),
                    height: 160.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(27.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: blackColor,
                            width: 1.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              UrlImageGiveAWaysPrefixUrl + details.photoThumb,
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
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
                      details.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: _roundedButtons(
                      title: "Ends",
                      subTitle: formattedDate,
                    ),
                  ),
                  SizedBox(
                    width: 7.0,
                  ),
                  Expanded(
                    child: _roundedButtons(
                      title: "Free",
                      subTitle: "Entry",
                      color: greenColor,
                      onTap: () {
                        giveAWaysController.submitfreeEntryGiveaway(
                            giveaway_id: widget.giveAWaysRecord.id);
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
                    width: 7.0,
                  ),
                  Expanded(
                    child: _roundedButtons(
                      title: "Game",
                      subTitle: "Rules",
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
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              _roundedAddOption(
                image: "youtube_flat.png",
                title: details.task[0].name,
                entries: details.task[0].entry,
                onTap: () {
                  setState(() {
                    _isLoading = true;
                  });
                  AdMobClass.showVideoAdd(
                    isSpin: false,
                    isInterstitial: true,
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
              _roundedAddOption(
                  image: "facebook.png",
                  title: details.task[1].name,
                  entries: details.task[1].entry,
                  onTap: () {
                    _launchURL(details.task[1].url);
                  }),
              _roundedAddOption(
                  image: "facebook.png",
                  title: details.task[2].name,
                  entries: details.task[2].entry,
                  onTap: () {
                    _launchURL(details.task[2].url);
                  }),
              _roundedAddOption(
                  image: "youtube_flat.png",
                  title: details.task[3].name,
                  entries: details.task[3].entry,
                  onTap: () {
                    _launchURL(details.task[3].url);
                  }),
              _roundedAddOption(
                  image: "twitter_circle.png",
                  title: details.task[4].name,
                  entries: details.task[4].entry,
                  onTap: () {
                    _launchURL(details.task[4].url);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundedButtons(
      {String title, String subTitle, Color color, void onTap()}) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        padding: EdgeInsets.only(top: 6.0, bottom: 3.0, right: 3.0, left: 3.0),
        decoration: BoxDecoration(
          color: color != null ? color : whiteColor,
          border: Border.all(
            color: blackColor,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              title != null
                  ? AutoSizeText(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 16.0,
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
                          fontSize: FontSize(16.0),
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

  Widget _roundedAddOption(
      {String title, String image, String entries, void onTap()}) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: 10.0, bottom: 8.0, right: 8.0, left: 8.0),
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.0, bottom: 11.5),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: blackColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 4.0, left: 5.0),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: blackColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(29.5),
              ),
              child: Image.asset(
                "assets/$image",
                height: 50.0,
                width: 50.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(top: 7.5, right: 4.5, bottom: 2.0),
              padding: EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                color: greenColor,
                border: Border.all(
                  color: blackColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(29.5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0.0, right: 8.0, left: 8.0),
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
        onTap();
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
