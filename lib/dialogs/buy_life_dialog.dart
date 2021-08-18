import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/consumable_store.dart';
import 'package:flutterjackpot/utils/life_utils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const bool kAutoConsume = true;
String _kConsumableIdBuyLife = 'com.triviastax.streaklife';
List<String> _kProductIds = <String>[
  _kConsumableIdBuyLife,
];

class BuyLifeDialog extends StatefulWidget {
  BuyLifeDialog();

  @override
  _BuyLifeDialogState createState() => _BuyLifeDialogState();
}

class _BuyLifeDialogState extends State<BuyLifeDialog> {
  double unitHeightValue = 1;
  double unitWidthValue = 1;

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
    if (productID == _kConsumableIdBuyLife) {
      await LifeClass.restoreLife();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    const data =
        "YOU HAVE <span style='color: red;'>0</span> LIVES LEFT!<br>DON'T WAIT FOR NEW<br>LIVES! REFRESH NOW<br>FOR ONLY \$1.99 !!!";
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 220.0,
        margin: EdgeInsets.all(17.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Html(
                  data: "$data",
                  style: {
                    "html": Style(
                      textAlign: TextAlign.center,
                      color: blackColor,
                      fontSize: FontSize(16.0),
                      fontWeight: FontWeight.bold,
                    ),
                  },
                ),
                Row(
                  children: [
                    InkWell(
                      child: Container(child: Text("NO THANKS!")),
                      onTap: noThanks,
                    ),
                    InkWell(
                      child: Container(child: Text("BUY NOW!")),
                      onTap: buyLife,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void buyLife() {
    showPurchaseMenu(context, 0);
  }

  void noThanks() {
    Navigator.pop(context);
  }
}
