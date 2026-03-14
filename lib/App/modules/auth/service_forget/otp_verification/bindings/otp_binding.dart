import 'package:get/get.dart';
import '../controllers/otp_controller.dart';

class UserOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserOtpController());
  }
}