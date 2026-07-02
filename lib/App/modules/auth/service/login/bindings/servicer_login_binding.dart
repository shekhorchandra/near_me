import 'package:get/get.dart';
import '../../../../../data/services/auth_api_service.dart';
import '../controllers/servicer_login_controller.dart';

class ServicerLoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthApiService>()) {
      Get.lazyPut<AuthApiService>(() => AuthApiService(), fenix: true);
    }

    Get.lazyPut<ServicerLoginController>(
          () => ServicerLoginController(),
    );
  }
}