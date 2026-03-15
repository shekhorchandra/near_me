import 'package:get/get.dart';

import '../controllers/servicer_reset_password_controller.dart';


class ServicerResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServicerResetPasswordController());
  }
}