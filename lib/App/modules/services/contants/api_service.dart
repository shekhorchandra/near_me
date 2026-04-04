import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiService {
  final box = GetStorage();

  Map<String, String> get headers {
    final token = box.read("accessToken");

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<http.Response> getRequest(String url) {
    return http.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> postRequest(String url, dynamic body) {
    return http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
  }
}