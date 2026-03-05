import 'package:get/get.dart';
import '../controller/user_verify_account_controller.dart';

class UserVerifyAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserVerifyAccountController());
  }
}