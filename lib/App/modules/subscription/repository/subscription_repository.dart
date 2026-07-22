import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../data/network/dio_client.dart';
import '../../services/contants/api_constants.dart';

class SubscriptionRepository {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<dynamic> verifyPurchase({
    required String userId,
    required String productId,
    required String token,
  }) async {
    final body = {
      "userId": userId,
      "productId": productId,
      "source": "google",
      "purchaseToken": token,
      "packageName": "com.app.near_me",
      "subscriptionId": productId,
    };

    try {
      final response = await _dioClient.client.post(
        ApiConstants.verifypurchase,
        data: body,
      );

      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }
}