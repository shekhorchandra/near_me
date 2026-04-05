// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// enum NotificationType { general, dealPublished, promotional }
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   // Initialize local notifications
//   Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
//   }
//
//   // Show local notification based on type
//   Future<void> showNotification(RemoteMessage message) async {
//     NotificationType type = _getNotificationType(message);
//
//     // Define notification details based on type
//     NotificationDetails platformChannelSpecifics = await _getNotificationDetailsByType(type);
//
//     await flutterLocalNotificationsPlugin.show(
//       id: 0,
//       title: message.notification?.title,
//       body: message.notification?.body,
//       notificationDetails: platformChannelSpecifics,
//     );
//   }
//
//   // Determine notification type
//   NotificationType _getNotificationType(RemoteMessage message) {
//     String typeString = message.data['type'] ?? 'general';
//     switch (typeString) {
//       case 'dealPublished':
//         return NotificationType.dealPublished;
//       case 'promotional':
//         return NotificationType.promotional;
//       default:
//         return NotificationType.general;
//     }
//   }
//
//   // Define notification style based on type
//   Future<NotificationDetails> _getNotificationDetailsByType(NotificationType type) async {
//     switch (type) {
//       case NotificationType.dealPublished:
//         return NotificationDetails(
//           android: AndroidNotificationDetails(
//             'deal_channel',
//             'Deal Notifications',
//             channelDescription: 'Notifications for new deals',
//             importance: Importance.max,
//             priority: Priority.high,
//             color: Colors.green,
//           ),
//         );
//       case NotificationType.promotional:
//         return NotificationDetails(
//           android: AndroidNotificationDetails(
//             'promotional_channel',
//             'Promotional Notifications',
//             channelDescription: 'Receive promotions and offers',
//             importance: Importance.max,
//             priority: Priority.high,
//             color: Colors.blue,
//           ),
//         );
//       default:
//         return NotificationDetails(
//           android: AndroidNotificationDetails(
//             'general_channel',
//             'General Notifications',
//             channelDescription: 'General notifications',
//             importance: Importance.defaultImportance,
//             priority: Priority.low,
//           ),
//         );
//     }
//   }
// }
