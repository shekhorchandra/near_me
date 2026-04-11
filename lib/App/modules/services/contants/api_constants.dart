class ApiConstants {
  static const String baseUrl = "https://nonrudimentarily-holey-richard.ngrok-free.dev";

  // Define endpoints

  /// user register
  static const String user_register = "$baseUrl/api/v1/user/register";

  ///user login
  static const String user_login = "$baseUrl/api/v1/auth/login";

  ///user logout
  static const String user_logout = "$baseUrl/api/v1/auth/logout";

  /// forget password
  static const String forgetPassword = "$baseUrl/api/v1/auth/forget-password/";
}
