import 'package:get/get.dart';
import '../terms_condition_controller/terms_condition_controller.dart';

class TermsConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionController>(() => TermsConditionController());
  }
}
