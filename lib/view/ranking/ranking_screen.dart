import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/ranking/ranking_controller.dart';
import 'package:flutterjackpot/view/ranking/ranking_model.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  TopRankerController topRankerController = new TopRankerController();

  List<TopRankerRecord>? topRankerList = [];

  bool _isLoading = true;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    _getTop100Ranker();
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
              : _bodyWidget(topRankerList!),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<TopRankerRecord> topRankerList) {
    return Padding(
      padding: EdgeInsets.all(unitHeightValue * 5.0),
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
                margin: EdgeInsets.all(unitHeightValue * 8.0),
                padding: EdgeInsets.all(unitHeightValue * 8.0),
                decoration: BoxDecoration(
                  color: blackColor,
                  border: Border.all(
                    color: greenColor,
                    width: unitWidthValue * 2,
                  ),
                  borderRadius: BorderRadius.circular(unitHeightValue*15.0),
                ),
                child: Text(
                  "RANKINGS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: unitHeightValue * 30.0,
                      color: whiteColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]),
          Padding(
              padding:
                  EdgeInsets.symmetric(vertical: unitHeightValue * 10.0, horizontal: 14.0)),
          Container(
            decoration: BoxDecoration(
              color: blackColor,
              border: Border.all(
                color: whiteColor,
                width: unitWidthValue * 2,
              ),
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, right: 30.0, left: 30.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: unitWidthValue * 2,
                    ),
                    borderRadius: BorderRadius.circular(29.5),
                  ),
                  child: Text(
                    "Top 100",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: unitHeightValue * 18,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: unitHeightValue * 8.0, left: 0.0, right: 0.0, bottom: 0.0),
                  child: Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: greenColor,
                        ),
                        children: [
                          Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: unitHeightValue * 8.0, bottom: unitHeightValue * 8.0),
                              child: AutoSizeText(
                                "#",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: unitHeightValue * 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: unitHeightValue * 8.0, bottom: unitHeightValue * 8.0),
                              child: AutoSizeText(
                                "@USERNAME",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: unitHeightValue * 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: unitHeightValue * 8.0, bottom: unitHeightValue * 8.0),
                              child: AutoSizeText(
                                "Points",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: unitHeightValue * 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - unitHeightValue * 380,
                  child:
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child:
                          Container(
                            margin: EdgeInsets.only(
                                top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
                            color: blackColor,
                            child: Table(
                              border: TableBorder.all(color: whiteColor),
                              children: topRankerList
                                  .map<TableRow>(
                                    (element) => TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 5.0),
                                            child: Text(
                                              element.rank.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: unitHeightValue * 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 5.0),
                                            child: Text(
                                              element.topRankerUserDetails?.name ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: unitHeightValue * 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 5.0),
                                            child: Text(
                                              element.totalPoints!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: unitHeightValue * 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getTop100Ranker() async {
    topRankerList = await topRankerController.topRankerAPI();
    for (int i = 0; i < topRankerList!.length; i++) {
      topRankerList![i].rank = i + 1;
    }
    setState(() {
      _isLoading = false;
    });
  }
}
