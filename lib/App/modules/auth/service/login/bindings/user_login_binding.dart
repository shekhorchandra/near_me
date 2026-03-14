import 'package:get/get.dart';
import '../controllers/user_login_controller.dart';

class UserLoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserLoginController>(() => UserLoginController());
  }
}
