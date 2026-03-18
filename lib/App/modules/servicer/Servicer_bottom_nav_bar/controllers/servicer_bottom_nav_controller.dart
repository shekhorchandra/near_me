import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../servicer_chat/views/servicer_chat_view.dart';
import '../../servicer_dashboard/views/servicer_dashboard_view.dart';
import '../../servicer_highlight/views/servicer_highlight_view.dart';
import '../../servicer_menu/servicer_menu_bar/views/servicer_menu_view.dart';
class ServicerNavigationBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  Rx<Widget?> currentOverlayPage = Rx<Widget?>(null);

  void openOverlayPage(Widget page) {
    currentOverlayPage.value = page;
  }

  void closeOverlayPage() {
    currentOverlayPage.value = null;
  }

  final servicer_screens = [
    const ServiceDashboardView(),
    const ServiceHighlightView(),
    const ServiceChatView(),
    const ServicerMenuView(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
    closeOverlayPage();
  }
}
