
import 'package:get/get.dart';
import '../controller/service_provider_edit_controller.dart';

class ServiceProviderEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderEditController>(() => ServiceProviderEditController());
  }
}