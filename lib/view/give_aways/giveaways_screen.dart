import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/get_categories_dialogs.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/give_aways/give_aways_controller.dart';
import 'package:flutterjackpot/view/give_aways/give_aways_model_class.dart';
import 'package:flutterjackpot/view/give_aways/giveaways_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';

class GiveawaysScreen extends StatefulWidget {
  @override
  _GiveawaysScreenState createState() => _GiveawaysScreenState();
}

class _GiveawaysScreenState extends State<GiveawaysScreen> {
  GiveAWaysController giveAWaysController = new GiveAWaysController();

  JackpotCategoriesAndQuizController jackpotCategoriesController =
      new JackpotCategoriesAndQuizController();

  bool _isLoading = true;

  List<GiveAWaysRecord>? giveAWays = [];

  List<Categories>? categories = [];
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    getGiveAWays();
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
              : _bodyWidget(giveAWays!),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<GiveAWaysRecord> giveAWays) {
    return giveAWays.length == 0
        ? Center(
            child: Text(
              "Give Aways Not Available Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    sizedBoxAddMob(42.0),
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
                              borderRadius: BorderRadius.circular(29.5),
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
                            borderRadius: BorderRadius.circular(unitHeightValue*15.0),
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
                    Center(
                      child: _gridView(giveAWays),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _gridView(List<GiveAWaysRecord> giveAWays) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2),
      itemCount: giveAWays.length,
      itemBuilder: (BuildContext context, int position) {
        GiveAWaysRecord giveAWaysRecord = giveAWays[position];
        return Container(
          padding: EdgeInsets.all(unitHeightValue * 8.0),
          margin: EdgeInsets.only(bottom: unitHeightValue * 8.0),
          child: InkWell(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.symmetric(vertical: unitHeightValue * 5.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: unitWidthValue * 1.5,
                    ),
                    borderRadius: BorderRadius.circular(unitHeightValue*10),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          UrlImageGiveAWaysPrefixUrl +
                              giveAWaysRecord.photoThumb!,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: unitWidthValue * double.infinity,
                    height: unitHeightValue * 40,
                    margin: EdgeInsets.fromLTRB( unitWidthValue * 1, unitHeightValue * 0, unitWidthValue * 1, unitHeightValue * 0),
                    padding: EdgeInsets.all(unitHeightValue * 5.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        giveAWaysRecord.name!.toUpperCase(),
                        textAlign: TextAlign.center,
                        minFontSize: 8,
                        maxLines: 1,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: unitHeightValue * 24.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiveWaysDetailsScreen(
                    giveAWaysRecord: giveAWaysRecord,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void getGiveAWays({categoryID}) {
    setState(() {
      _isLoading = true;
    });
    giveAWaysController.getAWays(categoryID).then(
      (value) {
        setState(
          () {
            giveAWays = value;
            getCategories();
          },
        );
      },
    );
  }

  void getCategories() {
    jackpotCategoriesController.getCategories().then(
      (value) {
        setState(
          () {
            _isLoading = false;
            categories = value;
          },
        );
      },
    );
  }
}
