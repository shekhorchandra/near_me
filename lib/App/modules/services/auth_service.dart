import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'contants/api_constants.dart';


class AuthService {
  final box = GetStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.user_login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      final user = data["data"]["user"];

      await box.write("accessToken", data["data"]["accessToken"]);
      await box.write("refreshToken", data["data"]["refreshToken"]);
      await box.write("user", user);
      await box.write("role", user["role"]);
    }

    return {
      "statusCode": response.statusCode,
      "data": data,
    };
  }
}