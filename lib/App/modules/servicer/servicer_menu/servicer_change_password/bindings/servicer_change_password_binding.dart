import 'package:get/get.dart';
import '../controller/servicer_change_password_controller.dart';

class ServicerChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerChangePasswordController>(() => ServicerChangePasswordController());
  }
}