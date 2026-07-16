import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../modules/services/contants/api_constants.dart';

import 'storage_service.dart';

class AuthApiService {
  final StorageService _storageService = Get.find<StorageService>();

  late final Dio _dio;

  Dio get client => _dio;

  AuthApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
        responseType: ResponseType.json,
        contentType: 'application/json',
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Accept"] = "application/json";
          options.headers["Content-Type"] = "application/json";

          final token = _storageService.accessToken;

          if (token != null && token.trim().isNotEmpty) {
            options.headers["Authorization"] = "Bearer ${token.trim()}";
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) {
          log("❌ AUTH API ERROR => ${error.response?.statusCode}");
          log("❌ AUTH API DATA => ${error.response?.data}");

          return handler.next(error);
        },
      ),
    );
  }

  Future<Response?> googleAuthentication({
    required String idToken,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.googleAuthentication,
        data: {"id_token": idToken, "role": role},
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log("=========== GOOGLE AUTH RESPONSE ===========");
      log(response.data.toString());
      log("===========================================");

      return response;
    } on DioException catch (e) {
      log("❌ GOOGLE AUTH DIO ERROR => ${e.response?.data ?? e.message}");
      return e.response;
    } catch (e) {
      log("❌ GOOGLE AUTH ERROR => $e");
      return null;
    }
  }
}
