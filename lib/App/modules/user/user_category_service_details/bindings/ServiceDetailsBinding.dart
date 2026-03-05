import 'package:get/get.dart';

import '../controller/ServiceDetailsController.dart';

class ServiceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceDetailsController());
  }
}