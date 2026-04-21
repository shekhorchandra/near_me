import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  var media = <String>[].obs;

  RxList<String> servicesOffered = <String>[].obs;
  RxList<String> highlights = <String>[].obs;
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;

  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    serviceId = args["id"] ?? '';

    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    try {
      isLoading.value = true;

      final response = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/service/$serviceId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        final data = response.data["data"];

        image.value = data["company_logo"] ?? '';
        title.value = data["service_name"] ?? '';
        category.value = data["service_category"]?["name"] ?? '';
        about.value = data["about"] ?? '';
        website.value = data["website_link"] ?? '';
        phone.value = data["phone"].toString();

        location.value = data["location"]?["address"] ?? '';

        schedule.value =
        "${data["openingTime"]} - ${data["closingTime"]}";

        // Services Offered
        servicesOffered.value =
            (data["offer_services"] as List)
                .map((e) => e["name"].toString())
                .toList();

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
      final Uri uri = Uri.parse(
        url.startsWith('http') ? url : 'https://$url',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar("Error", "Cannot open website");
      }
    } catch (e) {
      Get.snackbar("Error", "Invalid URL");
      print("Launch error: $e");
    }
  }
}