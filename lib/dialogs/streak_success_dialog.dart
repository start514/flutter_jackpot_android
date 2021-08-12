import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/consumable_store.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_triva_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/submit_quiz_model.dart';
import 'package:flutterjackpot/view/trivia_streak/submit_streak_model.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_category_screen.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_controller.dart';
import 'package:flutterjackpot/view/trivia_streak/trivia_streak_screen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const bool kAutoConsume = true;
String _kConsumableIdContinueStreak = 'com.triviastax.continuestreak';
String _kConsumableIdNoAds =
    Platform.isIOS ? 'com.triviastax.noads1' : 'com.triviastax.noads';
List<String> _kProductIds = <String>[
  _kConsumableIdContinueStreak,
  _kConsumableIdNoAds,
];

class StreakSuccessDialog extends StatefulWidget {
  final SubmitStreakResponse? result;

  StreakSuccessDialog({this.result});

  @override
  _StreakSuccessDialogState createState() => _StreakSuccessDialogState();
}

class _StreakSuccessDialogState extends State<StreakSuccessDialog> {
  double unitHeightValue = 1;
  double unitWidthValue = 1;
  late bool isFailed;
  TriviaStreakController api = TriviaStreakController();

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

  @override
  void initState() {
    super.initState();
    setState(() {
      isFailed = widget.result!.score == 0;
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
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  Future<void> whenPurchaseComplete(String productID) async {
    if (productID == _kConsumableIdContinueStreak) {
      api
          .continueStreak(userRecord!.userID, widget.result!.originalScore!)
          .then((value) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TriviaStreakScreen(),
          ),
        );
      });
    } else if (productID == _kConsumableIdNoAds) {
      await Preferences.setString(
        Preferences.pfKConsumableIdNoads,
        productID,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        height: unitHeightValue * double.infinity,
        width: unitWidthValue * double.infinity,
        margin: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: unitHeightValue * 42,
                ),
                Stack(
                  children: [
                    isFailed
                        ? Container()
                        : Align(
                            child: Container(
                              child: AutoSizeText(
                                "RANKING - ${widget.result!.rank}",
                                style: TextStyle(
                                  fontSize: unitWidthValue * 40,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              width: unitWidthValue * 280,
                              height: unitHeightValue * 70,
                              margin:
                                  EdgeInsets.only(top: unitHeightValue * 400),
                              padding: EdgeInsets.fromLTRB(
                                unitWidthValue * 10,
                                unitWidthValue * 10,
                                unitWidthValue * 10,
                                0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: greenColor,
                                    width: unitWidthValue * 4),
                                borderRadius:
                                    BorderRadius.circular(unitWidthValue * 12),
                              ),
                            ),
                          ),
                    Container(
                      // width: unitWidthValue * double.infinity,
                      padding: EdgeInsets.fromLTRB(
                          0, unitHeightValue * 8.0, 0, unitWidthValue * 8.0),
                      decoration: BoxDecoration(
                        color: blackColor,
                        border: Border.all(
                          color: Colors.white,
                          width: unitWidthValue * 3,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isFailed ? "WRONG ANSWER" : "CORRECT ANSWER!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: unitHeightValue * 50.0,
                                color: isFailed ? Colors.red : greenColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: unitHeightValue * 10),
                          Container(
                            height: unitHeightValue * 3,
                            color: Colors.white,
                          ),
                          SizedBox(height: unitHeightValue * 20),
                          Text(
                            isFailed
                                ? "YOUR STREAK IS OVER"
                                : "YOUR STREAK IS NOW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: unitHeightValue * 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: unitHeightValue * 10),
                          Container(
                            child: AutoSizeText(
                              "${widget.result!.score}",
                              style: TextStyle(
                                color: isFailed ? Colors.red : greenColor,
                                fontSize: unitWidthValue * 80,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isFailed ? Colors.red : greenColor,
                                width: unitWidthValue * 3,
                              ),
                              borderRadius:
                                  BorderRadius.circular(unitWidthValue * 12),
                            ),
                            padding: EdgeInsets.all(unitWidthValue * 10),
                            width: unitWidthValue * 120,
                            height: unitWidthValue * 120,
                          ),
                          SizedBox(height: unitHeightValue * 20),
                          Container(
                            padding: EdgeInsets.only(left: 18, right: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _roundedButtons(
                                  title: "HOME",
                                  color: Colors.black,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TriviaStreakScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _roundedButtons(
                                  title: isFailed ? "RESTART" : "CONTINUE",
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TriviaStreakCategoryScreen(
                                          score: widget.result!.originalScore,
                                          // quiz: widget.quiz,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                isFailed
                    ? InkWell(
                        child: Container(
                          child: Stack(
                            children: [
                              Align(
                                child: Container(
                                  child: AutoSizeText(
                                    "ERASES THE WRONG ANSWER AND CONTINUES YOUR STREAK!",
                                    style: TextStyle(
                                      fontSize: unitWidthValue * 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  width: unitWidthValue * 420,
                                  height: unitHeightValue * 100,
                                  padding: EdgeInsets.fromLTRB(
                                    unitWidthValue * 5,
                                    unitWidthValue * 10,
                                    unitWidthValue * 5,
                                    0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: greenColor,
                                        width: unitWidthValue * 4),
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 12),
                                  ),
                                ),
                              ),
                              Align(
                                child: Container(
                                  child: AutoSizeText(
                                    "~ CONTINUE YOUR STREAK ~",
                                    style: TextStyle(
                                      fontSize: unitWidthValue * 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  width: unitWidthValue * 350,
                                  height: unitHeightValue * 50,
                                  padding: EdgeInsets.fromLTRB(
                                    unitWidthValue * 5,
                                    unitWidthValue * 5,
                                    unitWidthValue * 5,
                                    0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: greenColor,
                                    border: Border.all(
                                        color: Colors.black,
                                        width: unitWidthValue * 3),
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 12),
                                  ),
                                  transform: Matrix4.translationValues(
                                      0, -unitHeightValue * 40, 0),
                                ),
                              ),
                              Align(
                                child: Container(
                                  child: AutoSizeText(
                                    "ONLY \$0.99 CENTS",
                                    style: TextStyle(
                                      fontSize: unitWidthValue * 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  width: unitWidthValue * 250,
                                  height: unitHeightValue * 50,
                                  padding: EdgeInsets.fromLTRB(
                                    unitWidthValue * 5,
                                    unitWidthValue * 5,
                                    unitWidthValue * 5,
                                    0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: greenColor,
                                    border: Border.all(
                                        color: Colors.black,
                                        width: unitWidthValue * 3),
                                    borderRadius: BorderRadius.circular(
                                        unitWidthValue * 12),
                                  ),
                                  transform: Matrix4.translationValues(
                                      0, unitHeightValue * 90, 0),
                                ),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.fromLTRB(
                              0,
                              isFailed
                                  ? unitHeightValue * 60
                                  : unitHeightValue * 30,
                              0,
                              unitHeightValue * 70),
                        ),
                        onTap: onContinueStreak,
                      )
                    : Container(),
                InkWell(
                  child: Container(
                    child: Column(
                      children: [
                        Align(
                          child: Container(
                            child: AutoSizeText(
                              "ENJOY OUR AD FREE VERSION!",
                              style: TextStyle(
                                fontSize: unitWidthValue * 40,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            width: unitWidthValue * 400,
                            height: unitHeightValue * 70,
                            padding: EdgeInsets.fromLTRB(
                              unitWidthValue * 5,
                              unitWidthValue * 10,
                              unitWidthValue * 5,
                              0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: greenColor, width: unitWidthValue * 4),
                              borderRadius:
                                  BorderRadius.circular(unitWidthValue * 12),
                            ),
                          ),
                        ),
                        Align(
                          child: Container(
                            child: AutoSizeText(
                              "ONLY \$3.99 A MONTH!!!",
                              style: TextStyle(
                                fontSize: unitWidthValue * 40,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            width: unitWidthValue * 350,
                            height: unitHeightValue * 70,
                            padding: EdgeInsets.fromLTRB(
                              unitWidthValue * 5,
                              unitWidthValue * 10,
                              unitWidthValue * 5,
                              0,
                            ),
                            decoration: BoxDecoration(
                              color: greenColor,
                              border: Border.all(
                                  color: Colors.black,
                                  width: unitWidthValue * 3),
                              borderRadius:
                                  BorderRadius.circular(unitWidthValue * 12),
                            ),
                            transform: Matrix4.translationValues(
                                0, -unitHeightValue * 10, 0),
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.fromLTRB(0, unitHeightValue * 30, 0, 0),
                  ),
                  onTap: buyNoAds,
                ),
                isFailed
                    ? Container()
                    : Container(
                        child: Column(
                          children: [
                            Text(
                              "CAN YOU WIN THE CASH?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: unitWidthValue * 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              "assets/money_white.jpeg",
                              width: unitWidthValue * 350,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(top: unitHeightValue * 20),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundedButtons({required String title, Color? color, void onTap()?}) {
    return InkWell(
      child: Container(
        width: unitWidthValue * 180,
        height: unitHeightValue * 80,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: color != null ? color : greenColor,
          border: Border.all(
            color: whiteColor,
            width: unitWidthValue * 3,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          child: AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color != null ? Colors.white : blackColor,
              fontSize: unitHeightValue * 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  void onContinueStreak() {
    showPurchaseMenu(context, 0);
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

                      _connection.buyNonConsumable(
                          purchaseParam: purchaseParam);
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

  void buyNoAds() {
    showPurchaseMenu(context, 1);
  }
}
