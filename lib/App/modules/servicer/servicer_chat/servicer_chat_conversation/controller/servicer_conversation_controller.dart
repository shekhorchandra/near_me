import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicerConversationController extends GetxController {

  TextEditingController messageController = TextEditingController();

  var messages = [
    {"msg": "Hello! How can I help you?", "isMe": false},
    {"msg": "I want to know about your service.", "isMe": true},
    {"msg": "Sure! We are available today.", "isMe": false},
  ].obs;

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    messages.add({
      "msg": messageController.text,
      "isMe": true
    });

    messageController.clear();
  }

}