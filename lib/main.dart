import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:near_me/firebase_options.dart';
import 'App/core/theme/checkbox_theme.dart';
import 'App/core/values/app_strings.dart';
import 'App/data/network/dio_client.dart';
import 'App/data/services/deep_link_service.dart';
import 'App/data/services/notification_service.dart';
import 'App/data/services/socket_service.dart';
import 'App/data/services/storage_service.dart';
import 'App/modules/auth/internet/controller/internet_controller.dart';
import 'App/routes/app_pages.dart';
import 'App/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();
  await dotenv.load(fileName: ".env");
  print(dotenv.env['GOOGLE_MAPS_API_KEY']);
  //  INIT STORAGE



  // Get.put(InternetController(), permanent: true);
  // Clear login data every app launch
  // await storageService.clear();

  // Deep Link Initialization
  // DeepLinkService().init();



  await NotificationService().setupInteractedMessage();
  // Handle FCM messages while in background
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Register DioClient
  Get.put<DioClient>(DioClient(), permanent: true);

  // Register SocketService
  Get.put<SocketService>(SocketService(), permanent: true);

  runApp(const NearMeeApp());
}

class NearMeeApp extends StatelessWidget {
  const NearMeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        checkboxTheme: checkboxTheme,
        fontFamily: 'FontMain',
      ),

      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}

// Handle background notifications
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // If using Firebase services in background, you must initialize Firebase here:
  await Firebase.initializeApp();

  print('Background message Title: ${message.notification?.title}');
  print('Background message Body: ${message.notification?.body}');

  await NotificationService().showNotification(message);
}
