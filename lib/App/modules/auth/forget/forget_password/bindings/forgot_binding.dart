import 'package:get/get.dart';
import '../controllers/forgot_controller.dart';

class ForgotPasswordBinding extends Bindings {
  final UserRole role;
  ForgotPasswordBinding({this.role = UserRole.user});

  @override
  void dependencies() {
    Get.put(ForgotPasswordController(role: role));
  }
}