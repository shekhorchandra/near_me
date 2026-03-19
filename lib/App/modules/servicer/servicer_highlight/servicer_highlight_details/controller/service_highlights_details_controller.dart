import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../servicer_highlights_page/controller/servicer_highlight_controller.dart';
import '../models/service_highlights_details_model.dart';

class ServiceHightlightsDetailsController extends GetxController {
  final picker = ImagePicker();

  late int index;
  late ServiceHightlightsDetailsModel service;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  final highlightController = Get.find<ServiceHighlightController>();

  @override
  void onInit() {
    super.onInit();

    index = Get.arguments['index'];

    final item = highlightController.services[index];

    service = ServiceHightlightsDetailsModel(
      imageFile: item.imageFile,
      title: item.title,
      description: item.description,
    );

    titleController.text = service.title;
    descController.text = service.description;
  }

  /// Pick Image
  void pickImage() {
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
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                _getImage(ImageSource.gallery);
              },
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      service.imageFile = File(picked.path);
      update();
    }
  }

  /// Save
  void saveService() {
    highlightController.services[index].title = titleController.text;
    highlightController.services[index].description =
        descController.text;
    highlightController.services[index].imageFile =
        service.imageFile;

    highlightController.services.refresh();

    Get.back();
    Get.snackbar("Success", "Service updated");
  }

  /// Delete
  void deleteService() {
    Get.defaultDialog(
      title: "Delete Service",
      middleText: "Are you sure you want to delete?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        highlightController.services[index] =
        highlightController.services[index] =
        highlightController.services[index]
          ..title = "Empty Service"
          ..description = ""
          ..imageFile = null;

        highlightController.services.refresh();

        Get.back(); // dialog
        Get.back(); // page

        Get.snackbar("Deleted", "Service removed");
      },
    );
  }
}