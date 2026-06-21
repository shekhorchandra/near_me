import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../services/contants/api_constants.dart';
import '../user_category_model/service_model.dart';

class UserCategoryDetailsController extends GetxController {
  final Dio dio = Dio();

  // ================= LOADING =================
  var isLoadingTree = false.obs;
  var isLoadingServices = false.obs;

  // ================= CATEGORY =================
  var categoryTree = Rxn<Map<String, dynamic>>();
  String? categoryId;

  var selectedCategoryIds = <String>{}.obs;

  // ================= FILTERS =================
  var searchText = ''.obs;

  var selectedRating = 'Rating'.obs;
  var selectedRadius = 'Radius'.obs;
  var selectedAvailability = 'Availability'.obs;

  // ================= DATA =================
  var services = <ServiceModel>[].obs;

  // ================= CATEGORY SELECTION =================
  var selectedSubCategoryId = ''.obs;
  var selectedChildCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    categoryId = args != null ? args["id"] : null;

    print("Category ID: $categoryId");
  }

  @override
  void onReady() {
    super.onReady();

    if (categoryId != null && categoryId!.isNotEmpty) {
      fetchSubTree(categoryId!);
      fetchServicesByCategory();
    }
  }

  // ================= CATEGORY SELECT =================
  void toggleCategory(String id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }

    selectedCategoryIds.refresh();

    fetchServicesByCategory();
  }

  // ================= FETCH SUB TREE =================
  Future<void> fetchSubTree(String categoryId) async {
    try {
      isLoadingTree.value = true;

      final response = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/category/$categoryId/sub-tree",
      );

      if (response.statusCode == 200 &&
          response.data["success"] == true &&
          response.data["data"] != null) {
        categoryTree.value = response.data["data"];
      } else {
        categoryTree.value = null;
      }
    } catch (e) {
      print("Sub Tree Error: $e");
      categoryTree.value = null;
    } finally {
      isLoadingTree.value = false;
    }
  }

  // ================= APPLY FILTER =================
  void applyFilters() {
    fetchServicesByCategory();
  }

  // ================= FETCH SERVICES =================
  Future<void> fetchServicesByCategory() async {
    try {
      isLoadingServices.value = true;

      final selectedIds = selectedCategoryIds.toList();

      final finalCategoryId =
      selectedIds.isNotEmpty ? selectedIds.first : categoryId;

      if (finalCategoryId == null || finalCategoryId.isEmpty) {
        services.clear();
        return;
      }

      final response = await dio.post(
        "${ApiConstants.baseUrl}/api/v1/service/by-category",
        data: {
          "categoryId": finalCategoryId,
          "service_subCategory": selectedSubCategoryId.value,
          "service_childCategory": selectedChildCategoryId.value,
          "lon": 90.4800,
          "lat": 23.8700,
          "searchTerm": searchText.value.trim(),
          "minRating": minRatingValue,
          "radius": radiusValue,
          "availability": availabilityValue,
        },
      );

      print("Category: $finalCategoryId");
      print("Sub Category: ${selectedSubCategoryId.value}");
      print("Child Category: ${selectedChildCategoryId.value}");

      print("Service Response: ${response.data}");

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        final List data = response.data["data"];

        services.value = data
            .map(
              (item) => ServiceModel(
            id: item["_id"] ?? "",

            title: item["service_name"] ?? "",

            image: item["company_logo"] ?? "",

            rating:
            (item["averageRating"] ?? 0)
                .toDouble(),

            distance:
            (item["distanceInMiles"] ?? 0)
                .toDouble(),

            schedule:
            "${item["openingTime"] ?? ""} - ${item["closingTime"] ?? ""}",

            location:
            item["service_address"] ?? "",

            category: "",
            about: "",
            servicesOffered: "",
            highlights: [],
            reviews: [],
          ),
        )
            .toList();
      } else {
        services.clear();
      }
    } catch (e) {
      print("Service API Error: $e");
      services.clear();
    } finally {
      isLoadingServices.value = false;
    }
  }


  void selectSubCategory(String id) {
    selectedSubCategoryId.value = id;
    fetchServicesByCategory();
  }

  void selectChildCategory(String id) {
    selectedChildCategoryId.value = id;
    fetchServicesByCategory();
  }

  // ================= FILTER VALUE =================
  double? get minRatingValue {
    if (selectedRating.value == "Rating" ||
        selectedRating.value == "All") {
      return null;
    }

    return double.tryParse(
      selectedRating.value.replaceAll("+", ""),
    );
  }

  int? get radiusValue {
    if (selectedRadius.value == "Radius" ||
        selectedRadius.value == "All") {
      return null;
    }

    return int.tryParse(
      selectedRadius.value
          .replaceAll("mile", "")
          .replaceAll(" ", ""),
    );
  }

  bool? get availabilityValue {
    if (selectedAvailability.value == "Availability" ||
        selectedAvailability.value == "All") {
      return null;
    }

    return selectedAvailability.value == "Available";
  }
}