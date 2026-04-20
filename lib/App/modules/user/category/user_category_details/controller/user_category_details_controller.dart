import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../services/contants/api_constants.dart';
import '../user_category_model/service_model.dart';

class UserCategoryDetailsController extends GetxController {
  final Dio dio = Dio();

  var isLoadingTree = false.obs;

  /// ROOT TREE DATA
  var categoryTree = Rxn<Map<String, dynamic>>();

  String? categoryId;

  var selectedCategoryIds = <String>{}.obs;

  var searchText = ''.obs;

  var selectedRating = 'Rating'.obs;
  var selectedRadius = 'Radius'.obs;
  var selectedAvailability = 'Availability'.obs;

  var isLoadingServices = false.obs;
  var apiServices = <ServiceModel>[].obs;

  var generalPlumbing = false.obs;
  var leakDetection = false.obs;

  var services = <ServiceModel>[].obs;

  // Plumbing options
  var plumbingOptions = <String, bool>{
    'General Plumbing': false,
    'Leak Detection & Repair': false,
    'Drain Cleaning': false,
  }.obs;

  // Electrical options
  var electricalOptions = <String, bool>{
    'General Electrician': false,
    'Leak Detection & Repair': false,
  }.obs;

  @override
  void onInit() {
    super.onInit();

    /// ONLY store args here
    final args = Get.arguments;
    categoryId = args != null ? args['id'] : null;

    print("ON INIT ID: $categoryId");
  }

  @override
  void onReady() {
    super.onReady();

    if (categoryId != null) {
      fetchSubTree(categoryId!);

      /// load root category services immediately
      fetchServicesByCategory();
    }
  }

  void toggleCategory(String id, {List? children}) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }

    selectedCategoryIds.refresh();

    /// 🔥 CALL API AFTER SELECTION
    fetchServicesByCategory();
  }

  /// FETCH SUB TREE API
  Future<void> fetchSubTree(String categoryId) async {
    try {
      isLoadingTree.value = true;

      final response = await dio.get(
        '${ApiConstants.baseUrl}/api/v1/category/$categoryId/sub-tree',
      );

      if (response.statusCode == 200 &&
          response.data["success"] == true &&
          response.data["data"] != null) {
        categoryTree.value = response.data["data"];
      } else {
        categoryTree.value = null;
      }
    } catch (e) {
      print("SubTree Error: $e");
      categoryTree.value = null;
    } finally {
      isLoadingTree.value = false;
    }
  }

  void applyFilters() {
    fetchServicesByCategory();
  }

  Future<void> fetchServicesByCategory() async {
    try {
      isLoadingServices.value = true;

      final selectedIds = selectedCategoryIds.toList();

      /// ✅ Use selected checkbox id first
      /// ✅ Otherwise use page clicked category id
      final String? finalCategoryId = selectedIds.isNotEmpty ? selectedIds.first : categoryId;

      print("Selected IDs: $selectedIds");
      print("Final Category ID: $finalCategoryId");

      if (finalCategoryId == null || finalCategoryId.isEmpty) {
        services.clear();
        return;
      }

      final response = await dio.post(
        '${ApiConstants.baseUrl}/api/v1/service/by-category',
        data: {
          "categoryId": finalCategoryId,
          "lon": 90.4800,
          "lat": 23.8700,
          "searchTerm": searchText.value.trim(),
          "minRating": minRatingValue,
          "radius": radiusValue,
          "availability": availabilityValue,
        },
      );

      print("Service Response: ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List data = response.data["data"];

        services.value = data.map((item) {
          return ServiceModel(
            title: item["service_name"] ?? "",
            image: item["company_logo"] ?? "assets/images/trade&service.png",
            rating: (item["averageRating"] ?? 0).toDouble(),
            distance: (item["distanceInMiles"] ?? 0).toDouble(),
            schedule: "${item["openingTime"]} - ${item["closingTime"]}",
            location: item["service_address"] ?? "",
            category: "",
            about: "",
            servicesOffered: "",
            highlights: [],
            reviews: [],
          );
        }).toList();
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

  double? get minRatingValue {
    if (selectedRating.value == "Rating" || selectedRating.value == "All") {
      return null;
    }
    return double.tryParse(selectedRating.value.replaceAll('+', ''));
  }

  int? get radiusValue {
    if (selectedRadius.value == "Radius" || selectedRadius.value == "All") {
      return null;
    }
    return int.tryParse(selectedRadius.value.replaceAll('km', ''));
  }

  bool? get availabilityValue {
    if (selectedAvailability.value == "Availability" || selectedAvailability.value == "All") {
      return null;
    }
    return selectedAvailability.value == "Available";
  }
}
