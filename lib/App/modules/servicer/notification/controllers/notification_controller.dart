import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/notification_model.dart';
import '../../../../data/network/dio_client.dart';
import '../../../../data/services/storage_service.dart';
import '../../../services/contants/api_constants.dart';

class NotificationController extends GetxController {
  final DioClient _dioClient = DioClient();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt page = 1.obs;
  final RxInt limit = 20.obs;
  final RxInt unreadCount = 0.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreNotifications();
      }
    });
  }

  final storage = Get.find<StorageService>();

  @override
  void onReady() {
    super.onReady();

    final token = storage.accessToken;

    if (token == null || token.isEmpty) {
      print("No access token. Skip API.");
      return;
    }

    fetchNotifications();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchNotifications({bool isLoadMore = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await _dioClient.client.get(
        ApiConstants.notifications,
        queryParameters: {
          "page": page.value,
          "limit": limit.value,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = response.data["data"] ?? [];

        final newNotifications = list
            .map((e) => NotificationModel.fromJson(e))
            .toList();

        if (isLoadMore) {
          notifications.addAll(newNotifications);
        } else {
          notifications.assignAll(newNotifications);
        }

        unreadCount.value =
            notifications.where((e) => e.isRead == false).length;
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreNotifications() {
    page.value++;
    fetchNotifications(isLoadMore: true);
  }

  Future<void> refreshNotifications() async {
    page.value = 1;
    await fetchNotifications();
  }

  Future<void> markSeen(String id) async {
    try {
      await _dioClient.client.patch(
        ApiConstants.markSeen(id),
      );

      final index =
      notifications.indexWhere((e) => e.sId == id);

      if (index != -1) {
        notifications[index].isRead = true;
        notifications.refresh();
      }

      if (unreadCount.value > 0) {
        unreadCount.value--;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _dioClient.client.delete(
        ApiConstants.deleteNotification(id),
      );

      notifications.removeWhere((e) => e.sId == id);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}