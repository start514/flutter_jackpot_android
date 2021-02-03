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
import 'package:flutterjackpot/main.dart';
import 'home/home_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_signup_model.dart';
import 'dart:convert';

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
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  List<String> _notFoundIds = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

  String bomb = "1";
  String heart = "2";
  String time = "3";
  String player = "4";

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
    });
    initStoreInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  SendSpinRewardController controller, Widget child) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sizedBoxAddMob(70.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 30),
                  child: Container(
                    height: 40.0,
                    width: 65.0,
                    padding: EdgeInsets.only(bottom: 0.0),
                    margin: EdgeInsets.only(bottom: 0.0),
                    decoration: BoxDecoration(
                      color: greenColor,
                      border: Border.all(
                        color: blackColor,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: blackColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                "Increase your chances!",
                style: TextStyle(
                    color: greenColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 70,
              padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 0.0),
              decoration: BoxDecoration(
                color: blackColor,
                border: Border.all(
                  color: greenColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                "Power ups / VIP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _roundedCard(title: "x 2", price: "\$ .99", count: 2),
                _roundedCard(title: "x 5", price: "\$ 1.99", count: 4),
                _roundedCard(title: "x 8", price: "\$ 2.99", count: 3),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            noAdds(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              child: layoutBuilderDot(whiteColor),
            ),
            _noAds(),
            //_buildProductList(0)
          ],
        ),
      ),
    );
  }

  Widget _roundedCard({String title, String price, int count}) {
    return InkWell(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 130.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: blackColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(27.0),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      "assets/bomb.png",
                      height: 25.0,
                      width: 25.0,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Image.asset(
                      "assets/player2.png",
                      height: 25.0,
                      width: 25.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  decoration: new BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: greenColor,
                      width: 1.0,
                    ),
                    borderRadius:
                        new BorderRadius.all(Radius.elliptical(100, 50)),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: greenColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      "assets/clock.png",
                      height: 23.0,
                      width: 23.0,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Image.asset(
                      "assets/red_heart.png",
                      height: 30.0,
                      width: 30.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 95.0,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: greenColor,
              border: Border.all(
                color: blackColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: AutoSizeText(
              price,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
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
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Align(
              child: Container(
                margin: EdgeInsets.only(top: 0.0),
                height: 100.0,
                decoration: BoxDecoration(
                  color: blackColor,
                  border: Border.all(
                    color: whiteColor,
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 0.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                    child: Text(
                      "NO ADS!!",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0, bottom: 8.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                    child: Text(
                      "Enjoy our game with ad free experience",
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 122.0,
                      padding: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: blackColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: AutoSizeText(
                        "\$ 3.99 / month",
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
          ],
        ),
      ),
      onTap: () {
        showPurchaseMenu(context, 1);
      },
    );
  }

  Widget _noAds() {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Align(
              child: Container(
                margin: EdgeInsets.only(top: 11.0),
                height: 102.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: greenColor,
                  border: Border.all(
                    color: blackColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(27.0),
                ),
              ),
            ),
            Align(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    decoration: new BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: 2.5,
                      ),
                      borderRadius:
                          new BorderRadius.all(Radius.elliptical(100, 50)),
                    ),
                    child: Text(
                      "X 15",
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        "assets/bomb.png",
                        height: 40.0,
                        width: 40.0,
                      ),
                      Image.asset(
                        "assets/clock.png",
                        height: 40.0,
                        width: 40.0,
                      ),
                      Image.asset(
                        "assets/player2.png",
                        height: 40.0,
                        width: 40.0,
                      ),
                      Image.asset(
                        "assets/red_heart.png",
                        height: 42.0,
                        width: 42.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
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
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
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
              'You have to add in-app purchase products in appstoreconnect.'),
          trailing: FlatButton(
            child: Text("TestBuy"),
            color: Colors.green[800],
            textColor: Colors.white,
            onPressed: () {
              PurchaseDetails purchaseDetails = new PurchaseDetails(
                purchaseID: "",
                productID: _kConsumableId,
                verificationData: null,
                transactionDate: "",
                skPaymentTransaction: null,
                billingClientPurchase: null,
              );
              whenPurchaseComplete(purchaseDetails);
              refreshMainWidget();
            },
          )));
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
        PurchaseDetails previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : FlatButton(
                    child: Text(productDetails.price),
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
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
          _queryProductError = productDetailResponse.error.message;
          _isAvailable = isAvailable;
          _products = productDetailResponse.productDetails;
          _purchases = [];
          _notFoundIds = productDetailResponse.notFoundIDs;
          _consumables = [];
          _purchasePending = false;
          _loading = false;
        });
        print(productDetailResponse.error.message);
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
      List<String> consumables = await ConsumableStore.load();
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
      List<String> consumables = await ConsumableStore.load();
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

    refreshMainWidget();
  }

  void refreshMainWidget() {
    Preferences.getString(Preferences.pfUserLogin).then((value) {
      if (value != null) {
        LoginSignUpModel model = LoginSignUpModel.fromJson(
          json.decode(value),
        );
        LoginSpinDetails spinDetailsNew = model.userRecord.loginSpinDetails;
        spinDetails.id = spinDetailsNew.id;
        spinDetails.userId = spinDetailsNew.userId;
        spinDetails.theBomb = spinDetailsNew.theBomb;
        spinDetails.theHeart = spinDetailsNew.theHeart;
        spinDetails.theTime = spinDetailsNew.theTime;
        spinDetails.thePlayer = spinDetailsNew.thePlayer;
        spinDetails.createdAt = spinDetailsNew.createdAt;
        spinDetails.updatedAt = spinDetailsNew.updatedAt;
      }
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  void showPurchaseMenu(BuildContext context, int count) {
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
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductList(count)
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
                      width: 10.0,
                    ),
                    Text(
                      "Triviastax App Purchase",
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "\$ 22.0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Text(
                  "This will vary from case to case, but laying out clear terms for your mobile app will limit your liabilities to users that may make claims against you.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "By tapping \"BUY\", you agree the App Terms & Condition.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Google Play",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
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
      {String item, String count}) async {
    await sendSpinRewardController.sendSpinRewardAPI(item: item, count: count);
  }

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (route) => false);
  }
}
