import 'package:get/get.dart';

import '../controller/menu_controller.dart';


class MenuBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserMenuController>(() => UserMenuController());
    }
  }