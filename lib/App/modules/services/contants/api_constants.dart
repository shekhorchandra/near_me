class ApiConstants {
  static const String baseUrl = "https://nonrudimentarily-holey-richard.ngrok-free.dev";

  // Define endpoints

  /// user register
  static const String user_register = "$baseUrl/api/v1/user/register";

  ///user login
  static const String user_login = "$baseUrl/api/v1/auth/login";

  ///user account verify
  static const String user_account_verify = "$baseUrl/api/v1/user/verify";

  /// user forget password
  static const String userforgetPassword = "$baseUrl/api/v1/auth/forget-password/";

  /// user forget password verify
  static const String userforgetPasswordverify = "$baseUrl/api/v1/auth/verify-otp";

  /// user forget password reset
  static const String userforgetPasswordreset = "$baseUrl/api/v1/auth/reset-password";

  ///user logout
  static const String user_logout = "$baseUrl/api/v1/auth/logout";
}
