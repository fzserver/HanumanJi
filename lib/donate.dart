import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final String inAppId = 'donate1';

class Donate extends StatefulWidget {
  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  /// In App Purchase Instance
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Is the API available on this device
  bool _available = true;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past Purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  void _initialize() async {
    /// Check availability of the In App Purchases
    _available = await _iap.isAvailable();

    if (_available) {
      // await _getProducts();
      // await _getPastPurchases();

      List<Future> futures = [_getProducts(), _getPastPurchases()];
      await Future.wait(futures);

      _verifyPurchase();

      /// Listen to the new purchases
      _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
            print('NEW PURCHASE');
            _purchases.addAll(data);
            _verifyPurchase();
          }));
    } else {}
  }

  /// Validate Purchase

  /// Get all the products available for the sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from([inAppId]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
    });
  }

  /// Get the past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  /// Returns purchase of specific Product ID
  PurchaseDetails _hasPurchased(String productID) =>
      _purchases.firstWhere((purchase) => purchase.productID == productID,
          orElse: () => null);

  /// Your business logic to setup a consumable
  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(inAppId);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      // TODO
    }
  }

  /// Purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam); //* For One-Time Purchase
    _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true); //* For Everytime Purchase
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.deepOrange,
        ),
        title: Text(
          'Donate',
          style: TextStyle(color: Colors.deepOrange),
        ),
        elevation: 1.0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var product in _products) ...[
              MaterialButton(
                onPressed: () => _buyProduct(product),
                child: Text('Donate \$1'),
                color: Colors.yellow,
                textColor: Colors.deepOrange,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
