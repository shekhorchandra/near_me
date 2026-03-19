import 'dart:io';

class ServiceHightlightsDetailsModel {
  File? imageFile;
  String title;
  String description;

  ServiceHightlightsDetailsModel({
    this.imageFile,
    required this.title,
    required this.description,
  });
}