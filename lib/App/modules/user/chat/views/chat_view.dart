import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';


class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => Text(
          controller.title.value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}