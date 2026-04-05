// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:uuid/uuid.dart';
//
// class DeviceInfoService {
//   final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
//
//   Future<Map<String, String>> getDeviceInfo() async {
//     String deviceId = await _generateDeviceId();
//     String deviceName = await _generateDeviceName();
//
//     return {'deviceId': deviceId, 'deviceName': deviceName};
//   }
//
//   // Generate a unique device ID
//   Future<String> _generateDeviceId() async {
//     if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
//       String uniqueDeviceId = androidInfo.id; // Unique ID on Android
//       return uniqueDeviceId;
//     } else if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
//       String uniqueDeviceId = iosInfo.identifierForVendor ?? Uuid().v4(); // Unique ID on iOS
//       return uniqueDeviceId;
//     } else {
//       return Uuid().v4();
//     }
//   }
//
//   // Generate a device name
//   Future<String> _generateDeviceName() async {
//     if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
//       return "${androidInfo.model} (${androidInfo.brand}, Android ${androidInfo.version.release})";
//     } else if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
//       return "${iosInfo.utsname.machine} (${iosInfo.systemVersion})";
//     } else {
//       return "Unknown Device";
//     }
//   }
// }
