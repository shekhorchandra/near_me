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
