import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final List<String> productIds = [
    "basic_plan",
    "pro_plan",
    "elite_plan",
  ];

  Future<List<ProductDetails>> getProducts() async {
    final response = await _iap.queryProductDetails(productIds.toSet());

    print("Found products: ${response.productDetails.length}");

    print("Not found: ${response.notFoundIDs}");

    return response.productDetails;
  }

  void listenPurchase({required Function(PurchaseDetails) onSuccess}) {
    _subscription = _iap.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        switch (purchase.status) {
          case PurchaseStatus.purchased:
            onSuccess(purchase);
            break;

          case PurchaseStatus.pending:
            print("Purchase pending");

            break;

          case PurchaseStatus.error:
            print(purchase.error);

            break;

          case PurchaseStatus.restored:
            onSuccess(purchase);

            break;

          case PurchaseStatus.canceled:
            print("User cancelled");

            break;
        }
      }
    });
  }

  Future<void> buySubscription(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
