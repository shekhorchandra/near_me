import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:near_me/App/modules/auth/user/login/bindings/user_login_binding.dart';
import 'package:near_me/App/modules/auth/user/login/views/user_login_view.dart';
import 'package:near_me/App/modules/auth/user/signup/bindings/user_signup_binding.dart';
import 'package:near_me/App/modules/auth/user/signup/views/user_signup_view.dart';
import 'package:near_me/App/modules/common/onboarding/bindings/onboarding_binding.dart';
import 'package:near_me/App/modules/common/onboarding/views/onboarding_view.dart';
import 'package:near_me/App/modules/common/splash/bindings/splash_binding.dart';
import 'package:near_me/App/modules/common/splash/views/splash_view.dart';

import '../modules/auth/forget/forget_password/bindings/forgot_binding.dart';
import '../modules/auth/forget/forget_password/controllers/forgot_controller.dart';
import '../modules/auth/forget/forget_password/views/forgot_view.dart';
import '../modules/auth/forget/otp_verification/bindings/otp_binding.dart';
import '../modules/auth/forget/otp_verification/views/otp_verification_view.dart';
import '../modules/auth/forget/reset_password/bindings/reset_password_binding.dart';
import '../modules/auth/forget/reset_password/views/reset_password_view.dart';
import '../modules/auth/user/user_verify/bindings/verify_account_binding.dart';
import '../modules/auth/user/user_verify/views/verify_account_view.dart';
import '../modules/user/bottom_nav_bar/bindings/user_navigation_bar_binding.dart';
import '../modules/user/bottom_nav_bar/views/bottom_nav_view.dart';
import '../modules/user/menu/about_us/views/About_View.dart';
import '../modules/user/menu/change_password/bindings/change_password_binding.dart';
import '../modules/user/menu/change_password/views/change_password_view.dart';
import '../modules/user/menu/contact_us/contact_view/contact_us_view.dart';
import '../modules/user/menu/help_support/help_support_view/Help_Support_View.dart';
import '../modules/user/menu/menu_bar/bindings/menu_binding.dart';
import '../modules/user/menu/menu_bar/views/menu_view.dart';
import '../modules/user/menu/privacy_policy/privacy_policy_view/Privacy_Policy_View.dart';
import '../modules/user/menu/terms_condition/terms_condition_view/Terms_Condition_View.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    /// Splash Screen
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashView(), binding: SplashBinding()),

    /// Onboarding all pages
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),

    /// User Part login
    GetPage(
      name: AppRoutes.USER_LOGIN,
      page: () => const UserLoginView(),
      binding: UserLoginBinding(),
    ),

    /// User Part SIGNUP
    GetPage(
      name: AppRoutes.USER_SIGNUP,
      page: () => const UserSignupView(),
      binding: UserSignupBinding(),
    ),

    /// verify user account
    GetPage(
      name: AppRoutes.USER_VERIFY_ACCOUNT,
      page: () => const VerifyAccountView(),
      binding: VerifyAccountBinding(),
    ),

    /// verify Servicer account
    // GetPage(
    //   name: AppRoutes.SERVICER_VERIFY_ACCOUNT,
    //   page: () => const VerifyAccountView(),
    //   binding: VerifyAccountBinding(),
    // ),

    /// verify user forget password
    GetPage(
      name: '/user_forgot',
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(role: UserRole.user),
    ),

    /// verify servicer forget password
    GetPage(
      name: '/service_forgot',
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(role: UserRole.service),
    ),

    GetPage(
      name: AppRoutes.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpBinding(),
    ),

    // Reset Password Page (static for now)
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),

    /// User Bottom Nav Bar
    GetPage(
      name: AppRoutes.USER_BOTTOM_NAV,
      page: () => const UserNavigationBarPage(),
      binding: UserNavigationBinding(),
    ),

    GetPage(name: '/menu', page: () => const MenuView(), binding: MenuBinding()),

    GetPage(
      name: AppRoutes.ABOUT,
      page: () => const AboutView(),
    ),

    GetPage(
      name: AppRoutes.CONTACT_US,
      page: () => const ContactUsView(),
    ),

    GetPage(
      name: AppRoutes.HELP_SUPPORT,
      page: () => const HelpSupportView(),
    ),

    GetPage(
      name: AppRoutes.TERMS_CONDITION,
      page: () => const TermsConditionView(),
    ),

    GetPage(
      name: AppRoutes.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
    ),

    GetPage(
      name: AppRoutes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
  ];
}
