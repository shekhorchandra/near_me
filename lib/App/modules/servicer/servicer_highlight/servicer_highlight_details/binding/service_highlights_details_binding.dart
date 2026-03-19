import 'package:get/get.dart';
import '../controller/service_highlights_details_controller.dart';

class ServiceHightlightsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceHightlightsDetailsController>(
          () => ServiceHightlightsDetailsController(),
    );
  }
}