import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:near_me/App/data/services/storage_service.dart';
import 'package:http/http.dart' as http;

import '../model/servicer_highlight_model.dart';

class ServiceHighlightController extends GetxController {
  final services = <ServiceItem>[].obs;
  final StorageService storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    // debugServiceId();
    fetchHighlights(); // 👈 call API
  }

  // void debugServiceId() {
  //   print("SERVICE ID:----------------------------- ${storage.serviceId}");
  // }

  Future<void> fetchHighlights() async {
    try {
      // 🔥 DEBUG MODE (hardcoded)
      // const debugServiceId = "69dcb85c6198dd4c5c23e4a4";

      final token = storage.accessToken;
      final serviceId = storage.serviceId;

      log("SERVICE ID FROM STORAGE:---------- $serviceId");
      log("STORED SERVICE ID:------------- ${StorageService().serviceId}");
      log("TOKEN: $token");

      if (serviceId == null || serviceId.isEmpty || token == null) {
        log("❌ Missing serviceId or token");
        return;
      }

      final url =
          "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/highlight-service/service/$serviceId";

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": token, "Content-Type": "application/json"},
      );

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List list = data['data'] ?? [];

        services.assignAll(list.map((e) => ServiceItem.fromJson(e)).toList());
      } else {
        Get.snackbar("Error", "Failed to load highlights");
      }
    } catch (e) {
      log("ERROR: $e");
      Get.snackbar("Error", e.toString());
    }
  }
}
