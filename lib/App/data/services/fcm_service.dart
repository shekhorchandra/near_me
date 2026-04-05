// import 'dart:developer';
//
// import 'package:coupon_code/app/data/services/notification_service.dart';
// import 'package:coupon_code/app/data/services/storage_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FCMService {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   late String? _fcmToken;
//   final NotificationService _notificationService = NotificationService();
//
//   Future<String?> _generateFCMToken() async {
//     return await _firebaseMessaging.getToken();
//   }
//
//   Future<bool> initFCM() async {
//     await _firebaseMessaging.requestPermission();
//
//     // Generate FCM token
//     try {
//       _fcmToken = await _generateFCMToken();
//       log('FCM Token: $_fcmToken');
//
//       if (_fcmToken == null) {
//         return false;
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//
//     // Save FCM token
//     StorageService().write('fcm_token', _fcmToken);
//
//     // Initialize notifications
//     await _notificationService.initialize();
//
//     // Notification settings
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log('Title: ${message.notification!.title}');
//       log('Body: ${message.notification!.body}');
//       _notificationService.showNotification(message);
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log('Title: ${message.notification!.title}');
//       log('Body: ${message.notification!.body}');
//       _notificationService.showNotification(message);
//     });
//
//     return true;
//   }
// }
