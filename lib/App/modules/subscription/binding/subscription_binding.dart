import 'package:get/get.dart';

import '../controller/subscription_controller.dart';
import '../repository/subscription_repository.dart';
import '../services/billing_service.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillingService>(() => BillingService());

    Get.lazyPut<SubscriptionRepository>(() => SubscriptionRepository());

    Get.lazyPut<SubscriptionController>(
      () => SubscriptionController(
        billingService: Get.find(),
        repository: Get.find(),
      ),
    );
  }
}
