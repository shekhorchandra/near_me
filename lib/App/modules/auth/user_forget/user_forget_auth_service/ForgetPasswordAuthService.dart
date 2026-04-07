import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../services/contants/api_constants.dart';

class ForgetAuthService {
  /// Send OTP to email
  static Future<void> forgetPassword(String email) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.forgetPassword);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return; // success
    } else {
      throw Exception(data["message"] ?? "Failed to send OTP");
    }
  }
}
