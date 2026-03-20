import 'dart:math';
import 'package:get/get.dart';

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

  /// Generate random demo data
  List<double> _generateData(int count) {
    return List.generate(count, (index) => _random.nextInt(150).toDouble() + 20);
  }

  void _updateImpressionData() {
    if (selectedImpressionFilter.value == "Week") {
      impressionData.value = _generateData(7);
    } else if (selectedImpressionFilter.value == "Month") {
      impressionData.value = _generateData(30);
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