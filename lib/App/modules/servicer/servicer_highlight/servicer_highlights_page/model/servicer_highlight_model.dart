import 'dart:io';

class ServiceItem {
  File? imageFile;
  String title;
  String description;

  ServiceItem({this.imageFile, required this.title, this.description = ""});

  // Add this getter so preview page can use highlight.image
  String get image => imageFile?.path ?? '';
}