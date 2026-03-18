import 'package:get/get.dart';

import '../controllers/About_Controller.dart';

class ServicerAboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerAboutController>(() => ServicerAboutController());
  }
}
