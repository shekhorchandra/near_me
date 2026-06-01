import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/storage_service.dart';
import '../../servicer_chat/services/ChatApiService.dart';
import '../model/MessageModel.dart';

class ServicerConversationController extends GetxController {
  final ServiceChatApiService apiService = Get.find();

  final StorageService storage = StorageService();

  TextEditingController messageController = TextEditingController();

  final messages = <ServicerMessageModel>[].obs;

  final isLoading = false.obs;

  late String userId;
  late String userName;

  @override
  void onInit() {
    super.onInit();

    userId = Get.arguments["userId"];
    userName = Get.arguments["name"];

    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;

      final token = storage.accessToken;

      if (token == null) return;

      final result = await apiService.getMessages(token: token, userId: userId);

      messages.assignAll(result);
    } catch (e) {
      print("Message Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    messageController.clear();
  }
}
