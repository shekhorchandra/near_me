import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/servicer_highlight_model.dart';

class ServiceHighlightController extends GetxController {
  final picker = ImagePicker();

  final services = <ServiceItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    initServices();
  }

  void initServices() {
    services.assignAll([
      ServiceItem(title: "Massage Therapy"),
      ServiceItem(title: "Home Cleaning"),
      ServiceItem(title: "AC Repair"),
      ServiceItem(title: "Plumbing"),
    ]);
  }

  /// Show option dialog
  void pickImage(int index) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                _getImage(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                _getImage(index, ImageSource.gallery);
              },
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(int index, ImageSource source) async {
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      services[index].imageFile = File(picked.path);
      services.refresh();
    }
  }
}