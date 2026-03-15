abstract class AppRoutes {
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';

  /// User login and signup
  static const USER_LOGIN = '/user-login';
  static const USER_SIGNUP = '/user-signup';

  /// user verify account
  static const USER_VERIFY_ACCOUNT = '/verify-user-account';

  /// user forget password
  static const USER_FORGOT_PASSWORD = '/user-forgot-password';

  /// user forget password otp
  static const USER_OTP_VERIFICATION = '/user_otp_verification';
  static const USER_RESET_PASSWORD = '/user_reset_password';

  /// user bottom nav bar
  static const USER_BOTTOM_NAV = '/navigation_bar';

  /// bottom nav bar home page
  static const HOME = '/home';

  /// user category nav bar details
  static const USER_CATEGORY_DETAILS = '/user-category-details';

  /// Service Details page
  static const SERVICE_DETAILS = '/user-service-details';

  /// SERVICE REVIEW
  static const REVIEWS = '/reviews';

  ///user chat conversion
  static const CONVERSATION = '/conversation';

  /// user menu nav bar
  static const CHANGE_PASSWORD = '/change-password';
  static const ABOUT = '/about';
  static const CONTACT_US = '/contact-us';
  static const HELP_SUPPORT = '/help-support';
  static const TERMS_CONDITION = '/terms-condition';
  static const PRIVACY_POLICY = '/privacy-policy';

  /////////////// SERVICER ////////////////////////
  // Servicer login and sign up part
  static const SERVICER_LOGIN = '/servicer-login';
  static const SERVICER_SIGNUP = '/servicer-signup';
  // service verify account
  static const SERVICER_VERIFY_ACCOUNT = '/verify-servicer-account';
  // servicer forget password
  static const SERVICER_FORGOT_PASSWORD = '/servicer-forgot-password';
  /// servicer forget password otp
  static const SERVICER_OTP_VERIFICATION = '/servicer_otp_verification';
  static const SERVICER_RESET_PASSWORD = '/servicer_reset_password';
}
