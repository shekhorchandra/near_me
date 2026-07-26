// import 'package:get/get.dart';
// import 'package:near_me/App/routes/app_routes.dart';
// import '../../../data/services/storage_service.dart';
// import '../services/billing_service.dart';
// import '../repository/subscription_repository.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
//
// class SubscriptionController extends GetxController {
//   final StorageService storageService = StorageService();
//   final BillingService billingService;
//
//   final SubscriptionRepository repository;
//
//   SubscriptionController({
//     required this.billingService,
//     required this.repository,
//   });
//
//   final RxList<ProductDetails> products = <ProductDetails>[].obs;
//
//   RxBool loading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     loadProducts();
//
//     billingService.listenPurchase(onSuccess: verifyPurchase);
//   }
//
//   Future<void> loadProducts() async {
//     loading.value = true;
//
//     try {
//       final result = await billingService.getProducts();
//
//       products.assignAll(result);
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   Future buy(ProductDetails product) async {
//     await billingService.buySubscription(product);
//   }
//
//   Future verifyPurchase(PurchaseDetails purchase) async {
//     try {
//
//       final token = purchase.verificationData.serverVerificationData;
//
//       final userId = StorageService().userId;
//
//       if (userId == null || userId.isEmpty) {
//         Get.snackbar(
//           "Error",
//           "User ID not found. Please login again",
//         );
//         return;
//       }
//
//       // ================= DEBUG PRINTS START =================
//       print("========================================");
//       print("PURCHASE DEBUG");
//       print("========================================");
//
//       print("USER ID => $userId");
//       print("PRODUCT ID => ${purchase.productID}");
//       print("PURCHASE STATUS => ${purchase.status}");
//       print("PENDING COMPLETE => ${purchase.pendingCompletePurchase}");
//
//       // Google Play specific token
//       print("PURCHASE TOKEN => $token");
//
//       // Raw verification data
//       print("SOURCE => ${purchase.verificationData.source}");
//       print("LOCAL DATA => ${purchase.verificationData.localVerificationData}");
//       print("SERVER DATA => ${purchase.verificationData.serverVerificationData}");
//
//       print("========================================");
//       // ================= DEBUG PRINTS END =================
//
//       await repository.verifyPurchase(
//         userId: userId,
//         productId: purchase.productID,
//         token: token,
//       );
//
//       if (purchase.pendingCompletePurchase) {
//         await InAppPurchase.instance.completePurchase(purchase);
//       }
//
//       Get.snackbar(
//         "Success",
//         "Subscription Activated",
//       );
//
//       // Navigate to Service Create page
//       Get.offAllNamed(AppRoutes.SERVICE_PROVIDER_ACCOUNT);
//
//     } catch (e) {
//
//       print("SUBSCRIPTION ERROR => $e");
//
//       Get.snackbar(
//         "Purchase Failed",
//         e.toString(),
//       );
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:near_me/App/routes/app_routes.dart';

import '../../../data/services/storage_service.dart';
import '../repository/subscription_repository.dart';
import '../services/billing_service.dart';

class SubscriptionController extends GetxController {
  final StorageService storageService = StorageService();
  final BillingService billingService;
  final SubscriptionRepository repository;

  final Rxn<Map<String, dynamic>> freePlan = Rxn<Map<String, dynamic>>();

  // Backend MongoDB plan information
  final RxString backendPlanId = ''.obs;
  final RxString backendPlanName = ''.obs;
  final RxDouble backendPlanPrice = 0.0.obs;

  // Free plan information
  final RxString freePlanId = ''.obs;
  final RxString freePlanName = 'Free Plan'.obs;
  final RxDouble freePlanPrice = 0.0.obs;

  SubscriptionController({
    required this.billingService,
    required this.repository,
  });

  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool loading = false.obs;

  // Store the currently selected product
  final Rxn<ProductDetails> selectedProduct = Rxn<ProductDetails>();

  @override
  void onInit() {
    super.onInit();
    _readPlanArguments();
    loadProducts();

    billingService.listenPurchase(onSuccess: verifyPurchase);
  }

  Future<void> loadProducts() async {
    loading.value = true;

    try {
      final result = await billingService.getProducts();
      products.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> buy(ProductDetails product) async {
    // Save product before starting purchase
    selectedProduct.value = product;

    try {
      await billingService.buySubscription(product);
    } catch (e) {
      selectedProduct.value = null;

      Get.snackbar("Purchase Failed", e.toString());
    }
  }

  ProductDetails? _findProduct(String productId) {
    for (final product in products) {
      if (product.id == productId) {
        return product;
      }
    }

    if (selectedProduct.value?.id == productId) {
      return selectedProduct.value;
    }

    return null;
  }

  Future<void> verifyPurchase(PurchaseDetails purchase) async {
    try {
      final token = purchase.verificationData.serverVerificationData;

      final userId = storageService.userId;

      if (userId == null || userId.isEmpty) {
        Get.snackbar("Error", "User ID not found. Please login again");
        return;
      }

      // Find purchased product details using product ID
      final purchasedProduct = _findProduct(purchase.productID);

      final planName = purchasedProduct?.title ?? purchase.productID;

      // Localized formatted price, for example: $9.99
      final planCost = purchasedProduct?.price ?? '';

      // Numeric price, for example: 9.99
      final rawPrice = purchasedProduct?.rawPrice ?? 0.0;

      final currencyCode = purchasedProduct?.currencyCode ?? '';

      print("========================================");
      print("PURCHASE DEBUG");
      print("========================================");
      print("USER ID => $userId");
      print("PRODUCT ID => ${purchase.productID}");
      print("PLAN NAME => $planName");
      print("PLAN COST => $planCost");
      print("RAW PRICE => $rawPrice");
      print("CURRENCY CODE => $currencyCode");
      print("PURCHASE STATUS => ${purchase.status}");
      print(
        "PENDING COMPLETE => "
        "${purchase.pendingCompletePurchase}",
      );
      print("PURCHASE TOKEN => $token");
      print(
        "SOURCE => "
        "${purchase.verificationData.source}",
      );
      print(
        "LOCAL DATA => "
        "${purchase.verificationData.localVerificationData}",
      );
      print(
        "SERVER DATA => "
        "${purchase.verificationData.serverVerificationData}",
      );
      print("========================================");

      await repository.verifyPurchase(
        userId: userId,
        productId: purchase.productID,
        token: token,
      );

      // Complete only after successful server verification
      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }

      Get.snackbar("Success", "Subscription Activated");

      selectedProduct.value = null;

      Get.offAllNamed(
        AppRoutes.SERVICE_PROVIDER_ACCOUNT,
        arguments: {
          "planId": backendPlanId.value,
          "planName": planName,
          "planCost": planCost,
          "rawPrice": rawPrice,
          "currencyCode": currencyCode,
        },
      );
    } catch (e, stackTrace) {
      print("SUBSCRIPTION ERROR => $e");
      print("STACK TRACE => $stackTrace");

      Get.snackbar("Purchase Failed", e.toString());
    }
  }

  void _readPlanArguments() {
    final dynamic receivedArguments = Get.arguments;

    if (receivedArguments is! Map) {
      print('PLAN ARGUMENTS ARE NULL OR INVALID');
      return;
    }

    final Map<String, dynamic> args =
    Map<String, dynamic>.from(receivedArguments);

    final dynamic nestedPlan = args['freePlan'];

    final Map<String, dynamic> planArgs =
    nestedPlan is Map
        ? Map<String, dynamic>.from(nestedPlan)
        : args;

    final String planId =
        planArgs['planId']?.toString().trim() ?? '';

    final String planName =
        planArgs['planName']?.toString().trim() ??
            planArgs['name']?.toString().trim() ??
            '';

    final double planPrice =
        (planArgs['rawPrice'] as num?)?.toDouble() ??
            (planArgs['price'] as num?)?.toDouble() ??
            double.tryParse(
              planArgs['price']?.toString() ?? '',
            ) ??
            0.0;

    final String planCost =
        planArgs['planCost']?.toString() ??
            planPrice.toStringAsFixed(2);

    final String currencyCode =
        planArgs['currencyCode']?.toString() ?? '';

    backendPlanId.value = planId;
    backendPlanName.value = planName;
    backendPlanPrice.value = planPrice;

    freePlan.value = {
      'planId': planId,
      'name': planName,
      'price': planPrice,
      'planCost': planCost,
      'currencyCode': currencyCode,
    };

    print('===================================');
    print('BACKEND PLAN ID => ${backendPlanId.value}');
    print('PLAN NAME => ${backendPlanName.value}');
    print('PLAN PRICE => ${backendPlanPrice.value}');
    print('===================================');
  }
}
