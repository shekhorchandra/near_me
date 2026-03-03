import 'package:get/get.dart';

class UserLoginController extends GetxController {
  final obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }
}
