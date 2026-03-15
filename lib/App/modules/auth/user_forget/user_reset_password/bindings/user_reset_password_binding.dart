import 'package:get/get.dart';

import '../controllers/user_reset_password_controller.dart';


class UserResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserResetPasswordController());
  }
}