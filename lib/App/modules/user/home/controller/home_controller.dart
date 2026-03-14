import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/HomeServiceModel.dart';

class HomeController extends GetxController {

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

  @override
  void onInit() {
    super.onInit();
    loadServices();
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
      ),
      HomeServiceModel(
        id: "2",
        title: "Bike Repair",
        rating: 4.2,
        distance: 2.1,
        available: true,
        lat: 23.8140,
        lng: 90.4170,
      ),
      HomeServiceModel(
        id: "3",
        title: "Auto Service",
        rating: 4.8,
        distance: 3.0,
        available: false,
        lat: 23.8000,
        lng: 90.4200,
      ),
    ];

    generateMarkers();
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