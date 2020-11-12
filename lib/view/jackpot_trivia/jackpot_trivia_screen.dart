import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/get_categories_dialogs.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_triva_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';

class JackPotTriviaScreen extends StatefulWidget {
  @override
  _JackPotTriviaScreenState createState() => _JackPotTriviaScreenState();
}

class _JackPotTriviaScreenState extends State<JackPotTriviaScreen> {
  JackpotCategoriesAndQuizController jackpotCategoriesController =
      new JackpotCategoriesAndQuizController();

  final searchController = new TextEditingController();

  List<Categories> categories;
  List<Quiz> quiz;
  final List<Quiz> searchQuiz = new List();

  String searchWord;
  bool isSearch = false;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchWord = searchController.text;
        buildSearchList();
      });
    });
    getQuiz();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              : _bodyWidget(quiz, categories),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<Quiz> quiz, List<Categories> categories) {
    return categories.length == 0
        ? Center(
            child: Text(
              "Jackpot Trivia Not Available Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                          color: greenColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        "Jackpot Trivia",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: greenColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              borderRadius: BorderRadius.circular(29.5),
                            ),
                            child: Text(
                              "Filter",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: greyColor,
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
                                getQuiz(categoryID: categoryID);
                              },
                            );
                          },
                        ),
                        Container(
                          width: 120.0,
                          height: 35.0,
                          padding: EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                          decoration: BoxDecoration(
                            color: blackColor,
                            border: Border.all(
                              color: whiteColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(29.5),
                          ),
                          child: TextFormField(
                            controller: searchController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: whiteColor,
                            ),
                            decoration: new InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: greyColor,
                              ),
                            ),
                          ),
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Divider(
                      height: 2.0,
                      thickness: 2.0,
                      color: whiteColor,
                    ),
                    _gridView(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _gridView() {
    if (quiz.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          "No Record Yet",
          style: TextStyle(
            fontSize: 17.0,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (searchWord != null && searchQuiz.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          "No Quiz Matched Your Search",
          style: TextStyle(
            fontSize: 17.0,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2),
      itemCount: searchQuiz.length,
      itemBuilder: (BuildContext context, int position) {
        Quiz _quiz = searchQuiz[position];
        return Container(
          padding: EdgeInsets.all(5.0),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27.0),
                      border: Border.all(
                        color: blackColor,
                        width: 1.5,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          UrlQuizImageJackpotTriviaPrefixUrl + _quiz.photoThumb,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 130.0,
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
                      _quiz.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
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
                      "\$ ${_quiz.amount}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: greenColor,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JackpotTriviaDetailsScreen(
                    quiz: _quiz,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void getQuiz({categoryID}) {
    setState(() {
      _isLoading = true;
    });
    jackpotCategoriesController.getQuiz(categoryID: categoryID).then(
      (value) {
        setState(
          () {
            quiz = value;
            buildSearchList();
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

  void buildSearchList() {
    searchQuiz.clear();
    if (searchWord == null || searchWord == "") {
      searchQuiz.addAll(quiz);
    } else {
      for (int i = 0; i < quiz.length; i++) {
        Quiz _class = quiz.elementAt(i);
        String s = _class.title.toLowerCase();
        if (s.contains(searchWord.toLowerCase())) {
          searchQuiz.add(_class);
        }
      }
    }
  }
}
