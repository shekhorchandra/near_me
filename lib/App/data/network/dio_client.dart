import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../modules/services/contants/api_constants.dart';
import '../../routes/app_routes.dart';
import '../services/storage_service.dart';

class DioClient {
  final StorageService _storageService = Get.find<StorageService>();
  late final Dio _dio;

  bool _isRefreshing = false;

  Dio get client => _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );

    // Pretty logger
    _dio.interceptors.add(
      PrettyDioLogger(requestBody: true, responseBody: true, error: true, compact: true),
      // PrettyDioLogger(),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Accept"] = "application/json";

          final token = _storageService.accessToken;

          debugPrint("========= DIO REQUEST =========");
          debugPrint("PATH: ${options.path}");
          debugPrint("TOKEN: $token");

          if (!_isAuthEndpoint(options.path) &&
              token != null &&
              token.isNotEmpty) {

            // If your backend expects Bearer, keep this.
            options.headers["Authorization"] = "Bearer $token";

            // If your backend expects raw JWT instead,
            // comment the line above and use this:
            // options.headers["Authorization"] = token;
          }

          debugPrint("HEADERS => ${options.headers}");

          handler.next(options);
        },

        onError: (DioException error, handler) async {
          final requestOptions = error.requestOptions;

          // Show 400 messages directly
          if (error.response?.statusCode == 400) {
            Get.snackbar(
              'Error',
              error.response?.data?['message'] ?? 'Something went wrong',
            );
          } else if (error.response?.statusCode == 403) {
            Get.snackbar(
              'Error',
              error.response?.data?['message'] ?? 'Something went wrong',
            );
          }

          // Unauthorized / token expired
          final isUnauthorized =
              error.response?.statusCode == 401 ||
              error.response?.statusCode == 403 ||
              (error.response?.data is Map && error.response?.data['message'] == "jwt expired");

          // Prevent infinite loops
          final alreadyRetried = requestOptions.extra['retried'] == true;

          // ✅ Key fix: Do NOT retry FormData
          final isMultipart = requestOptions.data is FormData;

          if (isUnauthorized &&
              !alreadyRetried &&
              !_isAuthEndpoint(requestOptions.path) &&
              !isMultipart) {
            requestOptions.extra['retried'] = true;

            if (!_isRefreshing) {
              _isRefreshing = true;
              final newToken = await refreshToken();
              _isRefreshing = false;

              if (newToken != null) {
                final response = await _retry(requestOptions);
                return handler.resolve(response);
              } else {
                _handleLogout();
              }
            } else {
              // wait a bit and retry
              await Future.delayed(const Duration(milliseconds: 500));
              final response = await _retry(requestOptions);
              return handler.resolve(response);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  bool _isAuthEndpoint(String path) {
    return path.contains("/login") ||
        path.contains("/refresh-token") ||
        path.contains("/register") ||
        path.contains("/forgot-password") ||
        path.contains("/verify-otp");
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = _storageService.accessToken;

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        "Authorization": "Bearer $token",
      },
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: requestOptions.extra,
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<String?> refreshToken() async {
    log('Refreshing token...');

    try {
      final refreshToken = _storageService.refreshToken;
      if (refreshToken == null) return null;

      final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final newAccessToken = data['newAccessToken'];
        final newRefreshToken = data['newRefreshToken'];
        await _storageService.setAccessToken(newAccessToken);
        await _storageService.setRefreshToken(newRefreshToken);

        log('Saved new refresh token.');

        return newAccessToken;
      }
    } catch (e) {
      _handleLogout();
    }

    return null;
  }

  Future<void> _handleLogout() async {
    try {
      // Optional: Clear FCM token on backend if your backend expects this.
      await _dio.patch(
        ApiConstants.update_fcm,
        data: {
          "fcmToken": "",
        },
      );
    } catch (e) {
      log("Failed to clear FCM token: $e");
    }

    await _storageService.clear();

    Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);
  }
}
