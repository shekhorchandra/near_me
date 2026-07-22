import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import '../../../../data/services/storage_service.dart';
import '../../../auth/internet/controller/internet_controller.dart';
import '../../../servicer/notification/controllers/notification_controller.dart';
import '../../../services/contants/api_constants.dart';
import '../../../services/geolocator_helper/current_location_picker.dart';
import '../controller/marker_generator.dart';
import '../model/CategoryModel.dart';
import '../model/HomeServiceModel.dart';

class HomeController extends GetxController
    with WidgetsBindingObserver {
  /// STORAGE
  final StorageService storage = StorageService();

  /// STATE
  RxList<HomeServiceModel> services = <HomeServiceModel>[].obs;
  RxList<HomeServiceModel> filteredServices = <HomeServiceModel>[].obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  final RxBool isLoggedIn = false.obs;

  RxSet<Polyline> polylines = <Polyline>{}.obs;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  Rxn<Position> currentPosition = Rxn<Position>();

  RxBool isLoading = false.obs;
  RxSet<Circle> circles = <Circle>{}.obs;

  GoogleMapController? mapController;
  PageController pageController = PageController(viewportFraction: .85);

  /// FILTERS
  RxDouble selectedRating = 0.0.obs;
  RxDouble selectedRadius = 10.0.obs;
  RxList<String> selectedCategories = <String>[].obs;

  late final NotificationController notificationController;

  final searchController = TextEditingController();

  final RxList<HomeServiceModel> searchResults = <HomeServiceModel>[].obs;

  final RxBool isSearching = false.obs;

  final RxList<HomeServiceModel> searchSuggestions = <HomeServiceModel>[].obs;

  final logger = Logger();

  final Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    isLoggedIn.value =
        storage.accessToken != null &&
            storage.accessToken!.isNotEmpty;

    notificationController = Get.put(NotificationController());

    loadNearestServices();
    loadCategories();

    if (isLoggedIn.value) {
      notificationController.fetchNotifications();
    }
  }

  @override
  void onReady() {
    super.onReady();

    final token = Get.find<StorageService>().accessToken;

    if (token == null || token.isEmpty) return;

    loadNearestServices();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadNearestServices();
    }
  }

  void checkLoginStatus() {
    final token = storage.accessToken;

    isLoggedIn.value = token != null && token.isNotEmpty;
  }

  /// ==================================================
  /// GET NEAREST SERVICES API
  /// ==================================================

  Future<void> loadNearestServices() async {
    // final internet = Get.find<InternetController>();
    //
    // if (!internet.isConnected.value) {
    //   Get.snackbar(
    //     "No Internet",
    //     "Please check your internet connection.",
    //   );
    //   return;
    // }
    try {
      isLoading.value = true;

      /// LOCATION
      Position? position = await getCurrentLocation();

      if (position == null) {
        print(" POSITION IS NULL - STOP API CALL");
        return;
      }

      /// TOKEN
      final token = storage.accessToken;

      /// BODY
      final body = {
        "lon": position.longitude,
        "lat": position.latitude,
        "radius": selectedRadius.value.toInt(),
        "minRating": selectedRating.value,
        "categories": selectedCategories.toList(),
      };

      /// PRINT LOCATION
      print("\n=========== LOCATION ===========");
      print("LAT: ${position.latitude}");
      print("LNG: ${position.longitude}");

      /// PRINT BODY (FULL JSON)
      print("\n=========== REQUEST BODY ===========");
      print(jsonEncode(body));

      /// PRINT TOKEN
      print("\n=========== TOKEN ===========");
      print(token);

      final response = await dio.post(
        ApiConstants.nearestService,
        data: body,
        options: Options(
          headers: {"Authorization": token, "Content-Type": "application/json"},
        ),
      );

      /// PRINT RESPONSE
      print("\n=========== RESPONSE ===========");
      print(response.data);

      drawRadiusCircle(position.latitude, position.longitude);

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent(
        '    ',
      ).convert(response.data);

      // LOGGER PRINT
      logger.i(prettyJson);

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List data = response.data["data"];

        services.value = data.map((e) => HomeServiceModel.fromMap(e)).toList();

        filteredServices.value = services;

        await generateMarkers();

        /// ONLY selected radius show on first load
        fitMapToRadius(
          position.latitude,
          position.longitude,

          // if (services.isNotEmpty) {
          //   fitMapToRadius(position.latitude, position.longitude);
          //
          //   Future.delayed(const Duration(milliseconds: 500), () {
          //   }
        );
        // }
        // else {
        //     fitMapToRadius(position.latitude, position.longitude);
        //   }
      }
    } catch (e) {
      print("Nearest Service Error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchServices() async {
    try {
      final keyword = searchController.text.trim();

      if (keyword.isEmpty) {
        searchSuggestions.clear();
        await loadNearestServices();
        return;
      }

      isSearching.value = true;

      final position = await getCurrentLocation();

      if (position == null) {
        Get.snackbar("Error", "Unable to get current location");
        return;
      }

      final response = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/service/search",
        queryParameters: {
          "lon": position.longitude,
          "lat": position.latitude,
          "searchTerm": keyword,
          "viewAll": true,
        },
        options: Options(
          headers: {
            "Authorization": storage.accessToken,
            "accesstoken": storage.accessToken,
          },
        ),
      );

      logger.i(response.data);

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List data = response.data["data"];

        final results = data.map((e) => HomeServiceModel.fromMap(e)).toList();

        // Suggestions for dropdown
        searchSuggestions.value = results;

        // Update map & bottom cards
        filteredServices.value = results;
        services.value = results;

        await generateMarkers();

        if (results.isNotEmpty) {
          fitMapToServices(results);
        }
      }
    } catch (e) {
      logger.e(e);
      Get.snackbar("Error", "Search failed");
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final res = await dio.get("/api/v1/category");

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent('    ').convert(res.data);

      // LOGGER PRINT
      logger.i(prettyJson);

      if (res.statusCode == 200 && res.data["success"] == true) {
        final List data = res.data["data"];

        categories.value = data.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Category Error => $e");
    }
  }

  Future<void> showRouteToService(double destLat, double destLng) async {
    final pos = await getCurrentLocation();

    if (pos == null) return;

    // final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final apiKey = "AIzaSyAsQyXRVGiL_q3YRfT9nihCt1AUz7mVuQk";

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("Google Maps API key not found");
    }

    PolylinePoints polylinePoints = PolylinePoints(apiKey: apiKey);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pos.latitude, pos.longitude),
        destination: PointLatLng(destLat, destLng),
        mode: TravelMode.driving,
      ),
    );

    print("STATUS => ${result.status}");
    print("ERROR => ${result.errorMessage}");
    print("POINTS => ${result.points.length}");

    if (result.points.isNotEmpty) {
      final routePoints = result.points
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList();

      polylines.assignAll({
        Polyline(
          polylineId: const PolylineId("route"),
          points: routePoints,
          width: 8,
          color: Colors.black,
        ),
      });

      fitPolyline(routePoints);
    }
  }

  void fitPolyline(List<LatLng> points) {
    if (mapController == null || points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        70,
      ),
    );
  }

  /// ==================================================
  /// APPLY FILTER
  /// ==================================================
  Future<void> applyFilters() async {
    await loadNearestServices();
  }

  /// ==================================================
  /// GENERATE MARKERS
  /// ==================================================
  Future<void> generateMarkers() async {
    final Set<Marker> tempMarkers = {};

    for (var service in services) {
      String type;

      if (service.rating >= 4.7) {
        type = "Elite";
      } else if (service.rating >= 4.0) {
        type = "Pro";
      } else if (service.available) {
        type = "Basic";
      } else {
        type = "Other";
      }

      const svgString = '''
<svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 24.5454C0 10.9893 10.9894 0 24.5455 0H35.4546C49.0106 0 60 10.9893 60 24.5454C60 38.1015 48.8894 49.0909 35.3333 49.0909L30.4492 59.0812C30.2664 59.455 29.7336 59.455 29.5508 59.0812L24.6667 49.0909C11.1106 49.0909 0 38.1015 0 24.5454Z" fill="white"/>
</svg>
''';

      BitmapDescriptor icon = await MarkerGenerator.svgToBitmapDescriptor(
        svgString: svgString,
        size: const Size(140, 140),
        gradient: getMarkerGradient(type),
        icon: getMarkerIcon(type),
        category: Icons.store,
        badgeLabel: type,
        badgeGradient: getMarkerGradient(type),
      );

      tempMarkers.add(
        Marker(
          markerId: MarkerId(service.id),
          position: LatLng(service.lat, service.lng),
          icon: icon,
          infoWindow: InfoWindow(
            title: service.title,
            snippet: "${service.distance.toStringAsFixed(1)} miles away",
          ),
          onTap: () => focusService(service),
        ),
      );
    }

    markers.value = tempMarkers;
  }

  /// ==================================================
  /// MAP FOCUS
  /// ==================================================
  // focusService() change korun

  void focusService(HomeServiceModel service, {int? index}) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(service.lat, service.lng), zoom: 15),
      ),
    );

    if (index != null) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void fitMapToRadius(double lat, double lng) {
    if (mapController == null) return;

    final radiusMiles = selectedRadius.value;
    final radiusKm = radiusMiles * 1.60934;

    final latDelta = radiusKm / 111.0;

    final lngDelta = radiusKm / (111.0 * cos(lat * 3.1415926535 / 180));

    final bounds = LatLngBounds(
      southwest: LatLng(lat - latDelta, lng - lngDelta),
      northeast: LatLng(lat + latDelta, lng + lngDelta),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  /// ==================================================
  /// OPEN DETAILS PAGE
  /// ==================================================
  void openService(HomeServiceModel service) {
    print("Service ID => ${service.id}");
  }

  void drawRadiusCircle(double lat, double lng) {
    circles.value = {
      Circle(
        circleId: const CircleId("radius_circle"),
        center: LatLng(lat, lng),
        radius: selectedRadius.value * 1609.34, // miles → meters
        fillColor: Colors.blue.withOpacity(0.15),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    };
  }

  /// ==================================================
  /// DESIGN HELPERS
  /// ==================================================
  LinearGradient getMarkerGradient(String type) {
    switch (type) {
      case 'Elite':
        return const LinearGradient(colors: [Colors.black, Color(0xFF7161AA)]);

      case 'Pro':
        return const LinearGradient(colors: [Colors.black, Color(0xFFFFA800)]);

      case 'Basic':
        return const LinearGradient(colors: [Colors.black, Color(0xFF4B9B69)]);

      default:
        return const LinearGradient(colors: [Colors.black, Colors.blue]);
    }
  }

  IconData getMarkerIcon(String type) {
    switch (type) {
      case 'Elite':
        return Iconsax.crown1;

      case 'Pro':
        return Iconsax.star1;

      case 'Basic':
        return Iconsax.shield_security;

      default:
        return Icons.location_pin;
    }
  }

  /// get bottom sheet for filter
  // void showFilterBottomSheet() {
  //   Get.bottomSheet(
  //     Container(
  //       padding: const EdgeInsets.all(20),
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const Text(
  //             "Filter Services",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //
  //           const SizedBox(height: 20),
  //
  //           /// Rating
  //           Obx(
  //             () => Slider(
  //               value: selectedRating.value,
  //               min: 0,
  //               max: 5,
  //               divisions: 5,
  //               label: selectedRating.value.toString(),
  //               onChanged: (value) {
  //                 selectedRating.value = value;
  //               },
  //             ),
  //           ),
  //
  //           /// Radius
  //           Obx(
  //             () => Slider(
  //               value: selectedRadius.value,
  //               min: 1,
  //               max: 50,
  //               divisions: 49,
  //               label: "${selectedRadius.value.toInt()} miles",
  //               onChanged: (value) {
  //                 selectedRadius.value = value;
  //               },
  //             ),
  //           ),
  //
  //           const SizedBox(height: 15),
  //
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton(
  //               onPressed: () async {
  //                 Get.back();
  //                 await applyFilters();
  //               },
  //               child: const Text("Apply Filter"),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void showFilterBottomSheet() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
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

              const SizedBox(height: 25),

              /// RATING LABEL
              const Text(
                "Rating",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              /// RATING SLIDER
              Obx(
                () => Slider(
                  value: selectedRating.value,
                  min: 0,
                  max: 5,
                  divisions: 5,
                  activeColor: Colors.black,
                  label: selectedRating.value.toString(),
                  onChanged: (value) {
                    selectedRating.value = value;
                  },
                ),
              ),

              const SizedBox(height: 15),

              /// RADIUS HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Radius",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${selectedRadius.value.toInt()} miles",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// RADIUS SLIDER
              Obx(
                () => Slider(
                  value: selectedRadius.value,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  activeColor: Colors.black,
                  label: "${selectedRadius.value.toInt()} miles",
                  onChanged: (value) {
                    selectedRadius.value = value;
                  },
                ),
              ),


              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();
                    await applyFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Apply Filter",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fitMapToServices(List<HomeServiceModel> services) {
    if (services.isEmpty) return;

    double minLat = services.first.lat;
    double maxLat = services.first.lat;
    double minLng = services.first.lng;
    double maxLng = services.first.lng;

    for (var s in services) {
      if (s.lat < minLat) minLat = s.lat;
      if (s.lat > maxLat) maxLat = s.lat;
      if (s.lng < minLng) minLng = s.lng;
      if (s.lng > maxLng) maxLng = s.lng;
    }

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80, // padding
      ),
    );
  }
}
