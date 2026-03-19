import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../controller/choose_plan_controller.dart';
import '../models/plan_model.dart';

class ChoosePlanView extends GetView<ChoosePlanController> {
  const ChoosePlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChoosePlanController());
    Widget planCard(Plan plan) {
      return GestureDetector(
        onTap: () => controller.selectPlan(plan),
        child: Obx(() {
          bool isSelected = controller.selectedPlan.value == plan;

          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: isSelected ? plan.color : Colors.grey.shade300, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: plan.color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Body
                Expanded(
                  //  VERY IMPORTANT
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price
                        Text(
                          plan.price,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: plan.color,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Features (scrollable if needed)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: plan.features.map((f) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check, size: 16, color: plan.color),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(f, style: const TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Button
                        AppButton(
                          height: 34,
                          onPressed: () => controller.selectPlan(plan),
                          text: 'Select Plan',
                          backgroundColor: isSelected ? plan.color : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    }

    return Scaffold(
      appBar: CommonAppBar(title: 'Choose Your Plan', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.6,
                  children: controller.plans.map(planCard).toList(),
                ),
              ),
              AppButton(
                onPressed: () {
                  if (controller.selectedPlan.value != null) {
                    // Continue action
                    Get.snackbar(
                      "Plan Selected",
                      "You selected ${controller.selectedPlan.value!.name}",
                    );
                  } else {
                    Get.snackbar("Error", "Please select a plan first");
                  }
                },
                text: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
