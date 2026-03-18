import 'package:get/get.dart';
import '../privacy_policy_controller/privacy_policy_controller.dart';

class ServicerPrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerPrivacyPolicyController>(() => ServicerPrivacyPolicyController());
  }
}
