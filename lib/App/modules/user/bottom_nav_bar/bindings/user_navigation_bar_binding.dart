import 'package:get/get.dart';

import '../controllers/bottom_nav_controller.dart';


class UserNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserNavigationBarController>(() => UserNavigationBarController());
  }
}
