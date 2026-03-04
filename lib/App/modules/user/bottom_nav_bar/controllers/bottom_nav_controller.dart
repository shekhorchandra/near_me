import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../category/controller/categories_controller.dart';
import '../../category/views/categories_view.dart';
import '../../chat/controller/chat_controller.dart';
import '../../chat/views/chat_view.dart';
import '../../home/controller/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../menu/views/menu_view.dart';


class UserNavigationBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  /// Overlay page (e.g., AboutView)
  Rx<Widget?> currentOverlayPage = Rx<Widget?>(null);

  void openOverlayPage(Widget page) {
    currentOverlayPage.value = page;
  }

  void closeOverlayPage() {
    currentOverlayPage.value = null;
  }

  /// Screens for bottom nav
  final screens = [
    const HomeView(),
    const CategoriesView(),
    const ChatView(),
    const MenuView(),
  ];

  /// Switch tabs
  void changeTab(int index) {
    selectedIndex.value = index;
    closeOverlayPage();
  }

  @override
  void onInit() {
    super.onInit();

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<MenuController>(() => MenuController());
  }
}
