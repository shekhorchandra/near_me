import 'package:dio/dio.dart';

class SubscriptionRepository {
  final Dio dio;

  SubscriptionRepository(this.dio);

  Future verifyPurchase({
    required String userId,
    required String productId,
    required String token,
  }) async {
    final response = await dio.post(
      "/subscription/verify",

      data: {
        "userId": userId,

        "productId": productId,

        "source": "google",

        "purchaseToken": token,

        "packageName": "com.app.near_me",

        "subscriptionId": productId,
      },
    );

    return response.data;
  }
}
