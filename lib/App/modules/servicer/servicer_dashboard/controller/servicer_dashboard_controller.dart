import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../data/network/dio_client.dart';
import '../../../services/contants/api_constants.dart';
import '../../notification/controllers/notification_controller.dart';

import '../model/servicer_dashboard_service_model.dart';
import '../views/dashboard_chart_item.dart';

class ServiceDashboardController extends GetxController {
  final DioClient _dioClient = Get.find<DioClient>();

  final NotificationController notificationController =
  Get.find<NotificationController>();

  final title = "Dashboard".obs;

  final userName = "User".obs;
  final greeting = "Good morning".obs;
  final planName = "Free Plan".obs;

  final totalImpressions = 0.obs;
  final totalViews = 0.obs;

  final selectedImpressionFilter = "Week".obs;
  final selectedViewsFilter = "Year".obs;

  final impressionChart = <DashboardChartItem>[].obs;
  final viewChart = <DashboardChartItem>[].obs;

  final isProfileLoading = true.obs;
  final isAnalyticsLoading = false.obs;

  /// The profile API decides whether the entire analytics feature is locked.
  final isFreePlan = true.obs;

  /// The analytics API can lock individual analytics sections.
  final impressionsLocked = true.obs;
  final viewsLocked = true.obs;

  final analyticsType = "none".obs;
  final analyticsError = RxnString();

  bool get shouldLockImpressions {
    return isFreePlan.value || impressionsLocked.value;
  }

  bool get shouldLockViews {
    return isFreePlan.value || viewsLocked.value;
  }

