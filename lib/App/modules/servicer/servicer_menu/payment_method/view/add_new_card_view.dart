
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:near_me/App/modules/servicer/servicer_menu/payment_method/controller/payment_method_controller.dart';

import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_sizes.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class AddNewCardView extends StatelessWidget {
  const AddNewCardView({super.key});

  String _formatCardNumber(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentMethodController());

    controller.cvvFocus.addListener(() {
      if (controller.cvvFocus.hasFocus) {
        controller.isCvvFocused.value = true;
      } else {
        controller.isCvvFocused.value = false;
      }
    });

    return Scaffold(
      appBar: CommonAppBar(title: 'Add New Card'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Credit/Debit card
              Obx(
                () => CreditCardWidget(
                  cardNumber: controller.cardNumber.value,
                  expiryDate: controller.expiryDate.value,
                  cardHolderName: controller.cardHolderName.value,
                  cvvCode: controller.cvv.value,
                  isHolderNameVisible: true,
                  showBackView: controller.isCvvFocused.value,
                  onCreditCardWidgetChange: (CreditCardBrand brand) {},
                ),
              ),

              // Fields
              Text('Card Number', style: AppText.body1.semiBold),
              const SizedBox(height: 5),
              CustomTextField(
                hint: '0000 0000 0000 0000',
                keyboardType: .number,
                onChanged: (value) {
                  final formatted = _formatCardNumber(value);
                  controller.cardNumber.value = formatted;
                },
                suffix: Icon(Icons.credit_card_rounded),
              ),
              const SizedBox(height: 20),

              Text('Card Holder Name', style: AppText.body1.semiBold),
              const SizedBox(height: 5),
              CustomTextField(
                hint: 'John Doe',
                onChanged: (value) => controller.cardHolderName.value = value,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expiration Date', style: AppText.body1.semiBold),
                        const SizedBox(height: 5),
                        CustomTextField(
                          hint: 'MM/YY',
                          onChanged: (value) => controller.expiryDate.value = value,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CVV', style: AppText.body1.semiBold),
                        const SizedBox(height: 5),
                        CustomTextField(
                          hint: '123',
                          onChanged: (value) => controller.cvv.value = value,
                          focusNode: controller.cvvFocus,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(Icons.verified_rounded, color: AppColor.success),
                        const SizedBox(width: 5),
                        Text(
                          'Payments are securely enrypted with SSL',
                          maxLines: 2,
                          overflow: .ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              AppButton(text: 'Save Card', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
