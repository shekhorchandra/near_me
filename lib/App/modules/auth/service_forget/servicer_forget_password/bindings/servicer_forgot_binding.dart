import 'package:get/get.dart';
import '../../../../../core/enums/user_role.dart';
import '../controllers/servicer_forgot_controller.dart';

class ServicerForgotPasswordBinding extends Bindings {
  final UserRole role;

  ServicerForgotPasswordBinding({this.role = UserRole.service});

  @override
  void dependencies() {
    Get.put(ServicerForgotPasswordController(role: role));
  }
}