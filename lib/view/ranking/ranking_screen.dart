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

  List<TopRankerRecord> topRankerList = new List();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getTop100Ranker();
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
              : _bodyWidget(topRankerList),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<TopRankerRecord> topRankerList) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          sizedBoxAddMob(42.0),
          Container(
            margin: EdgeInsets.all(8.0),
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: blackColor,
              border: Border.all(
                color: whiteColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              "Rankings",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: greenColor,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
            child: layoutBuilderDot(whiteColor),
          ),
          Container(
            decoration: BoxDecoration(
              color: blackColor,
              border: Border.all(
                color: whiteColor,
                width: 2,
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
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(29.5),
                  ),
                  child: Text(
                    "Top 100",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 0.0, right: 0.0, bottom: 0.0),
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
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: AutoSizeText(
                                "#",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: AutoSizeText(
                                "@USERNAME",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: AutoSizeText(
                                "Points",
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                SingleChildScrollView(
                  child: Container(
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
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(
                                      element.topRankerUserDetails.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(
                                      element.totalPoints,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getTop100Ranker() async {
    topRankerList = await topRankerController.topRankerAPI();
    for (int i = 0; i < topRankerList.length; i++) {
      topRankerList[i].rank = i + 1;
    }
    setState(() {
      _isLoading = false;
    });
  }
}
