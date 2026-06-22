import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/services/storage_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../models/ReviewModel.dart';

class ServiceDetailsController extends GetxController {
  final Dio dio = Dio();
  final StorageService storage = Get.find<StorageService>();

  RxBool isLoading = false.obs;

  late String serviceId;

  RxString image = ''.obs;
  RxString title = ''.obs;
  RxString category = ''.obs;
  RxDouble rating = 0.0.obs;
  RxString schedule = ''.obs;
  RxString location = ''.obs;
  RxString about = ''.obs;
  RxString website = ''.obs;
  RxString phone = ''.obs;
  RxString providerId = ''.obs;
  RxString providerName = ''.obs;

  var media = <String>[].obs;

  final latitude = 23.8103.obs;
  final longitude = 90.4125.obs;

  GoogleMapController? mapController;
  final logger = Logger();
  RxList<String> servicesOffered = <String>[].obs;
  var highlightServices = <Map<String, dynamic>>[].obs;
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;

  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();

    print("Get.arguments = ${Get.arguments}");

    final args = Get.arguments ?? {};
    serviceId = args["id"] ?? '';

    print("serviceId = $serviceId");

    fetchServiceDetails();
    fetchReviews();
  }

  Future<void> fetchServiceDetails() async {
    try {
      isLoading.value = true;

      print("serviceId = $serviceId");
      print("URL = ${ApiConstants.baseUrl}/api/v1/service/$serviceId");

      final response = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/service/$serviceId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
        ),
      );

      print("STATUS = ${response.statusCode}");
      print("DATA = ${response.data}");

      final data = response.data["data"];

      if (data["location"] != null &&
          data["location"]["coordinates"] != null) {

        final coordinates = data["location"]["coordinates"];

        longitude.value = (coordinates[0] as num).toDouble();
        latitude.value = (coordinates[1] as num).toDouble();

        print("LAT = ${latitude.value}");
        print("LNG = ${longitude.value}");

        mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(latitude.value, longitude.value),
          ),
        );
      }

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent(
        '    ',
      ).convert(data);

      // LOGGER PRINT
      logger.i(prettyJson);

      if (response.statusCode == 200 && response.data["success"] == true) {
        final data = response.data["data"];

        providerId.value = data["provider"]?["_id"] ?? '';
        providerName.value = data["provider"]?["name"] ?? '';

        print("API provider = ${data["provider"]}");
        print("providerId = ${providerId.value}");
        print("providerName = ${providerName.value}");

        image.value = data["company_logo"] ?? '';
        title.value = data["service_name"] ?? '';
        category.value = data["service_category"]?["name"] ?? '';
        about.value = data["about"] ?? '';
        website.value = data["website_link"] ?? '';
        phone.value = data["phone"].toString();

        location.value = data["location"]?["address"] ?? '';

        schedule.value = "${data["openingTime"]} - ${data["closingTime"]}";

        // Services Offered
        servicesOffered.value = (data["offer_services"] as List)
            .map((e) => e["name"].toString())
            .toList();

        highlightServices.value = List<Map<String, dynamic>>.from(data["highlight_services"] ?? []);

        // Highlights = media
        media.value = List<String>.from(data["media"] ?? []);
      }
    } catch (e) {
      print("ERROR DETAILS: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callNumber(String phone) async {
    final cleanPhone = phone.startsWith('+') ? phone : '+$phone';

    final Uri uri = Uri.parse("tel:$cleanPhone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openWebsite(String url) async {
    try {
      final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Cannot open website");
      }
    } catch (e) {
      Get.snackbar("Error", "Invalid URL");
      print("Launch error: $e");
    }
  }

  // reviews part
  Future<void> fetchReviews() async {
    try {
      final response = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/review/service/$serviceId",
        options: Options(headers: {"accesstoken": storage.accessToken}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List data = response.data["data"];

        reviews.value = data.map((e) => ReviewModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Review Error: $e");
    }
  }
}
