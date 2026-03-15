import 'package:get/get.dart';
import '../controllers/servicer_otp_controller.dart';

class ServicerOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServicerOtpController());
  }
}