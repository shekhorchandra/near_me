import 'package:get/get.dart';

class ServicerLoginController extends GetxController {
  final obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }
}
