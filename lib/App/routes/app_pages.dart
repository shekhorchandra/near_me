import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:near_me/App/modules/auth/user/login/bindings/user_login_binding.dart';
import 'package:near_me/App/modules/auth/user/login/views/user_login_view.dart';
import 'package:near_me/App/modules/auth/user/signup/bindings/user_signup_binding.dart';
import 'package:near_me/App/modules/auth/user/signup/views/user_signup_view.dart';
import 'package:near_me/App/modules/common/onboarding/bindings/onboarding_binding.dart';
import 'package:near_me/App/modules/common/onboarding/views/onboarding_view.dart';
import 'package:near_me/App/modules/common/splash/bindings/splash_binding.dart';
import 'package:near_me/App/modules/common/splash/views/splash_view.dart';

import '../modules/auth/user/user_verify/bindings/user_verify_account_binding.dart';
import '../modules/auth/user/user_verify/views/user_verify_account_view.dart';
import '../modules/auth/user_forget/forget_password/bindings/forgot_binding.dart';
import '../modules/auth/user_forget/forget_password/controllers/forgot_controller.dart';
import '../modules/auth/user_forget/forget_password/views/forgot_view.dart';
import '../modules/auth/user_forget/otp_verification/bindings/otp_binding.dart';
import '../modules/auth/user_forget/otp_verification/views/otp_verification_view.dart';
import '../modules/auth/user_forget/reset_password/bindings/reset_password_binding.dart';
import '../modules/auth/user_forget/reset_password/views/reset_password_view.dart';
import '../modules/user/User_bottom_nav_bar/bindings/user_navigation_bar_binding.dart';
import '../modules/user/User_bottom_nav_bar/views/bottom_nav_view.dart';

import '../modules/user/category/user_category_details/bindings/user_category_details_binding.dart';
import '../modules/user/category/user_category_details/views/user_category_details_view.dart';
import '../modules/user/category/user_category_serivce_review/bindings/reviews_binding.dart';
import '../modules/user/category/user_category_serivce_review/views/reviews_view.dart';
import '../modules/user/category/user_category_service_details/bindings/ServiceDetailsBinding.dart';
import '../modules/user/category/user_category_service_details/views/ServiceDetailsView.dart';
import '../modules/user/chat/user_chat_conversation/bindings/conversation_binding.dart';
import '../modules/user/chat/user_chat_conversation/views/conversation_view.dart';
import '../modules/user/home/bindings/home_binding.dart';
import '../modules/user/home/views/home_view.dart';
import '../modules/user/menu/about_us/views/About_View.dart';
import '../modules/user/menu/change_password/bindings/change_password_binding.dart';
import '../modules/user/menu/change_password/views/change_password_view.dart';
import '../modules/user/menu/contact_us/contact_view/contact_us_view.dart';
import '../modules/user/menu/help_support/help_support_view/Help_Support_View.dart';
import '../modules/user/menu/privacy_policy/privacy_policy_view/Privacy_Policy_View.dart';
import '../modules/user/menu/terms_condition/terms_condition_view/Terms_Condition_View.dart';
import '../modules/user/menu/user_menu_bar/bindings/menu_binding.dart';
import '../modules/user/menu/user_menu_bar/views/menu_view.dart';
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
      page: () => const UserVerifyAccountView(),
      binding: UserVerifyAccountBinding(),
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
      page: () => const UserForgotPasswordView(),
      binding: UserForgotPasswordBinding(role: UserRole.user),
    ),

    /// verify servicer forget password
    // GetPage(
    //   name: '/service_forgot',
    //   page: () => const ForgotPasswordView(),
    //   binding: ForgotPasswordBinding(role: UserRole.service),
    // ),

    /// User forget password otp verification
    GetPage(
      name: AppRoutes.OTP_VERIFICATION,
      page: () => const UserOtpVerificationView(),
      binding: UserOtpBinding(),
    ),

    /// User Reset Password Page
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const UserResetPasswordView(),
      binding: UserResetPasswordBinding(),
    ),

    /// User Bottom Nav Bar
    GetPage(
      name: AppRoutes.USER_BOTTOM_NAV,
      page: () => const UserNavigationBarPage(),
      binding: UserNavigationBinding(),
    ),

    /// User Home page
    GetPage(name: AppRoutes.HOME, page: () => const HomeView(), binding: HomeBinding()),

    // User Category Details page
    GetPage(
      name: AppRoutes.USER_CATEGORY_DETAILS,
      page: () => const UserCategoryDetailsView(),
      binding: UserCategoryDetailsBinding(),
    ),

    // Service Details page
    GetPage(
      name: AppRoutes.SERVICE_DETAILS,
      page: () => const ServiceDetailsView(),
      binding: ServiceDetailsBinding(),
    ),

    /// service review
    GetPage(
      name: AppRoutes.REVIEWS,
      page: () => const ReviewsView(),
      binding: ReviewsBinding(),
    ),

    ///user chat conversion
    GetPage(
      name: AppRoutes.CONVERSATION,
      page: () => const ConversationView(),
      binding: ConversationBinding(),
    ),


    /// User menu page
    GetPage(name: '/menu', page: () => const MenuView(), binding: MenuBinding()),
    GetPage(name: AppRoutes.ABOUT, page: () => const AboutView()),
    GetPage(name: AppRoutes.CONTACT_US, page: () => const ContactUsView()),
    GetPage(name: AppRoutes.HELP_SUPPORT, page: () => const HelpSupportView()),
    GetPage(name: AppRoutes.TERMS_CONDITION, page: () => const TermsConditionView()),
    GetPage(name: AppRoutes.PRIVACY_POLICY, page: () => const PrivacyPolicyView()),
    GetPage(
      name: AppRoutes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),

    ///
  ];
}
