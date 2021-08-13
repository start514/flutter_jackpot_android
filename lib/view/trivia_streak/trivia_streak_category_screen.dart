import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/get_categories_dialogs.dart';
import 'package:flutterjackpot/dialogs/game_rules_dialogs.dart';
import 'package:flutterjackpot/dialogs/streak_rules_dialogs.dart';
import 'package:flutterjackpot/utils/admob_utils.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/consumable_store.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_triva_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/questions_screen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

const int CATEGORY_RESET_DURATION = 120;

const bool kAutoConsume = true;
String _kConsumableIdUnlockCategorySingle =
    'com.triviastax.unlockcategorysingle';
String _kConsumableIdUnlockCategoryRow = 'com.triviastax.unlockcategoryrow';
String _kConsumableIdReshuffleCategory = 'com.triviastax.reshufflecategory';
String _kConsumableIdNoAds =
    Platform.isIOS ? 'com.triviastax.noads1' : 'com.triviastax.noads';
List<String> _kProductIds = <String>[
  _kConsumableIdUnlockCategorySingle,
  _kConsumableIdUnlockCategoryRow,
  _kConsumableIdReshuffleCategory,
  _kConsumableIdNoAds
];

class TriviaStreakCategoryScreen extends StatefulWidget {
  final int? score;
  TriviaStreakCategoryScreen({this.score});
  @override
  _TriviaStreakCategoryScreenState createState() =>
      _TriviaStreakCategoryScreenState();
}

