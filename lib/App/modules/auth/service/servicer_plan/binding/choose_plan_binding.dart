import 'package:get/get.dart';
import '../controller/choose_plan_controller.dart';

class ChoosePlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChoosePlanController>(() => ChoosePlanController());
  }
}