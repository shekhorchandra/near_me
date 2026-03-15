import 'package:get/get.dart';
import '../controller/servicer_verify_account_controller.dart';

class ServicerVerifyAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServicerVerifyAccountController());
  }
}