import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
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

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();

    highlightId = Get.arguments; // ONLY ID

    fetchSingleHighlight();
  }

  // ================= GET SINGLE =================
  Future<void> fetchSingleHighlight() async {
    try {
      isLoading.value = true;

      final token = storage.accessToken;

      final url = ApiConstants.highlightService(highlightId);

      logger.i("HIGHLIGHT URL => $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          // ✅ FIX
          "Authorization": "Bearer $token",
          "accesstoken": token ?? "",
          "Content-Type": "application/json",
        },
      );

      logger.i(
        "STATUS CODE => ${response.statusCode}",
      );

      final decoded = jsonDecode(response.body);

      // ✅ PRETTY LOGGER
      final prettyJson =
      const JsonEncoder.withIndent('    ')
          .convert(decoded);

      logger.i(prettyJson);

      if (response.statusCode == 200 &&
          decoded["success"] == true) {

        final data = decoded['data'];

        titleController.text =
            data['title'] ?? '';

        descController.text =
            data['description'] ?? '';

        imageUrl.value =
            data['image'] ?? '';

      } else {

        Get.snackbar(
          "Error",
          decoded["message"] ??
              "Failed to load highlight",
        );
      }

    } catch (e) {

      logger.e(
        "FETCH SINGLE HIGHLIGHT ERROR => $e",
      );

      Get.snackbar(
        "Error",
        "Something went wrong",
      );

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

      final uri = Uri.parse(
        ApiConstants.highlightService(highlightId),
      );

      var request = http.MultipartRequest("PATCH", uri);

      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      // ================= BODY =================
      request.fields['data'] = jsonEncode({
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
      });

      // ================= IMAGE =================
      if (imageFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "image",
            imageFile.value!.path,
          ),
        );
      }

      // ================= API CALL =================
      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      // ================= LOGGER =================
      final responseData = jsonDecode(response.body);

      final prettyJson = const JsonEncoder.withIndent(
        '    ',
      ).convert(responseData);

      logger.i(prettyJson);

      // ================= SUCCESS =================
      if (response.statusCode == 200 &&
          responseData["success"] == true) {

        Get.back();

        Get.snackbar(
          "Success",
          responseData["message"] ?? "Updated successfully",
        );

      } else {

        Get.snackbar(
          "Error",
          responseData["message"] ?? "Update failed",
        );
      }

    } catch (e) {

      logger.e("UPDATE HIGHLIGHT ERROR => $e");

      Get.snackbar(
        "Error",
        "Something went wrong",
      );

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

          final url = ApiConstants.highlightService(highlightId);

          final response = await http.delete(
            Uri.parse(url),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          );

          final data = jsonDecode(response.body);

          logger.i(const JsonEncoder.withIndent('  ').convert(data));

          if (response.statusCode == 200 && data["success"] == true) {
            Get.back(); // close dialog
            Get.back(); // go back page
            Get.snackbar("Deleted", "Highlight removed successfully");
          } else {
            Get.snackbar(
              "Error",
              data["message"] ?? "Delete failed",
            );
          }
        } catch (e) {
          logger.e("DELETE ERROR => $e");
          Get.snackbar("Error", "Something went wrong");
        } finally {
          isDeleting.value = false;
        }
      },
    );
  }
}
