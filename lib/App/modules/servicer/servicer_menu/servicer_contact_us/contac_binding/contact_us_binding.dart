import 'package:get/get.dart';
import 'package:near_me/App/modules/servicer/servicer_menu/servicer_contact_us/contact_controller/contact_us_controller.dart';

class ServicerContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerContactUsController>(() => ServicerContactUsController());
  }
}
