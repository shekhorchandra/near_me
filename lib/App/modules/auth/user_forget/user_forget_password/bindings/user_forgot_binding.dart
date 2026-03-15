import 'package:get/get.dart';
import '../../../../../core/enums/user_role.dart';
import '../controllers/user_forgot_controller.dart';

class UserForgotPasswordBinding extends Bindings {
  final UserRole role;
  UserForgotPasswordBinding({this.role = UserRole.user});

  @override
  void dependencies() {
    Get.put(UserForgotPasswordController(role: role));
  }
}