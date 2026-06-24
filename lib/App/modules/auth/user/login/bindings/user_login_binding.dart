import 'package:get/get.dart';
import '../../../../../data/services/auth_api_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../controllers/user_login_controller.dart';

class UserLoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(StorageService(), permanent: true);
    }

    if (!Get.isRegistered<AuthApiService>()) {
      Get.lazyPut<AuthApiService>(() => AuthApiService(), fenix: true);
    }

    Get.lazyPut<UserLoginController>(
          () => UserLoginController(),
      fenix: true,
    );
  }
}
