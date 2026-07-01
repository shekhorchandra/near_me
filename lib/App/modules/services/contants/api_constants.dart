class ApiConstants {
  // static const String baseUrl = "https://gastrotomic-squirrelly-yuonne.ngrok-free.dev";
  static const String baseUrl = "https://uncried-unpreventible-declan.ngrok-free.dev";
  // static const String baseUrl = "https://gastrotomic-squirrelly-yuonne.ngrok-free.dev";
  // static const String baseUrl = "https://nearme-q02y.onrender.com";

  /////////////////////////////// Define endpoints ////////////////////////////////////////////////////

  /// user register
  static const String user_register = "$baseUrl/api/v1/user/register";

  ///user login
  static const String user_login = "$baseUrl/api/v1/auth/login";

  /// get me
  static const String user_me = "$baseUrl/api/v1/user/me";

  /// user profile update
  static const String user_info = "$baseUrl/api/v1/user/info";

  /// user account verify
  static const String user_account_verify = "$baseUrl/api/v1/user/verify";

  /// user forget password
  static const String userforgetPassword = "$baseUrl/api/v1/auth/forget-password/";

  /// user forget password verify
  static const String userforgetPasswordverify = "$baseUrl/api/v1/auth/verify-otp";

  /// user forget password reset
  static const String userforgetPasswordreset = "$baseUrl/api/v1/auth/reset-password";

  /// user logout
  static const String user_logout = "$baseUrl/api/v1/auth/logout";

  /// nearest service
  static const String nearestService = "$baseUrl/api/v1/service/nearest";

  /// PLANS
  static const String getPlans = "$baseUrl/api/v1/plans";

  /// Get all category
  static const String categoryTree = "$baseUrl/api/v1/category/tree";

  /// Service Create
  static const String createService = "$baseUrl/api/v1/service/create";

  /// Service account verify
  static const String userAccountVerify = "$baseUrl/api/v1/user/verify";

  /// Service create highlights
  static const String highlightServiceBase = "$baseUrl/api/v1/highlight-service";

  static String serviceHighlight(String serviceId) => "$baseUrl/api/v1/highlight-service/service/$serviceId";

  static String highlightService(String id) => "$baseUrl/api/v1/highlight-service/$id";

  static String serviceById(String id) => "$baseUrl/api/v1/service/$id";

  static const String googleAuthentication = "/api/v1/auth/google/authentication";
}