class _TriviaStreakCategoryScreenState
    extends State<TriviaStreakCategoryScreen> {
  JackpotCategoriesAndQuizController jackpotCategoriesController =
      new JackpotCategoriesAndQuizController();

  final searchController = new TextEditingController();

  List<Categories>? categories;
  List<Quiz>? quiz;
  List<int> categoryIndices = List.empty(growable: true);
  DateTime? categoryTime;

  String? searchWord;
  bool isSearch = false;

  bool _isLoading = false;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  late Timer _timer;
  bool _playVideo = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  Quiz? selectedQuiz;
  List<bool> categoryLock = List.empty(growable: true);
  bool isSecondRowEnabled = false;

  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String?> _consumables = [];
  List<String> _notFoundIds = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  int? unlockPosition;

  int adShuffleCount = 0;

  DateTime adShuffleDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(milliseconds: 500), (timer) {
      loadCategoryIndices();
      setState(() {});
    });
    getQuiz();
    _controller = VideoPlayerController.asset(
      'assets/videos/count.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);
    _controller.seekTo(Duration());
    _initializeVideoPlayerFuture.then((value) {
      _controller.removeListener(onCountDownEnd);
      _controller.addListener(onCountDownEnd);
    });

    //Initialize Category Locks
    categoryLock = [false, false, false, true, true, true];
    Preferences.getString(Preferences.pfKStreakCategoryLock).then((value) {
      if (value != null && value != "") {
        categoryLock = List<bool>.from(json.decode(value).map((x) => x));
        setState(() {});
      }
    });
    Preferences.getString(Preferences.pfKStreakADShuffleCount).then((value) {
      Preferences.getString(Preferences.pfKStreakADShuffleDate)
          .then((valueDate) async {
        if (value != null && value != "") {
          adShuffleCount = int.parse(value);
        } else {
          adShuffleCount = 3;
        }
        if (valueDate != null && valueDate != "") {
          adShuffleDate = DateTime.parse(valueDate);
        }
        var today = DateTime.now();
        if (today.day == adShuffleDate.day &&
            today.month == adShuffleDate.month &&
            today.year == adShuffleDate.year) {
        } else {
          adShuffleCount = 3;
          await Preferences.setString(
              Preferences.pfKStreakADShuffleCount, adShuffleCount.toString());
          await Preferences.setString(
              Preferences.pfKStreakADShuffleDate, today.toIso8601String());
        }

        setState(() {});
      });
    });
    Preferences.getString(Preferences.pfKStreakCategorySecondRow).then((value) {
      Preferences.getString(Preferences.pfKStreakCategorySecondRowDate)
          .then((valueD) {
        DateTime secondRowDate = DateTime.now();
        if (valueD != null && valueD != "")
          secondRowDate = DateTime.parse(valueD);
        Duration diff = DateTime.now().difference(secondRowDate);
        if (value != null && value != "" && diff.inDays < 30) {
          isSecondRowEnabled = json.decode(value);
          setState(() {});
        }
      });
    });

    InAppPurchaseConnection.enablePendingPurchases();
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>;
    initStoreInfo();
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError? error) {
    setState(() {
      _purchasePending = false;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> whenPurchaseComplete(String productID) async {
    if (productID == _kConsumableIdNoAds) {
      await Preferences.setString(
        Preferences.pfKConsumableIdNoads,
        productID,
      );
    } else if (productID == _kConsumableIdReshuffleCategory) {
      reselectIndices();
      setState(() {});
    } else if (productID == _kConsumableIdUnlockCategorySingle) {
      categoryLock[unlockPosition!] = false;
      await Preferences.setString(
          Preferences.pfKStreakCategoryLock, json.encode(categoryLock));
      setState(() {});
    } else if (productID == _kConsumableIdUnlockCategoryRow) {
      isSecondRowEnabled = true;
      await Preferences.setString(Preferences.pfKStreakCategorySecondRow,
          json.encode(isSecondRowEnabled));
      await Preferences.setString(Preferences.pfKStreakCategorySecondRowDate,
          DateTime.now().toIso8601String());
      setState(() {});
    }
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
//COMPLETE PURCHASE

            whenPurchaseComplete(purchaseDetails.productID);
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume &&
              purchaseDetails.productID == _kConsumableIdNoAds) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  void showPurchaseMenu(BuildContext context, int? count) {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5.0,
      backgroundColor: transparentColor,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(unitHeightValue * 20.0),
              topRight: Radius.circular(unitHeightValue * 20.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(unitHeightValue * 12.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildProductList(count!)],
            ),
          ),
        );
      },
    );
  }

  Card _buildProductList(int count) {
    List<ProductDetails> _selectedProducts = [];
    print(_products);
    if (_products.length > count) {
      ProductDetails proDetails = _products[count];
      _selectedProducts.add(proDetails);
    }

    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...'))));
    }
    if (!_isAvailable) {
      return Card();
    }
    List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('Product ID [${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text(
              'You have to add in-app purchase products in appstoreconnect.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verity the purchase data.
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_selectedProducts.map(
      (ProductDetails productDetails) {
        PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
              style: TextStyle(
                fontSize: unitHeightValue * 24,
              ),
            ),
            subtitle: Text(
              productDetails.description,
              style: TextStyle(
                fontSize: unitHeightValue * 24,
              ),
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : FlatButton(
                    child: Text(
                      productDetails.price,
                      style: TextStyle(
                        fontSize: unitHeightValue * 24,
                      ),
                    ),
                    color: Colors.green[800],
                    textColor: Colors.white,
                    onPressed: () {
                      PurchaseParam purchaseParam = PurchaseParam(
                          productDetails: productDetails,
                          applicationUserName: null,
                          sandboxTesting: true);
                      if (productDetails.id == _kConsumableIdNoAds) {
                        _connection.buyConsumable(
                            purchaseParam: purchaseParam,
                            autoConsume: kAutoConsume || Platform.isIOS);
                      } else {
                        _connection.buyNonConsumable(
                            purchaseParam: purchaseParam);
                      }
                    },
                  ));
      },
    ));

    return Card(
        margin: EdgeInsets.only(
            left: unitWidthValue * 10,
            right: unitWidthValue * 10,
            bottom: unitHeightValue * 20.0),
        child: Column(children: <Widget>[Divider()] + productList));
  }

  Future<void> initStoreInfo() async {
    try {
      final bool isAvailable = await _connection.isAvailable();
      if (!isAvailable) {
        setState(() {
          _isAvailable = isAvailable;
          _products = [];
          _purchases = [];
          _notFoundIds = [];
          _consumables = [];
          _purchasePending = false;
          _loading = false;
        });
        return;
      }

      ProductDetailsResponse productDetailResponse =
          await _connection.queryProductDetails(_kProductIds.toSet());
      if (productDetailResponse.error != null) {
        setState(() {
          _queryProductError = productDetailResponse.error!.message;
          _isAvailable = isAvailable;
          _products = productDetailResponse.productDetails;
          _purchases = [];
          _notFoundIds = productDetailResponse.notFoundIDs;
          _consumables = [];
          _purchasePending = false;
          _loading = false;
        });
        print(productDetailResponse.error!.message);
        return;
      }

      print(_products);

      if (productDetailResponse.productDetails.isEmpty) {
        setState(() {
          _queryProductError = null;
          _isAvailable = isAvailable;
          _products = productDetailResponse.productDetails;
          _purchases = [];
          _notFoundIds = productDetailResponse.notFoundIDs;
          _consumables = [];
          _purchasePending = false;
          _loading = false;
        });
        return;
      }

      final QueryPurchaseDetailsResponse purchaseResponse =
          await _connection.queryPastPurchases();
      if (purchaseResponse.error != null) {
        // handle query past purchase error..
      }
      final List<PurchaseDetails> verifiedPurchases = [];
      for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
        if (await _verifyPurchase(purchase)) {
          verifiedPurchases.add(purchase);
        }
      }
      List<String?> consumables = await ConsumableStore.load();
      setState(() {
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = verifiedPurchases;
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = consumables;
        _purchasePending = false;
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
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
        _playVideo
            ? Align(
                alignment: Alignment.center,
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the video.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            : Container()
      ],
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(unitHeightValue * 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              sizedBoxAddMob(unitHeightValue * 42.0),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                  Widget>[
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
                      borderRadius: BorderRadius.circular(29.5),
                    ),
                  ),
                ),
                SizedBox(
                  width: unitWidthValue * 5,
                ),
                Expanded(
                  child: Container(
                    // width: unitWidthValue * double.infinity,
                    padding: EdgeInsets.all(unitHeightValue * 8.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius:
                          BorderRadius.circular(unitHeightValue * 15.0),
                    ),
                    child: Text(
                      "TRIVIA STREAK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: unitHeightValue * 26.0,
                          color: whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: unitWidthValue * 5,
                ),
                SizedBox(
                  height: unitHeightValue * 45.0,
                  width: unitWidthValue * 100,
                  child: RaisedButton(
                    child: Text(
                      "RULES",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: unitHeightValue * 20),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => StreakRulesDialog(),
                      );
                    },
                    padding: EdgeInsets.all(0),
                    color: blackColor,
                    textColor: blackColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: greenColor, width: unitWidthValue * 2.0),
                      borderRadius: BorderRadius.circular(unitHeightValue * 10),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 30),
              _titleView(),
              SizedBox(height: 10),
              _categoryResetTimerView(),
              _gridView(),
              SizedBox(height: 10),
              _reshuffleView(),
              SizedBox(height: 10),
              _unlock30DaysView(),
              SizedBox(height: 10),
              _noAdsView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reshuffleView() {
    return Container(
      child: Row(
        children: [
          InkWell(
            child: Container(
              child: Text(
                "RE-SHUFFLE (WATCH AD)\n($adShuffleCount REMAINING TODAY)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: unitWidthValue * 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: greenColor, width: unitWidthValue * 3),
                borderRadius: BorderRadius.circular(unitWidthValue * 10),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: unitWidthValue * 10,
                  vertical: unitHeightValue * 4),
            ),
            onTap: reshuffleByAd,
          ),
          InkWell(
            child: Container(
              child: Text(
                "RE-SHUFFLE\n(.99 CENTS)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: unitWidthValue * 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: greenColor, width: unitWidthValue * 3),
                borderRadius: BorderRadius.circular(unitWidthValue * 10),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: unitWidthValue * 10,
                  vertical: unitHeightValue * 4),
            ),
            onTap: reshuffleByCents,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      width: unitWidthValue * 420,
    );
  }

  Widget _unlock30DaysView() {
    return InkWell(
      child: Stack(
        children: [
          Align(
            child: Container(
              child: Text(
                "DOUBLE YOUR CHANCES!!!\nUNLOCK ALL THREE EXTRA CATEGORIES\nFOR THE NEXT 30 DAYS !!!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: unitWidthValue * 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: greenColor, width: unitWidthValue * 3),
                borderRadius: BorderRadius.circular(unitWidthValue * 10),
                color: Colors.white,
              ),
              width: unitWidthValue * 420,
              height: unitHeightValue * 120,
            ),
          ),
          Align(
            child: Container(
              child: Text(
                "BUY NOW FOR ONLY \$9.99!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: unitWidthValue * 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                color: greenColor,
                border: Border.all(
                  color: Colors.black,
                  width: unitWidthValue * 3,
                ),
                borderRadius: BorderRadius.circular(unitWidthValue * 10),
              ),
              margin: EdgeInsets.only(top: unitHeightValue * 95),
              padding: EdgeInsets.symmetric(horizontal: unitWidthValue * 10),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
      onTap: unlockSecondRow,
    );
  }

  Widget _noAdsView() {
    return InkWell(
      child: Stack(
        children: [
          Align(
            child: Container(
              child: Text(
                "ENJOY OUR AD FREE VERSION!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: unitWidthValue * 27,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: greenColor, width: unitWidthValue * 3),
                borderRadius: BorderRadius.circular(unitWidthValue * 10),
                color: Colors.white,
              ),
              width: unitWidthValue * 420,
              height: unitHeightValue * 70,
            ),
          ),
          Align(
            child: Container(
              child: Text(
                "ONLY \$3.99 A MONTH!!!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: unitWidthValue * 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                color: greenColor,
                border: Border.all(
                  color: Colors.black,
                  width: unitWidthValue * 3,
                ),
                borderRadius: BorderRadius.circular(unitWidthValue * 10),
              ),
              margin: EdgeInsets.only(top: unitHeightValue * 45),
              padding: EdgeInsets.symmetric(horizontal: unitWidthValue * 10),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
      onTap: buyNoAds,
    );
  }

  Widget _titleView() {
    return Text(
      "CHOOSE A CATEGORY!",
      style: TextStyle(
        color: Colors.white,
        fontSize: unitWidthValue * 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _categoryResetTimerView() {
    Duration diff = DateTime.now().difference(categoryTime ?? DateTime.now());
    int remain = CATEGORY_RESET_DURATION - diff.inSeconds;
    int min = (remain / 60).floor();
    int sec = remain % 60;
    String timer =
        DateFormat("mm:ss").format(new DateTime(2000, 1, 1, 0, min, sec));
    return Row(
      children: [
        Container(
            height: unitHeightValue * 3,
            width: unitWidthValue * 80,
            color: Colors.white),
        Container(
          child: Text(
            "CATEGORIES RESET IN $timer",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: unitHeightValue * 20),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(unitWidthValue * 15),
            border: Border.all(color: Colors.white, width: unitWidthValue * 2),
            color: greenColor,
          ),
          padding: EdgeInsets.fromLTRB(unitWidthValue * 15, unitWidthValue * 5,
              unitWidthValue * 15, unitWidthValue * 5),
          width: unitWidthValue * 270,
        ),
        Container(
            height: unitHeightValue * 3,
            width: unitWidthValue * 80,
            color: Colors.white),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _gridView() {
    if (categoryIndices.length < 6) return Container();
    if (quiz == null) return Container();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 3),
      itemCount: 6,
      itemBuilder: (BuildContext context, int position) {
        Quiz _quiz = quiz![categoryIndices[position]];
        bool isLocked = position > 2;
        if (isSecondRowEnabled) isLocked = false;
        if (categoryLock[position] == false) isLocked = false;
        return Container(
          padding: EdgeInsets.all(unitHeightValue * 5.0),
          child: InkWell(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0.0),
                  margin:
                      EdgeInsets.symmetric(vertical: unitHeightValue * 10.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: unitWidthValue * 1.5,
                    ),
                    borderRadius: BorderRadius.circular(unitHeightValue * 29.5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(unitHeightValue * 16.0),
                      border: Border.all(
                        color: whiteColor,
                        width: unitWidthValue * 1.5,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          UrlQuizImageJackpotTriviaPrefixUrl +
                              _quiz.photoThumb!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                isLocked
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/lock.png",
                                width: unitWidthValue * 100,
                              ),
                              Container(
                                child: Text(
                                  "\$0.99",
                                  style: TextStyle(
                                    color: greenColor,
                                    fontSize: unitWidthValue * 20,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      unitWidthValue * 10),
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: unitWidthValue * 5),
                                transform: Matrix4.translationValues(
                                    0.0, -5.0 * unitWidthValue, 0.0),
                              )
                            ],
                            alignment: Alignment.center,
                          ),
                          transform: Matrix4.translationValues(
                              -15.0 * unitWidthValue, 0.0, 0.0),
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: unitWidthValue * double.infinity,
                    padding: EdgeInsets.all(unitHeightValue * 2),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: Colors.white,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(unitHeightValue * 20),
                    ),
                    child: AutoSizeText(
                      _quiz.title!.toUpperCase(),
                      textAlign: TextAlign.center,
                      minFontSize: 8,
                      maxLines: 1,
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: unitHeightValue * 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              if (isLocked) {
                unlockSingleCategory(position);
              } else {
                lockSingleCategory(position);
                _controller.play();
                setState(() {
                  _isLoading = true;
                  _playVideo = true;
                  selectedQuiz = _quiz;
                  reselectIndices();
                });
              }
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
        quiz = value;
        loadCategoryIndices();
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  void loadCategoryIndices() {
    Preferences.getString(Preferences.pfKStreakCategories).then((value) {
      Preferences.getString(Preferences.pfKStreakCategoriesTime)
          .then((timevalue) {
        if (timevalue != null && timevalue != "") {
          categoryTime = DateTime.parse(timevalue);
        } else {
          categoryTime = DateTime.now();
        }
        Duration diff = DateTime.now().difference(categoryTime!);
        if (value != null &&
            value != "" &&
            diff.inSeconds < CATEGORY_RESET_DURATION) {
          dynamic categories = json.decode(value);
          if (categories.length == 0)
            reselectIndices();
          else {
            categoryIndices.clear();
            for (int category in categories) {
              categoryIndices.add(category);
            }
          }
        } else {
          reselectIndices();
        }
      });
    });
  }

  void reselectIndices() async {
    int quizCount = quiz?.length ?? 0;
    var selectedList = List<int>.generate(quizCount, (i) => i)..shuffle();
    selectedList = selectedList.take(6).toList();
    categoryIndices = selectedList;
    categoryTime = DateTime.now();
    await Preferences.setString(
        Preferences.pfKStreakCategories, json.encode(categoryIndices));
    await Preferences.setString(
        Preferences.pfKStreakCategoriesTime, categoryTime!.toIso8601String());
  }

  void onCountDownEnd() {
    if (_controller.value.duration == _controller.value.position &&
        this._playVideo) {
      this._playVideo = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuestionsScreen(selectedQuiz!, true, widget.score),
        ),
      ).then((value) {
        setState(() {
          _isLoading = false;
          _controller.seekTo(Duration());
        });
      });
    }
  }

  void unlockSecondRow() async {
    showPurchaseMenu(context, 2);
  }

  void unlockSingleCategory(int position) async {
    unlockPosition = position;
    showPurchaseMenu(context, 3);
  }

  void lockSingleCategory(int position) async {
    categoryLock[position] = true;
    await Preferences.setString(
        Preferences.pfKStreakCategoryLock, json.encode(categoryLock));
    setState(() {});
  }

  void reshuffleByAd() async {
    var today = DateTime.now();
    if (today.day == adShuffleDate.day &&
        today.month == adShuffleDate.month &&
        today.year == adShuffleDate.year) {
      if (adShuffleCount == 0) return;
      adShuffleCount--;
      await Preferences.setString(
          Preferences.pfKStreakADShuffleCount, adShuffleCount.toString());
      await Preferences.setString(
          Preferences.pfKStreakADShuffleDate, today.toIso8601String());
    } else {
      adShuffleCount = 2;
      await Preferences.setString(
          Preferences.pfKStreakADShuffleCount, adShuffleCount.toString());
      await Preferences.setString(
          Preferences.pfKStreakADShuffleDate, today.toIso8601String());
    }
    AdMobClass.showRewardAdd(
      afterVideoEnd: () {
        reselectIndices();
        setState(() {});
      },
      isSpin: true,
    );
    setState(() {});
  }

  void reshuffleByCents() async {
    showPurchaseMenu(context, 1);
  }

  void buyNoAds() {
    showPurchaseMenu(context, 0);
  }
}
