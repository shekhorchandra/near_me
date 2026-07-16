
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:near_me/App/data/services/storage_service.dart';

import '../../modules/services/contants/api_constants.dart';
import '../../routes/app_routes.dart';
import '../network/dio_client.dart';

enum NotificationType { general, dealPublished, promotional }

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  Future<void> initialize() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'general_channel',
      'General Notifications',
      description: 'General notifications',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          _handlePayload(response.payload!);
        }
      },
    );

    // 👇 Add this
    _listenForegroundMessages();
    _listenTokenRefresh();
  }

  Future<void> setupInteractedMessage() async {
    // App was terminated and opened from notification
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // App was in background and opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;

    print("PAYLOAD => ${message.data}");

    if (data["type"] == "CHAT") {
      Get.toNamed(
        AppRoutes.CONVERSATION,
        arguments: {
          "userId": data["senderId"],
          "name": data["senderName"] ?? "Chat",
          "image": data["image"] ?? "",
          "isOnline": false,
        },
      );
    }
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("========== FOREGROUND MESSAGE ==========");
      print("Title: ${message.notification?.title}");
      print("Body : ${message.notification?.body}");
      print("Data : ${message.data}");

      await showNotification(message);
    });
  }

  void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("🔄 New FCM Token: $newToken");

      final accessToken = StorageService().accessToken;

      // User logged in না থাকলে API call করবে না
      if (accessToken == null || accessToken.isEmpty) {
        return;
      }

      try {
        final dioClient = Get.find<DioClient>();

        await dioClient.client.patch(
          ApiConstants.update_fcm,
          data: {
            "fcmToken": newToken,
          },
        );


        print("✅ FCM Token Updated Successfully");
      } catch (e) {
        print("❌ FCM Token Update Error: $e");
      }
    });
  }

  // Show local notification based on type
  Future<void> showNotification(RemoteMessage message) async {
    print("SHOW NOTIFICATION CALLED");

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
      android: AndroidNotificationDetails(
        'general_channel',
        'General Notifications',
        channelDescription: 'General notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
      notificationDetails: platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );

    print("SHOW FINISHED");
  }

  void _handlePayload(String payload) {
    print("PAYLOAD => $payload");

    final Map<String, dynamic> data = jsonDecode(payload);

    print("DATA => $data");

    _navigate(data);
  }

  void _navigate(Map<String, dynamic> data) {
    print("DATA => $data");

    final type = data["type"]?.toString();

    if (type == "CHAT") {
      final senderId = data["senderId"]?.toString();

      if (senderId == null || senderId.isEmpty) {
        Get.toNamed(AppRoutes.NOTIFICATIONS);
        return;
      }

      Get.toNamed(
        AppRoutes.CONVERSATION,
        arguments: {
          "userId": data["senderId"],
          "name": data["senderName"] ?? "Chat",
          "image": data["image"] ?? "",
          "isOnline": false,
        },
      );

      return;
    }

    Get.toNamed(AppRoutes.NOTIFICATIONS);
  }
}
