import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';
import '../services/billing_service.dart';
import '../repository/subscription_repository.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionController extends GetxController {
  final StorageService storageService = StorageService();
  final BillingService billingService;

  final SubscriptionRepository repository;

  SubscriptionController({
    required this.billingService,
    required this.repository,
  });

  final RxList<ProductDetails> products = <ProductDetails>[].obs;

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();

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

  Future buy(ProductDetails product) async {
    await billingService.buySubscription(product);
  }

  Future verifyPurchase(PurchaseDetails purchase) async {

    try {

      final token =
          purchase.verificationData.serverVerificationData;


      final userId =
          StorageService().userId;


      if(userId == null || userId.isEmpty){

        Get.snackbar(
          "Error",
          "User ID not found. Please login again",
        );

        return;
      }


      print("SUBSCRIPTION USER ID => $userId");
      print("PRODUCT ID => ${purchase.productID}");
      print("PURCHASE TOKEN => $token");


      await repository.verifyPurchase(

        userId: userId,

        productId: purchase.productID,

        token: token,

      );


      if(purchase.pendingCompletePurchase){

        await InAppPurchase.instance
            .completePurchase(purchase);

      }


      Get.snackbar(
        "Success",
        "Subscription Activated",
      );


    } catch(e){

      print(
          "SUBSCRIPTION ERROR => $e"
      );


      Get.snackbar(
        "Purchase Failed",
        e.toString(),
      );

    }

  }
}
