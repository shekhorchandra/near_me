import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../../../services/contants/api_constants.dart';
import '../models/plan_model.dart';

class ChoosePlanController extends GetxController {
  var selectedPlan = Rxn<Plan>();
  var plans = <Plan>[].obs;
  var isLoading = false.obs;
  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;

      // final response = await http.get(
      //   Uri.parse("https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/plans"),
      // );

      final response = await http.get(Uri.parse(ApiConstants.getPlans));

      final data = jsonDecode(response.body);

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent('    ').convert(data);

      // LOGGER PRINT
      logger.i(prettyJson);

      if (data['success']) {
        plans.value = List.from(
          data['data'],
        ).map((e) => Plan.fromApi(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load plans");
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(Plan plan) {
    selectedPlan.value = plan;
  }
}
