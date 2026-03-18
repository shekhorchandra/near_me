import 'package:get/get.dart';
import 'package:near_me/App/modules/servicer/servicer_menu/servicer_help_support/help_support_controller/help_support_controller.dart';

class ServicerHelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerHelpSupportController>(() => ServicerHelpSupportController());
  }
}
