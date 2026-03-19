import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../controller/servicer_dashboard_controller.dart';


class ServiceDashboardView extends GetView<ServiceDashboardController> {
  const ServiceDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Service Dashboard',showBack: false
      ),
      body: SafeArea(
        child: Center(
          child: Obx(() => Text(
            controller.title.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }
}