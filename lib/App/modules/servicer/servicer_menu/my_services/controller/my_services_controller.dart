import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../model/my_service_model.dart';

class MyServicesController extends GetxController {
  final Dio dio;

  MyServicesController({required this.dio});

  final RxList<MyServiceModel> services = <MyServiceModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyServices();
  }

  String get currentPlanName {
    if (services.isEmpty) {
      return "";
    }

    return services.first.planName.trim().toLowerCase();
  }

  bool get canAddService {
    return currentPlanName == "elite" || currentPlanName == "pro";
  }

  Future<void> createNewService() async {
    final StorageService storage = StorageService();

    final String planId =
        storage.planId?.trim() ?? "";

    if (!_isValidMongoId(planId)) {
      await storage.remove("planId");

      Get.snackbar(
        "Plan ID Missing",
        "A valid active plan ID was not found.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final result = await Get.toNamed(
      AppRoutes.SERVICE_PROVIDER_ACCOUNT,
      arguments: {
        "mode": "additional-service",
        "source": "my-services",
        "planId": planId,
        "planName": currentPlanName,
      },
    );

    if (result == true) {
      await fetchMyServices(
        showLoading: false,
      );
    }
  }

  bool _isValidMongoId(String value) {
    return RegExp(
      r'^[a-fA-F0-9]{24}$',
    ).hasMatch(value.trim());
  }

  Future<void> editService(MyServiceModel service) async {
    final String selectedServiceId = service.id.trim();

    if (selectedServiceId.isEmpty) {
      Get.snackbar(
        "Error",
        "Service ID not found",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final result = await Get.toNamed(
      AppRoutes.SERVICE_PROVIDER_ACCOUNT_EDIT,
      arguments: {"serviceId": selectedServiceId},
    );

    if (result == true) {
      await fetchMyServices(showLoading: false);
    }
  }

  Future<void> fetchMyServices({bool showLoading = true}) async {
    if (isLoading.value) return;

    try {
      if (showLoading) {
        isLoading.value = true;
      }

      errorMessage.value = '';

      final response = await dio.get('/api/v1/service/my-service');

      log('My services response: ${response.data}');

      if (response.data is! Map) {
        throw Exception('Invalid server response');
      }

      final responseData = Map<String, dynamic>.from(response.data as Map);

      if (responseData['success'] != true) {
        throw Exception(
          responseData['message']?.toString() ?? 'Unable to retrieve services',
        );
      }

      final dynamic rawServices = responseData['data'];

      if (rawServices is! List) {
        services.clear();
        return;
      }

      final parsedServices = rawServices
          .whereType<Map>()
          .map(
            (item) => MyServiceModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      services.assignAll(parsedServices);
    } on DioException catch (error) {
      log('My services Dio error: ${error.response?.data}');

      errorMessage.value = _getErrorMessage(error);
    } catch (error, stackTrace) {
      log('My services error: $error', stackTrace: stackTrace);

      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshServices() async {
    await fetchMyServices(showLoading: false);
  }

  String _getErrorMessage(DioException error) {
    final dynamic data = error.response?.data;

    if (data is Map) {
      final message = data['message'];

      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'Please check your internet connection.';

      default:
        return 'Unable to load your services.';
    }
  }
}
