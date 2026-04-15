import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/data/services/storage_service.dart';
import 'package:http/http.dart' as http;

import '../model/servicer_highlight_model.dart';

class ServiceHighlightController extends GetxController {
  final services = <ServiceItem>[].obs;
  final StorageService storage = StorageService();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final selectedImage = Rxn<File>();


  final picker = ImagePicker();
  final isCreating = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchHighlights();
  }


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

  void openCreateDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Drag Handle
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              /// Title
              const Text(
                "Create Highlight",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              /// Image Picker
              GestureDetector(
                onTap: pickImage,
                child: Obx(() {
                  final file = selectedImage.value;

                  return Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                      image: file != null
                          ? DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: file == null
                        ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, color: Colors.grey),
                          SizedBox(height: 6),
                          Text("Upload Image",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                        : null,
                  );
                })
              ),

              const SizedBox(height: 16),

              /// Title Field
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter title",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Description Field
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter description (min 10 characters)",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Submit Button
              Obx(() {
                final controller = Get.find<ServiceHighlightController>();

                return AppButton(
                  loading: controller.isCreating.value,
                  onPressed: () {
                    if (controller.isCreating.value) return;
                    controller.createHighlight();
                  },
                  text: 'Create Highlight',
                );
              }),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> createHighlight() async {
    try {
      final token = storage.accessToken;
      final serviceId = storage.serviceId;

      if (token == null || serviceId == null || selectedImage.value == null) {
        Get.snackbar("Error", "Missing data");
        return;
      }

      isCreating.value = true;

      final uri = Uri.parse(
        "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/highlight-service/",
      );

      var request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = token;

      request.fields['data'] = jsonEncode({
        "service": serviceId,
        "title": titleController.text,
        "description": descController.text,
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          selectedImage.value!.path,
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        Get.back();
        Get.snackbar("Success", "Highlight created");

        fetchHighlights();

        titleController.clear();
        descController.clear();
        selectedImage.value = null;
      } else {
        Get.snackbar("Error", "Failed: $resBody");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> refreshHighlights() async {
    await fetchHighlights();
  }


}

