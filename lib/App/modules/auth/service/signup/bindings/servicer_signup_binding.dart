
import 'package:get/get.dart';

import '../controllers/servicer_signup_controller.dart';

class ServicerSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServicerSignupController());
  }
}
