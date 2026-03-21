import 'package:get/get.dart';
import 'package:near_me/App/modules/auth/service/servicer_account/controller/service_provider_controller.dart';

class ServiceProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderController>(() => ServiceProviderController());
  }
}