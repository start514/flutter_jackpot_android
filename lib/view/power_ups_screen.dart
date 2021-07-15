import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/consumable_store.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/view/spinner/spinner_controller.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';

const bool kAutoConsume = true;
const String _kConsumableId = 'com.triviastax.elitepackage';
const String _kConsumableId_noads = 'com.triviastax.noads';
const String _kConsumableId_powerup_one = 'com.triviastax.powerupsone';
const String _kConsumableId_powerup_two = 'com.triviastax.powerupstwo';
const String _kConsumableId_powerup_three = 'com.triviastax.powerupsthree';
const List<String> _kProductIds = <String>[
  _kConsumableId_powerup_one,
  _kConsumableId_powerup_two,
  _kConsumableId_powerup_three,
  _kConsumableId_noads,
  _kConsumableId
];

class PowerUPSScreen extends StatefulWidget {
  @override
  _PowerUPSScreenState createState() => _PowerUPSScreenState();
}

class _PowerUPSScreenState extends State<PowerUPSScreen> {
  SendSpinRewardController sendSpinRewardController =
      new SendSpinRewardController();

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

  String bomb = "1";
  String heart = "2";
  String time = "3";
  String player = "4";
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
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
    super.initState();
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
          body: ChangeNotifierProvider<SendSpinRewardController>(
            create: (BuildContext context) {
              return sendSpinRewardController = new SendSpinRewardController();
            },
            child: new Consumer<SendSpinRewardController>(
              builder: (BuildContext context,
                  SendSpinRewardController controller, Widget? child) {
                if (sendSpinRewardController == null)
                  sendSpinRewardController = controller;

                switch (controller.getStatus) {
                  case Status.LOADING:
                    return controller.getLoader;
                  case Status.SUCCESS:
                    return _bodyWidget();
                  case Status.FAILED:
                    return _bodyWidget();
                    break;
                  case Status.IDLE:
                    break;
                }
                return _bodyWidget();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: unitWidthValue * 10, right: unitWidthValue * 10),
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
                      borderRadius:
                          BorderRadius.circular(unitHeightValue * 29.5),
                    ),
                  ),
                ),
                SizedBox(
                  width: unitWidthValue * 10,
                ),
                Expanded(
                    child: Container(
                  // width: unitWidthValue * double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: unitHeightValue * 2.0,
                      horizontal: unitWidthValue * 8.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: greenColor,
                      width: unitWidthValue * 2,
                    ),
                    borderRadius: BorderRadius.circular(unitHeightValue * 15.0),
                  ),
                  child: Text(
                    "NO ADS/POWER UPS",
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
            noAdds(),
            SizedBox(
              height: unitHeightValue * 10.0,
            ),
            powerUps(),
            SizedBox(
              height: unitHeightValue * 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _roundedCard(each: 2, price: "\$ 0.99", count: 2),
                _roundedCard(each: 5, price: "\$ 1.99", count: 4),
              ],
            ),
            SizedBox(
              height: unitHeightValue * 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _roundedCard(each: 8, price: "\$ 2.99", count: 3),
                _roundedCard(each: 15, price: "\$ 4.99", count: 0),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: unitHeightValue * 4.0,
                  horizontal: unitWidthValue * 12.0),
              // child: layoutBuilderDot(whiteColor),
            ),
            // _noAds(),
            //_buildProductList(0)
          ],
        ),
      ),
    );
  }

  Widget _roundedCard(
      {required int each, required String price, required int count}) {
    return InkWell(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: unitHeightValue * 120.0,
            width: unitWidthValue * 180.0,
            margin: EdgeInsets.only(bottom: unitHeightValue * 15),
            decoration: BoxDecoration(
              color: greenColor,
              border: Border.all(
                color: whiteColor,
                width: unitWidthValue * 3,
              ),
              borderRadius: BorderRadius.circular(unitHeightValue * 8.0),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: unitHeightValue * 5.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: unitHeightValue * 10.0,
                      horizontal: unitWidthValue * 5.0),
                  child: Text(
                    each.toString() + " OF EACH \n${each * 3} TOTAL",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: unitHeightValue * 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 5.0,
                ),
              ],
            ),
          ),
          Container(
            width: unitWidthValue * 95.0,
            padding: EdgeInsets.all(unitHeightValue * 2.0),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: blackColor,
                width: unitWidthValue * 2.5,
              ),
              borderRadius: BorderRadius.circular(unitHeightValue * 8.0),
            ),
            child: AutoSizeText(
              price,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: unitHeightValue * 24),
            ),
          ),
        ],
      ),
      onTap: () {
        showPurchaseMenu(context, count);
      },
    );
  }

  Widget noAdds() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(unitHeightValue * 12.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              child: Container(
                margin: EdgeInsets.only(top: unitHeightValue * 14.0),
                padding: EdgeInsets.only(top: unitHeightValue * 16),
                height: unitHeightValue * 130.0,
                width: unitWidthValue * double.infinity,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: greenColor,
                  border: Border.all(
                    color: blackColor,
                    width: unitWidthValue * 5,
                  ),
                  borderRadius: BorderRadius.circular(unitHeightValue * 16.0),
                ),
                child: Text(
                  "ENJOY TRIVIA STAX AD FREE!",
                  style: TextStyle(
                      fontSize: unitHeightValue * 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: unitWidthValue * 200.0,
                      padding: EdgeInsets.all(unitHeightValue * 7.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: blackColor,
                          width: unitWidthValue * 4,
                        ),
                        borderRadius:
                            BorderRadius.circular(unitHeightValue * 8.0),
                      ),
                      child: AutoSizeText(
                        "Only \$3.99 a month!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: unitHeightValue * 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: unitWidthValue * 100.0,
                    padding: EdgeInsets.all(unitHeightValue * 7.0),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: unitWidthValue * 4,
                      ),
                      borderRadius:
                          BorderRadius.circular(unitHeightValue * 8.0),
                    ),
                    child: AutoSizeText(
                      "BUY",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: unitHeightValue * 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        showPurchaseMenu(context, 1);
      },
    );
  }

  Widget powerUps() {
    return InkWell(
      child: Padding(
          padding: EdgeInsets.all(unitHeightValue * 12.0),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    "INCREASE YOUR CHANCES WITH\n POWER-UPS!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: unitHeightValue * 26,
                        fontWeight: FontWeight.bold,
                        color: whiteColor),
                  )),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.only(top: unitHeightValue * 14.0),
                        padding: EdgeInsets.only(top: unitHeightValue * 16),
                        height: unitHeightValue * 160.0,
                        width: unitWidthValue * double.infinity,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: unitWidthValue * 5,
                          ),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _detailButton(
                                text: "50/50",
                                image: "bomb.png",
                                size: 70), //spinDetails!.theBomb!
                            _detailButton(
                                text: "Correct\n1,000 pts",
                                image: "player2.png",
                                bottom: true,
                                fontSize: unitHeightValue * 28,
                                size: 70), //spinDetails!.thePlayer!,
                            _detailButton(
                                text: "+Time",
                                marginTop: unitHeightValue * 10,
                                image: "clock.png",
                                bottom: true,
                                size: 60), //spinDetails!.theTime!,
                          ],
                        ),
                      ),
                      onTap: () => {showPurchaseMenu(context, 1)},
                    ),
                  ),
                ],
              ),
            ],
          )),
      onTap: () {
        // showPurchaseMenu(context, 0);
      },
    );
  }

  Widget _noAds() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(unitHeightValue * 12.0),
        child: Stack(
          children: [
            Align(
              child: Container(
                margin: EdgeInsets.only(top: unitHeightValue * 11.0),
                height: unitHeightValue * 102.0,
                width: unitWidthValue * double.infinity,
                decoration: BoxDecoration(
                  color: greenColor,
                  border: Border.all(
                    color: blackColor,
                    width: unitWidthValue * 2,
                  ),
                  borderRadius: BorderRadius.circular(unitHeightValue * 27.0),
                ),
              ),
            ),
            Align(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: unitHeightValue * 10.0),
                    padding: EdgeInsets.symmetric(
                        vertical: unitHeightValue * 5.0,
                        horizontal: unitWidthValue * 20.0),
                    decoration: new BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: unitWidthValue * 2.5,
                      ),
                      borderRadius:
                          new BorderRadius.all(Radius.elliptical(100, 50)),
                    ),
                    child: Text(
                      "X 15",
                      style: TextStyle(
                        color: blackColor,
                        fontSize: unitHeightValue * 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: unitHeightValue * 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        "assets/bomb.png",
                        height: unitHeightValue * 40.0,
                        width: unitWidthValue * 40.0,
                      ),
                      Image.asset(
                        "assets/clock.png",
                        height: unitHeightValue * 40.0,
                        width: unitWidthValue * 40.0,
                      ),
                      Image.asset(
                        "assets/player2.png",
                        height: unitHeightValue * 40.0,
                        width: unitWidthValue * 40.0,
                      ),
                      Image.asset(
                        "assets/red_heart.png",
                        height: unitHeightValue * 42.0,
                        width: unitWidthValue * 42.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: unitHeightValue * 11.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: unitHeightValue * 5.0,
                            horizontal: unitWidthValue * 10.0),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: unitWidthValue * 2.5,
                          ),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 20.0),
                        ),
                        child: AutoSizeText(
                          "ELITE PACKAGE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: unitHeightValue * 5.0,
                            horizontal: unitWidthValue * 10.0),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: unitWidthValue * 2.5,
                          ),
                          borderRadius:
                              BorderRadius.circular(unitHeightValue * 20.0),
                        ),
                        child: AutoSizeText(
                          "\$ 4.99",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        showPurchaseMenu(context, 0);
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
    final ListTile productHeader = ListTile(title: Text(''));
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
                      if (productDetails.id == _kConsumableId) {
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

            whenPurchaseComplete(purchaseDetails);
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
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

  Future<void> whenPurchaseComplete(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == _kConsumableId) {
      await sendRewardWhenPurchaseComplete(
        item: bomb,
        count: "15",
      );
      await sendRewardWhenPurchaseComplete(
        item: heart,
        count: "15",
      );
      await sendRewardWhenPurchaseComplete(
        item: time,
        count: "15",
      );
      await sendRewardWhenPurchaseComplete(
        item: player,
        count: "15",
      );
      await Preferences.setString(
        Preferences.pfKConsumableId,
        purchaseDetails.productID,
      );
//      navigateToHomeScreen();
    } else if (purchaseDetails.productID == _kConsumableId_noads) {
      await sendRewardWhenPurchaseComplete(
        item: bomb,
        count: "10",
      );
      await Preferences.setString(
        Preferences.pfKConsumableIdNoads,
        purchaseDetails.productID,
      );
//      navigateToHomeScreen();
    } else if (purchaseDetails.productID == _kConsumableId_powerup_one) {
      await sendRewardWhenPurchaseComplete(
        item: bomb,
        count: "2",
      );
      await sendRewardWhenPurchaseComplete(
        item: heart,
        count: "2",
      );
      await sendRewardWhenPurchaseComplete(
        item: time,
        count: "2",
      );
      await sendRewardWhenPurchaseComplete(
        item: player,
        count: "2",
      );
      await Preferences.setString(
        Preferences.pfkConsumableIdPowerUpOne,
        purchaseDetails.productID,
      );
//      navigateToHomeScreen();
    } else if (purchaseDetails.productID == _kConsumableId_powerup_two) {
      await sendRewardWhenPurchaseComplete(
        item: bomb,
        count: "5",
      );
      await sendRewardWhenPurchaseComplete(
        item: heart,
        count: "5",
      );
      await sendRewardWhenPurchaseComplete(
        item: time,
        count: "5",
      );
      await sendRewardWhenPurchaseComplete(
        item: player,
        count: "5",
      );
      await Preferences.setString(
        Preferences.pfkConsumableIdPowerUpTwo,
        purchaseDetails.productID,
      );
//      navigateToHomeScreen();
    } else if (purchaseDetails.productID == _kConsumableId_powerup_three) {
      await sendRewardWhenPurchaseComplete(
        item: bomb,
        count: "8",
      );
      await sendRewardWhenPurchaseComplete(
        item: heart,
        count: "8",
      );
      await sendRewardWhenPurchaseComplete(
        item: time,
        count: "8",
      );
      await sendRewardWhenPurchaseComplete(
        item: player,
        count: "8",
      );
      await Preferences.setString(
        Preferences.pfkConsumableIdPowerUpThree,
        purchaseDetails.productID,
      );
//      navigateToHomeScreen();
    }
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String?> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError? error) {
    setState(() {
      _purchasePending = false;
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
              children: [
                _buildProductList(count!)
                /*Row(
                  children: [
                    ClipOval(
                      child: CircleAvatar(
                        maxRadius: 20.0,
                        minRadius: 20.0,
                        backgroundImage: AssetImage(
                          "assets/jackpot_app_icon.png",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: unitWidthValue * 10.0,
                    ),
                    Text(
                      "Triviastax App Purchase",
                      style: TextStyle(
                        color: blackColor,
                        fontSize: unitHeightValue * 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: unitHeightValue * 20.0),
                  child: Text(
                    "\$ 22.0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: unitHeightValue * 16.0,
                    ),
                  ),
                ),
                Text(
                  "This will vary from case to case, but laying out clear terms for your mobile app will limit your liabilities to users that may make claims against you.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                    fontSize: unitHeightValue * 16.0,
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                Text(
                  "By tapping \"BUY\", you agree the App Terms & Condition.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                    fontSize: unitHeightValue * 16.0,
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                Text(
                  "Google Play",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                    fontSize: unitHeightValue * 15.0,
                  ),
                ),
                SizedBox(
                  height: unitHeightValue * 20.0,
                ),
                Container(
                  width: unitWidthValue * double.infinity,
                  child: RaisedButton(
                    child: Text(
                      "BUY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.green,
                    textColor: whiteColor,
                    onPressed: () {},
                  ),
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendRewardWhenPurchaseComplete(
      {String? item, String? count}) async {
    // await sendSpinRewardController.sendSpinRewardAPI(item: item, count: count);
  }

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (route) => false);
  }

  Widget _detailButton(
      {String? image,
      required String text,
      required double size,
      double? fontSize,
      bool? bottom,
      double? marginTop,
      void onTap()?}) {
    size = unitHeightValue * size;
    if (fontSize == null) fontSize = 28.0;
    return InkWell(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(
                  top: unitHeightValue * (marginTop == null ? 0 : marginTop)),
              child: Image.asset(
                "assets/$image",
                height: size,
                width: size,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  top: unitHeightValue * (fontSize == 28.0 ? 10 : 0)),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: unitHeightValue * fontSize,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      // onTap: () {
      //   onTap!();
      // },
    );
  }
}
