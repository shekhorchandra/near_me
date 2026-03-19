import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../servicer_chat/servicer_inbox/views/servicer_chat_view.dart';
import '../../servicer_dashboard/views/servicer_dashboard_view.dart';
import '../../servicer_highlight/servicer_highlights_page/views/servicer_highlight_view.dart';
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
    const ServicerChatView(),
    const ServicerMenuView(),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
    closeOverlayPage();
  }
}
