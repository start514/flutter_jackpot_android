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

  List<GiveAWaysRecord> giveAWays = new List();

  List<Categories> categories = new List();

  @override
  void initState() {
    super.initState();
    getGiveAWays();
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
              : _bodyWidget(giveAWays),
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
                        borderRadius: BorderRadius.circular(15.0),
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
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: 100.0,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: blackColor,
                              border: Border.all(
                                color: whiteColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              "Filter",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  GetCategoriesDialog(categories),
                            ).then(
                              (categoryID) {
                                getGiveAWays(categoryID: categoryID);
                              },
                            );
                          },
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          height: 45.0,
                          width: 45.0,
                          alignment: Alignment.center,
                          child: Card(
                            child: IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () {},
                            ),
                          ),
                        )
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
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.only(bottom: 17.0),
          child: InkWell(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(29.5),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          UrlImageGiveAWaysPrefixUrl +
                              giveAWaysRecord.photoThumb,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 130.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: whiteColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: AutoSizeText(
                      giveAWaysRecord.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: greenColor, fontSize: 15.0),
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
