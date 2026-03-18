import 'package:get/get.dart';

import '../controller/servicer_menu_controller.dart';


class ServicerMenuBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerMenuController>(() => ServicerMenuController());
    }
  }