// import 'dart:async';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
//
// class InternetController extends GetxController {
//   final RxBool isConnected = true.obs;
//
//   StreamSubscription? _subscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _listenInternet();
//   }
//
//   void _listenInternet() {
//     _subscription = Connectivity().onConnectivityChanged.listen((_) async {
//       final hasInternet =
//       await InternetConnection().hasInternetAccess;
//
//       isConnected.value = hasInternet;
//
//       if (!hasInternet) {
//         Get.rawSnackbar(
//           messageText: const Text(
//             "No Internet Connection",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: Colors.red,
//           icon: const Icon(
//             Icons.wifi_off,
//             color: Colors.white,
//           ),
//           duration: const Duration(days: 1),
//           isDismissible: false,
//           snackPosition: SnackPosition.TOP,
//           margin: const EdgeInsets.all(0),
//           borderRadius: 0,
//         );
//       } else {
//         if (Get.isSnackbarOpen) {
//           Get.closeCurrentSnackbar();
//         }
//
//         Get.snackbar(
//           "Connected",
//           "Internet connection restored",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           icon: const Icon(
//             Icons.wifi,
//             color: Colors.white,
//           ),
//           snackPosition: SnackPosition.TOP,
//           margin: EdgeInsets.zero,
//           borderRadius: 0,
//           duration: const Duration(seconds: 1),
//         );
//       }
//     });
//   }
//
//   @override
//   void onClose() {
//     _subscription?.cancel();
//     super.onClose();
//   }
// }