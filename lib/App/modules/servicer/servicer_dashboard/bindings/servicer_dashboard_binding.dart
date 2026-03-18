import 'package:get/get.dart';
import '../controller/servicer_dashboard_controller.dart';


class ServiceDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceDashboardController>(
          () => ServiceDashboardController(),
    );
  }
}