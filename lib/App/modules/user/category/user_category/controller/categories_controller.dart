import 'package:get/get.dart';

class CategoriesController extends GetxController {
  var searchText = ''.obs;

  final categories = [
    {
      "name": "Trades & Services",
      "image": "assets/images/usercategory.png"},
  ].obs;

  List<Map<String, String>> get filteredCategories {
    if (searchText.value.isEmpty) {
      return categories;
    }
    return categories
        .where((cat) =>
        cat["name"]!.toLowerCase().contains(searchText.value.toLowerCase()))
        .toList();
  }
}