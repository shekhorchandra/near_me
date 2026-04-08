import 'package:http/http.dart' as http;
import '../../../data/services/storage_service.dart';


class ApiService {

  Map<String, String> get headers {
    final token = StorageService().accessToken;

    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
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