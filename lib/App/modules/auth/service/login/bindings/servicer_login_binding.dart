import 'package:get/get.dart';
import '../controllers/servicer_login_controller.dart';

class ServicerLoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerLoginController>(() => ServicerLoginController());
  }
}
