import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  final Dio dio = Dio();

  var searchText = ''.obs;
  var isLoading = false.obs;

  /// API Categories
  var categories = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();

    /// First time load all categories
    fetchCategories();
  }


  /// FETCH CATEGORY API

  Future<void> fetchCategories({String keyword = ''}) async {
    try {
      isLoading.value = true;

      final response = await dio.get(
        'https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/category/search',
        queryParameters: {
          "searchTerm": keyword,
          "level": 0,
        },
      );

      /// PRINT FULL RESPONSE BODY
      print("Full Response Body----------------------------------------: ${response.data}");

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        final List data = response.data["data"];

        categories.value = data.map((item) {
          return {
            "id": item["_id"].toString(),
            "name": item["name"].toString(),
            "image": "assets/images/usercategory.png",
          };
        }).toList();
      }
    } catch (e) {
      print("Category Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}