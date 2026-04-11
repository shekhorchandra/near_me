import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../services/contants/api_constants.dart';

class ForgetAuthService {
  /// Send OTP to email
  static Future<void> forgetPassword(String email) async {
    final encodedEmail = Uri.encodeComponent(email);

    final url = Uri.parse(
      "${ApiConstants.forgetPassword}$encodedEmail",
    );

    print("URL: $url");

    final response = await http.get(url);

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return;
    } else {
      throw Exception(data["message"] ?? "Failed to send OTP");
    }
  }
}

class OtpAuthService {
  static Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}/api/v1/auth/verify-otp",
    );

    print("REQUEST URL: $url");
    print("EMAIL: $email");
    print("OTP: $otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data["data"];
    } else {
      throw Exception(data["message"]);
    }
  }
}

