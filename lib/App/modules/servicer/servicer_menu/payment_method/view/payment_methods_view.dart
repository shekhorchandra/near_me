
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/modules/servicer/servicer_menu/payment_method/view/widgets/payment_method_tile.dart';

import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_sizes.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../data/mock_data/mock_payment_method.dart';
import '../../../../../routes/app_routes.dart';
import '../controller/payment_method_controller.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key, this.isSelectable = false});

  final bool? isSelectable;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentMethodController());

    return Scaffold(
      appBar: CommonAppBar(title: 'Payment Methods'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          children: [
            // Payment methods list
            Obx(() {
              final selected = controller.selectedPaymentMethod.value;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockPaymentMethod.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      PaymentMethodTile(
                        paymentMethod: mockPaymentMethod[index],
                        isSelectable: isSelectable ?? false,
                        isSelected: selected == index,
                        onSelect: () => controller.selectedPaymentMethod.value = index,
                      ),

                      const SizedBox(height: 10),
                    ],
                  );
                },
              );
            }),

            // Add new card
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => Get.toNamed(AppRoutes.ADD_PAYMENT_METHOD),
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(100),
                  dashPattern: [15, 5],
                  strokeWidth: 2,
                  padding: EdgeInsets.all(20),
                  color: Colors.black,
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_rounded, color: Colors.black),
                    const SizedBox(width: 5),
                    Text(
                      'Add new card',
                      style: AppText.body2.medium.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.denseButtonHeight,
          vertical: AppSizes.denseButtonHeight,
        ),
        child: isSelectable ?? false
            ? AppButton(
                text: 'Publish Deal',
                onPressed: () {
                  if (controller.selectedPaymentMethod == -1) {
                    Get.snackbar(
                      'Error',
                      'Please select a payment method!',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: AppColor.error,
                      colorText:Colors.white,
                      margin: const EdgeInsets.all(15),
                    );
                  }
                },
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
