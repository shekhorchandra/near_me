import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/servicer_chat_controller.dart';

class ServiceChatView extends GetView<ServiceChatController> {
  const ServiceChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Chat"),
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