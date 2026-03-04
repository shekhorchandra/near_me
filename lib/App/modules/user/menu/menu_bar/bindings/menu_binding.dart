import 'package:get/get.dart';

import '../../../bottom_nav_bar/controllers/bottom_nav_controller.dart';
import '../controller/menu_controller.dart';


class MenuBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserMenuController>(() => UserMenuController());
    }
  }