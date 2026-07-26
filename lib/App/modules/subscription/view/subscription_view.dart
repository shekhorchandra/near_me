import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../controller/subscription_controller.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> planColors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFFF9800),
    ];

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Premium Plans',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Obx(() {
            return GridView.builder(
              // One extra item for the free plan
              itemCount: controller.products.length + 1,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                // Free plan
                if (index == 0) {
                  return _freePlanCard();
                }

                // Paid products start from index 1
                final product = controller.products[index - 1];
                final planColor =
                planColors[index % planColors.length];

                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 14,
                        ),
                        color: planColor,
                        child: Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.price,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: planColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 17,
                                        color: planColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          product.description.isNotEmpty
                                              ? product.description
                                              : 'Access premium features.',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              AppButton(
                                height: 36,
                                text: 'Subscribe',
                                backgroundColor: planColor,
                                onPressed: () {
                                  controller.buy(product);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _freePlanCard() {
    const planColor = Color(0xFF4CAF50);

    const features = [
      'Basic profile',
      'Maximum 3 photos',
      'Appears below paid listings',
      'No badge',
      'Limited to 1 service category',

    ];

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
            color: planColor,
            child: const Text(
              'Free Plan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '\$0.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: planColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: features.map((feature) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check,
                                  size: 17,
                                  color: planColor,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    height: 36,
                    text: 'Choose Free',
                    backgroundColor: planColor,
                    onPressed: () async {
                      final freePlan = controller.freePlan.value;

                      if (freePlan == null) {
                        Get.snackbar(
                          'Error',
                          'Free plan information was not found',
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }

                      // Backend may return _id, id, or planId.
                      final String planId =
                          freePlan['_id']?.toString().trim() ??
                              freePlan['id']?.toString().trim() ??
                              freePlan['planId']?.toString().trim() ??
                              '';

                      final String planName =
                          freePlan['title']?.toString().trim() ??
                              freePlan['name']?.toString().trim() ??
                              'Free Plan';

                      final double planPrice =
                          (freePlan['price'] as num?)?.toDouble() ??
                              double.tryParse(
                                freePlan['price']?.toString() ?? '',
                              ) ??
                              0.0;

                      final bool isValidPlanId =
                      RegExp(r'^[a-fA-F0-9]{24}$')
                          .hasMatch(planId);

                      if (!isValidPlanId) {
                        Get.snackbar(
                          'Error',
                          'A valid free plan ID was not found',
                          snackPosition: SnackPosition.TOP,
                        );

                        debugPrint(
                          'INVALID FREE PLAN DATA => $freePlan',
                        );
                        debugPrint(
                          'INVALID FREE PLAN ID => $planId',
                        );

                        return;
                      }

                      // Important: save the real backend MongoDB plan ID.
                      final StorageService storage =
                      StorageService();

                      await storage.setPlanId(planId);

                      debugPrint(
                        'FREE PLAN ID SAVED => ${storage.planId}',
                      );

                      Get.toNamed(
                        AppRoutes.SERVICE_PROVIDER_ACCOUNT,
                        arguments: {
                          'planId': planId,
                          'planName': planName,
                          'name': planName,
                          'price': planPrice,
                          'rawPrice': planPrice,
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}