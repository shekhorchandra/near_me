import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:near_me/App/data/services/storage_service.dart';

import '../../../../services/contants/api_constants.dart';

class ServiceHightlightsDetailsController extends GetxController {
  final picker = ImagePicker();
  final StorageService storage = StorageService();

  final titleController = TextEditingController();
  final descController = TextEditingController();

  final Rxn<File> imageFile = Rxn<File>();
  final RxnString imageUrl = RxnString();
  final isSaving = false.obs;
  final isDeleting = false.obs;

  late String highlightId;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    highlightId = Get.arguments; // ONLY ID

    fetchSingleHighlight();
  }

  // ================= GET SINGLE =================
  Future<void> fetchSingleHighlight() async {
    try {
      final token = storage.accessToken;

      // final url =
      //     "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/highlight-service/$highlightId";

      final url = ApiConstants.highlightService(highlightId);
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": token ?? "", "Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        titleController.text = data['title'] ?? '';
        descController.text = data['description'] ?? '';
        imageUrl.value = data['image'];
      } else {
        Get.snackbar("Error", "Failed to load highlight");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PICK IMAGE =================
  void pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  // ================= SAVE (UPDATE API) =================
  Future<void> saveService() async {
    try {
      isSaving.value = true;

      final token = storage.accessToken;

      // final uri = Uri.parse(
      //   "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/highlight-service/$highlightId",
      // );

      final uri = Uri.parse(ApiConstants.highlightService(highlightId));

      var request = http.MultipartRequest("PATCH", uri);

      request.headers['Authorization'] = token ?? "";

      request.fields['data'] = jsonEncode({
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
      });

      if (imageFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath("image", imageFile.value!.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar("Success", "Updated successfully");
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } finally {
      isSaving.value = false;
    }
  }

  // ================= DELETE =================
  Future<void> deleteService() async {
    Get.defaultDialog(
      title: "Delete Service",
      middleText: "Are you sure?",
      textConfirm: "Yes",
      textCancel: "No",
      onConfirm: () async {
        try {
          isDeleting.value = true;

          final token = storage.accessToken;

          // final url =
          //     "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/highlight-service/$highlightId";

          final url = ApiConstants.highlightService(highlightId);

          final response = await http.delete(
            Uri.parse(url),
            headers: {"Authorization": token ?? ""},
          );

          if (response.statusCode == 200) {
            Get.back(); // dialog
            Get.back(); // page
            Get.snackbar("Deleted", "Highlight removed");
          } else {
            Get.snackbar("Error", "Delete failed");
          }
        } finally {
          isDeleting.value = false;
        }
      },
    );
  }
}
