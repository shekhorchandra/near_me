import 'package:get/get.dart';
import '../controllers/user_otp_controller.dart';

class UserOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserOtpController>(() => UserOtpController());
  }
}