import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/servicer_dashboard_controller.dart';


class ServiceDashboardView extends GetView<ServiceDashboardController> {
  const ServiceDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Dashboard"),
      ),
      body: Center(
        child: Obx(() => Text(
          controller.title.value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}