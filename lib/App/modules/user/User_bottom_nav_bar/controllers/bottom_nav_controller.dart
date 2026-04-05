import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../category/user_category/views/categories_view.dart';

import '../../chat/user_chat/views/chat_view.dart';
import '../../home/controller/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../menu/user_menu_bar/views/menu_view.dart';



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
    HomeView(),
    const CategoriesView(),
    const ChatView(),
    const MenuView(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
    closeOverlayPage();
  }
}
