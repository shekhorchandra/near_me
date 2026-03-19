import 'dart:io';

class ServiceItem {
  File? imageFile;
  String title;
  String description;

  ServiceItem({this.imageFile, required this.title, this.description = ""});
}
