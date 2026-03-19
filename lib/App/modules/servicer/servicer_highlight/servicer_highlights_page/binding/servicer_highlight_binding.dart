import 'package:get/get.dart';
import '../controller/servicer_highlight_controller.dart';

class ServiceHighlightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceHighlightController>(() => ServiceHighlightController());
  }
}
