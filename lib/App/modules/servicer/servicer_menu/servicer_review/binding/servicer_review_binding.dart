import 'package:get/get.dart';

import '../controller/ServicerReviewController.dart';

class ServicerReviewBinding extends Bindings {
  @override
  void dependencies() {
    final serviceId = Get.arguments as String;

    Get.lazyPut<ServiceReviewController>(
          () => ServiceReviewController(serviceId: serviceId),
    );
  }
}