import 'dart:math';
import 'package:get/get.dart';

import '../../notification/controllers/notification_controller.dart';

class ServiceDashboardController extends GetxController {
  var title = "Dashboard".obs;

  var userName = "James".obs;
  var greeting = "Good morning".obs;
  var planName = "Pro Plan".obs;
  var planPrice = "£19.99/month".obs;
  var renewDate = "21/04/26".obs;

  var totalImpressions = 1250.obs;
  var totalViews = 860.obs;

  var selectedImpressionFilter = "Week".obs;
  var selectedViewsFilter = "Week".obs;

  var impressionData = <double>[].obs;
  var viewsData = <double>[].obs;

  final _random = Random();

  var selectedDate = DateTime.now().obs;

  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  void onInit() {
    super.onInit();
    _updateImpressionData();
    _updateViewsData();
  }

  void changeImpressionFilter(String value) {
    selectedImpressionFilter.value = value;
    _updateImpressionData();
  }

  void changeViewsFilter(String value) {
    selectedViewsFilter.value = value;
    _updateViewsData();
  }

  String getDisplayRange(String filter) {
    final date = selectedDate.value;

    if (filter == "Week") {
      final start = date.subtract(Duration(days: date.weekday - 1));
      final end = start.add(const Duration(days: 6));
      return "${start.day}/${start.month} - ${end.day}/${end.month}";
    } else if (filter == "Month") {
      return "${_monthName(date.month)} ${date.year}";
    } else {
      return "${date.year}";
    }
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  /// Generate random demo data
  List<double> _generateData(int count) {
    return List.generate(
      count,
      (index) => _random.nextInt(150).toDouble() + 20,
    );
  }

  void goToPrevious(String filter) {
    if (filter == "Week") {
      selectedDate.value = selectedDate.value.subtract(const Duration(days: 7));
    } else if (filter == "Month") {
      selectedDate.value = DateTime(
        selectedDate.value.year,
        selectedDate.value.month - 1,
      );
    } else {
      selectedDate.value = DateTime(
        selectedDate.value.year - 1,
        selectedDate.value.month,
      );
    }

    _updateImpressionData();
    _updateViewsData();
  }

  void goToNext(String filter) {
    if (filter == "Week") {
      selectedDate.value = selectedDate.value.add(const Duration(days: 7));
    } else if (filter == "Month") {
      selectedDate.value = DateTime(
        selectedDate.value.year,
        selectedDate.value.month + 1,
      );
    } else {
      selectedDate.value = DateTime(
        selectedDate.value.year + 1,
        selectedDate.value.month,
      );
    }

    _updateImpressionData();
    _updateViewsData();
  }

  void _updateImpressionData() {
    if (selectedImpressionFilter.value == "Week") {
      impressionData.value = _generateData(7);
    } else if (selectedImpressionFilter.value == "Month") {
      final days = DateTime(
        selectedDate.value.year,
        selectedDate.value.month + 1,
        0,
      ).day;
      impressionData.value = _generateData(days);
    } else {
      impressionData.value = _generateData(12);
    }
  }

  void _updateViewsData() {
    if (selectedViewsFilter.value == "Week") {
      viewsData.value = _generateData(7);
    } else if (selectedViewsFilter.value == "Month") {
      viewsData.value = _generateData(30);
    } else {
      viewsData.value = _generateData(12);
    }
  }
}