  @override
  void onInit() {
    super.onInit();

    _setGreeting();
    loadDashboard();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      greeting.value = "Good morning";
    } else if (hour < 17) {
      greeting.value = "Good afternoon";
    } else {
      greeting.value = "Good evening";
    }
  }

  String get subscriptionMessage {
    if (isProfileLoading.value) {
      return "Checking your subscription...";
    }

    if (isFreePlan.value) {
      return "You are currently using the ${planName.value}. "
          "Upgrade your plan to unlock dashboard analytics.";
    }

    return "You are currently using the ${planName.value}. "
        "Your dashboard analytics are available.";
  }

  Future<void> loadDashboard() async {
    await fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isProfileLoading.value = true;
      analyticsError.value = null;

      final response = await _dioClient.client.get(
        ApiConstants.user_me,
      );

      if (response.data is! Map) {
        throw const FormatException("Invalid profile response");
      }

      final responseBody = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (responseBody["success"] != true) {
        throw Exception(
          responseBody["message"]?.toString() ??
              "Could not retrieve user profile",
        );
      }

      final rawData = responseBody["data"];

      if (rawData is! Map) {
        throw const FormatException("Profile data is missing");
      }

      final userData = Map<String, dynamic>.from(rawData);

      final rawSubscription = userData["subscriptionInfo"];

      final subscriptionInfo = rawSubscription is Map
          ? Map<String, dynamic>.from(rawSubscription)
          : <String, dynamic>{};

      final currentPlan =
          subscriptionInfo["planName"]
              ?.toString()
              .trim()
              .toLowerCase() ??
              "free";

      userName.value =
      userData["name"]?.toString().trim().isNotEmpty == true
          ? userData["name"].toString().trim()
          : "User";

      planName.value = _formatPlanName(currentPlan);

      isFreePlan.value = currentPlan == "free";

      if (isFreePlan.value) {
        _clearAnalytics();

        impressionsLocked.value = true;
        viewsLocked.value = true;
        analyticsType.value = "none";
      } else {
        await fetchDashboardAnalytics();
      }
    } on DioException catch (error) {
      isFreePlan.value = true;
      _clearAnalytics();

      final message = _getDioErrorMessage(
        error,
        fallback: "Unable to load subscription information",
      );

      Get.snackbar(
        "Profile Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      isFreePlan.value = true;
      _clearAnalytics();

      Get.snackbar(
        "Profile Error",
        "Unable to load subscription information",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> fetchDashboardAnalytics() async {
    if (isFreePlan.value) {
      return;
    }

    try {
      isAnalyticsLoading.value = true;
      analyticsError.value = null;

      final response = await _dioClient.client.get(
        ApiConstants.analyticsDashboard,
        queryParameters: {
          "impressionPeriod":
          selectedImpressionFilter.value.toLowerCase(),
          "viewPeriod": selectedViewsFilter.value.toLowerCase(),
        },
      );

      if (response.data is! Map) {
        throw const FormatException("Invalid analytics response");
      }

      final responseBody = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (responseBody["success"] != true) {
        throw Exception(
          responseBody["message"]?.toString() ??
              "Could not retrieve dashboard analytics",
        );
      }

      final rawData = responseBody["data"];

      if (rawData is! Map) {
        throw const FormatException("Analytics data is missing");
      }

      final data = Map<String, dynamic>.from(rawData);

      totalImpressions.value =
          (data["totalImpressions"] as num?)?.toInt() ?? 0;

      totalViews.value =
          (data["totalViews"] as num?)?.toInt() ?? 0;

      final rawImpressionChart = data["impressionChart"];
      final rawViewChart = data["viewChart"];

      if (rawImpressionChart is List) {
        impressionChart.assignAll(
          rawImpressionChart
              .whereType<Map>()
              .map(
                (item) => DashboardChartItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          ),
        );
      } else {
        impressionChart.clear();
      }

      if (rawViewChart is List) {
        viewChart.assignAll(
          rawViewChart
              .whereType<Map>()
              .map(
                (item) => DashboardChartItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          ),
        );
      } else {
        viewChart.clear();
      }

      final rawLocked = data["locked"];

      final locked = rawLocked is Map
          ? Map<String, dynamic>.from(rawLocked)
          : <String, dynamic>{};

      impressionsLocked.value =
          locked["impressions"] == true;

      viewsLocked.value = locked["views"] == true;

      analyticsType.value =
          data["analyticsType"]?.toString() ?? "none";
    } on DioException catch (error) {
      analyticsError.value = _getDioErrorMessage(
        error,
        fallback: "Unable to load dashboard analytics",
      );

      Get.snackbar(
        "Analytics Error",
        analyticsError.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      analyticsError.value =
      "Unable to load dashboard analytics";

      Get.snackbar(
        "Analytics Error",
        analyticsError.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAnalyticsLoading.value = false;
    }
  }

  Future<void> changeImpressionFilter(String value) async {
    if (selectedImpressionFilter.value == value) {
      return;
    }

    selectedImpressionFilter.value = value;

    await fetchDashboardAnalytics();
  }

  Future<void> changeViewsFilter(String value) async {
    if (selectedViewsFilter.value == value) {
      return;
    }

    selectedViewsFilter.value = value;

    await fetchDashboardAnalytics();
  }

  Future<void> refreshDashboard() async {
    await fetchUserProfile();
  }

  void _clearAnalytics() {
    totalImpressions.value = 0;
    totalViews.value = 0;

    impressionChart.clear();
    viewChart.clear();
  }

  String _formatPlanName(String plan) {
    if (plan.isEmpty) {
      return "Free Plan";
    }

    final normalized = plan
        .replaceAll("_", " ")
        .replaceAll("-", " ")
        .trim();

    final formatted = normalized
        .split(RegExp(r"\s+"))
        .map(
          (word) => word.isEmpty
          ? ""
          : "${word[0].toUpperCase()}${word.substring(1)}",
    )
        .join(" ");

    if (formatted.toLowerCase().endsWith("plan")) {
      return formatted;
    }

    return "$formatted Plan";
  }

  String _getDioErrorMessage(
      DioException error, {
        required String fallback,
      }) {
    final responseData = error.response?.data;

    if (responseData is Map &&
        responseData["message"] != null) {
      return responseData["message"].toString();
    }

    return fallback;
  }
}