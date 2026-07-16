import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionProductModel {

  final String id;
  final String title;
  final String description;
  final String price;


  SubscriptionProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });


  factory SubscriptionProductModel.fromProductDetails(
      ProductDetails product) {

    return SubscriptionProductModel(
      id: product.id,
      title: product.title,
      description: product.description,
      price: product.price,
    );
  }

}