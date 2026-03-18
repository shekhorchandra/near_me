import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  PaymentMethodController();

  Rx<int> selectedPaymentMethod = (-1).obs;

  // Add new card
  final cardNumber = ''.obs;
  final expiryDate = ''.obs;
  final cardHolderName = ''.obs;
  final cvv = ''.obs;

  final cvvFocus = FocusNode();
  Rx<bool> isCvvFocused = false.obs;
}
