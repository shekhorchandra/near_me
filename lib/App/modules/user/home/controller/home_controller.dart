import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:near_me/App/modules/user/home/controller/marker_generator.dart';

import '../../../../core/widgets/App_button.dart';
import '../model/HomeServiceModel.dart';

class HomeController extends GetxController {
  /// Filtered services list (for search/filter)
  RxList<HomeServiceModel> filteredServices = <HomeServiceModel>[].obs;

  /// Map controller
  GoogleMapController? mapController;

  /// PageView controller
  PageController pageController = PageController(viewportFraction: 0.85);

  /// Services list
  RxList<HomeServiceModel> services = <HomeServiceModel>[].obs;

  /// Map markers
  RxSet<Marker> markers = <Marker>{}.obs;

  /// Loading state
  RxBool isLoading = false.obs;

  // Category counts for badges
  RxMap<String, int> categoryCounts = <String, int>{}.obs;

  // Marker types
  // Example: 'Elite', 'Pro', 'Active', 'Other'
  RxMap<String, BitmapDescriptor> markerIcons = <String, BitmapDescriptor>{}.obs;

  RxDouble selectedRating = 0.0.obs;
  RxDouble selectedRadius = 10.0.obs;
  RxList<String> selectedCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadServices();
    filteredServices.value = services;
    updateCategoryCounts();
    generateMarkers();
  }

  /// get bottom sheet for filter
  void showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            const Center(
              child: Text(
                "Filter Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            /// RATING
            const Text("Rating", style: TextStyle(fontWeight: FontWeight.w600)),
            Obx(
              () => Slider(
                value: selectedRating.value,
                min: 0,
                max: 5,
                divisions: 5,
                activeColor: Colors.black,
                label: selectedRating.value.toString(),
                onChanged: (value) => selectedRating.value = value,
              ),
            ),
            const SizedBox(height: 10),

            /// RADIUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Radius", style: TextStyle(fontWeight: FontWeight.w600)),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${(selectedRadius.value * 0.621371).toStringAsFixed(0)} miles",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Slider(
                value: selectedRadius.value.clamp(1, 50),
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: Colors.black,
                label: "${(selectedRadius.value * 0.621371).toStringAsFixed(0)} miles",
                onChanged: (value) => selectedRadius.value = value,
              ),
            ),
            const SizedBox(height: 15),

            /// CATEGORY
            const Text("Category", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ["Car Wash", "Bike Repair", "Auto Service", "Cleaning"].map((category) {
                  final selected = selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () {
                      if (selected) {
                        selectedCategories.remove(category);
                      } else {
                        selectedCategories.add(category);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 25),

            /// BUTTONS
            Row(
              children: [
                /// CLEAR BUTTON
                Expanded(
                  child: AppButton(
                    text: "Clear",
                    onPressed: () {
                      selectedRating.value = 0;
                      selectedRadius.value = 10;
                      selectedCategories.clear();
                      applyFilters();
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 10),

                /// APPLY BUTTON
                Expanded(
                  child: AppButton(
                    text: "Apply Filters",
                    onPressed: () {
                      applyFilters();
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateCategoryCounts() {
    final Map<String, int> counts = {};
    for (var service in services) {
      counts[service.category] = (counts[service.category] ?? 0) + 1;
    }
    categoryCounts.value = counts;
  }

  LinearGradient getMarkerGradient(String type) {
    if (type == 'Elite') {
      return LinearGradient(
        colors: [Color(0xFF000000), Color(0xFF7161AA)],
        begin: .topCenter,
        end: .center,
      );
    } else if (type == 'Pro') {
      return LinearGradient(colors: [Color(0xFF000000), Color(0xFFFFA800)]);
    } else if (type == 'Basic') {
      return LinearGradient(colors: [Color(0xFF000000), Color(0xFF4B9B69)]);
    }

    return LinearGradient(colors: [Color(0xFF000000), Color(0xFF3612FF)]);
  }

  IconData getMarkerIcon(String type) {
    if (type == 'Elite') {
      return Iconsax.crown1;
    } else if (type == 'Pro') {
      return Iconsax.star1;
    } else if (type == 'Basic') {
      return Iconsax.shield_security;
    }

    return Icons.broken_image;
  }

  void generateMarkers() async {
    final Set<Marker> tempMarkers = {};

    for (var service in services) {
      String type;

      if (service.rating >= 4.7) {
        type = 'Elite';
      } else if (service.rating >= 4.3) {
        type = 'Pro';
      } else if (service.available) {
        type = 'Basic';
      } else {
        type = 'Other';
      }

      // Define the SVG string (Make sure fill is white so it accepts gradient)
      const String svgString = '''
    <svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M0 24.5454C0 10.9893 10.9894 0 24.5455 0H35.4546C49.0106 0 60 10.9893 60 24.5454C60 38.1015 48.8894 49.0909 35.3333 49.0909L30.4492 59.0812C30.2664 59.455 29.7336 59.455 29.5508 59.0812L24.6667 49.0909C11.1106 49.0909 0 38.1015 0 24.5454Z" fill="white"/>
    </svg>
    ''';

      // Generate the complex marker
      final double screenWidth =
          ui.PlatformDispatcher.instance.views.first.physicalSize.width /
          ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

      final bool isSmallScreen = screenWidth < 400;

      BitmapDescriptor customIcon = await MarkerGenerator.svgToBitmapDescriptor(
        svgString: svgString,
        size: isSmallScreen ? Size(80, 80) : Size(160, 160),
        gradient: getMarkerGradient(type),
        icon: getMarkerIcon(type),
        badgeLabel: type, // 'Elite', 'Pro', 'Basic'
        badgeGradient: getMarkerGradient(type), // reuse or define a separate badge gradient
      );

      tempMarkers.add(
        Marker(
          markerId: MarkerId(service.id),
          position: LatLng(service.lat, service.lng),
          icon: customIcon,
          infoWindow: InfoWindow(title: service.title, snippet: "$type Service"),
          onTap: () => focusService(service),
        ),
      );
    }
    markers.value = tempMarkers;
  }

  void loadServices() {
    /// Dummy data (replace with API)
    services.value = [
      HomeServiceModel(
        id: "1",
        title: "Car Wash",
        rating: 4.5,
        distance: 1.2,
        available: true,
        lat: 23.77002871396432,
        lng: 90.41767335602759,
        category: 'Full load',
      ),
      HomeServiceModel(
        id: "2",
        title: "Bike Repair",
        rating: 4.2,
        distance: 2.1,
        available: true,
        lat: 25.707178456987403,
        lng: 89.40034264802111,
        category: 'Trade and startup',
      ),
      HomeServiceModel(
        id: "3",
        title: "Auto Service",
        rating: 4.8,
        distance: 3.0,
        available: false,
        lat: 23.450936186653884,
        lng: 87.81394250424515,
        category: 'car abd bike wash',
      ),

      HomeServiceModel(
        id: "4",
        title: "Auto moto",
        rating: 2.8,
        distance: 3.0,
        available: false,
        lat: 40.741895,
        lng: -73.989308,
        category: 'car abd bike wash',
      ),

      HomeServiceModel(
        id: "5",
        title: "Service",
        rating: 2.2,
        distance: 1.2,
        available: true,
        lat: 24.811516368950436,
        lng: 88.94157331547738,
        category: 'Full load',
      ),

      HomeServiceModel(
        id: "6",
        title: "Service",
        rating: 4.5,
        distance: 1.2,
        available: true,
        lat: 23.53135973516676,
        lng: 90.12162702073485,
        category: 'Full load',
      ),
    ];

    generateMarkers();
  }

  void applyFilters() {
    final rating = selectedRating.value;
    final radius = selectedRadius.value;

    filteredServices.value = services.where((service) {
      final matchRating = service.rating >= rating;

      final matchRadius = service.distance <= radius;

      final matchCategory =
          selectedCategories.isEmpty || selectedCategories.contains(service.category);

      return matchRating && matchRadius && matchCategory;
    }).toList();
  }

  void focusService(HomeServiceModel service) {
    mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(service.lat, service.lng)));
  }

  void openService(HomeServiceModel service) {
    /// Navigate to details page
    print("Open service: ${service.title}");
  }
}
