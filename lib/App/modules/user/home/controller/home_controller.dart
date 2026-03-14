import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  RxDouble selectedRating = 0.0.obs;
  RxDouble selectedRadius = 10.0.obs;
  RxList<String> selectedCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadServices();
    filteredServices.value = services;
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
        lat: 23.8103,
        lng: 90.4125,
        category: 'Full load',
      ),
      HomeServiceModel(
        id: "2",
        title: "Bike Repair",
        rating: 4.2,
        distance: 2.1,
        available: true,
        lat: 23.8140,
        lng: 90.4170,
        category: 'Trade and startup',
      ),
      HomeServiceModel(
        id: "3",
        title: "Auto Service",
        rating: 4.8,
        distance: 3.0,
        available: false,
        lat: 23.8000,
        lng: 90.4200,
        category: 'car abd bike wash',
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

      final matchCategory = selectedCategories.isEmpty ||
          selectedCategories.contains(service.category);

      return matchRating && matchRadius && matchCategory;

    }).toList();
  }

  void generateMarkers() {

    final Set<Marker> tempMarkers = {};

    for (var service in services) {

      tempMarkers.add(
        Marker(
          markerId: MarkerId(service.id),
          position: LatLng(service.lat, service.lng),
          infoWindow: InfoWindow(title: service.title),
          onTap: () {
            focusService(service);
          },
        ),
      );
    }

    markers.value = tempMarkers;
  }

  void focusService(HomeServiceModel service) {

    mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(service.lat, service.lng),
      ),
    );
  }

  void openService(HomeServiceModel service) {

    /// Navigate to details page
    print("Open service: ${service.title}");
  }
}