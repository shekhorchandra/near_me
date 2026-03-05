import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../category/controller/categories_controller.dart';
import '../../category/views/categories_view.dart';
import '../../chat/controller/chat_controller.dart';
import '../../chat/views/chat_view.dart';
import '../../home/controller/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../menu/menu_bar/controller/menu_controller.dart';
import '../../menu/menu_bar/views/menu_view.dart';


class UserNavigationBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  Rx<Widget?> currentOverlayPage = Rx<Widget?>(null);

  void openOverlayPage(Widget page) {
    currentOverlayPage.value = page;
  }

  void closeOverlayPage() {
    currentOverlayPage.value = null;
  }

  final screens = [
    const HomeView(),
    const CategoriesView(),
    const ChatView(),
    const MenuView(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
    closeOverlayPage();
  }
}
