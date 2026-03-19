import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:near_me/App/modules/auth/user/login/bindings/user_login_binding.dart';
import 'package:near_me/App/modules/auth/user/login/views/user_login_view.dart';
import 'package:near_me/App/modules/auth/user/signup/bindings/user_signup_binding.dart';
import 'package:near_me/App/modules/auth/user/signup/views/user_signup_view.dart';
import 'package:near_me/App/modules/common/onboarding/bindings/onboarding_binding.dart';
import 'package:near_me/App/modules/common/onboarding/views/onboarding_view.dart';
import 'package:near_me/App/modules/common/splash/bindings/splash_binding.dart';
import 'package:near_me/App/modules/common/splash/views/splash_view.dart';
import '../core/enums/user_role.dart';
import '../modules/auth/service/login/bindings/servicer_login_binding.dart';
import '../modules/auth/service/login/views/servicer_login_view.dart';
import '../modules/auth/service/servicer_plan/binding/choose_plan_binding.dart';
import '../modules/auth/service/servicer_plan/views/choose_plan_view.dart';
import '../modules/auth/service/servicer_verify/bindings/servicer_verify_account_binding.dart';
import '../modules/auth/service/servicer_verify/views/servicer_verify_account_view.dart';
import '../modules/auth/service/signup/bindings/servicer_signup_binding.dart';
import '../modules/auth/service/signup/views/servicer_signup_view.dart';
import '../modules/auth/service_forget/service_otp_verification/bindings/servicer_otp_binding.dart';
import '../modules/auth/service_forget/service_otp_verification/views/servicer_otp_verification_view.dart';
import '../modules/auth/service_forget/service_reset_password/bindings/servicer_reset_password_binding.dart';
import '../modules/auth/service_forget/service_reset_password/views/servicer_reset_password_view.dart';
import '../modules/auth/service_forget/servicer_forget_password/bindings/servicer_forgot_binding.dart';
import '../modules/auth/service_forget/servicer_forget_password/views/servicer_forgot_view.dart';
import '../modules/auth/user/user_verify/bindings/user_verify_account_binding.dart';
import '../modules/auth/user/user_verify/views/user_verify_account_view.dart';
import '../modules/auth/user_forget/user_forget_password/bindings/user_forgot_binding.dart';
import '../modules/auth/user_forget/user_forget_password/views/user_forgot_view.dart';
import '../modules/auth/user_forget/user_otp_verification/bindings/user_otp_binding.dart';
import '../modules/auth/user_forget/user_otp_verification/views/user_otp_verification_view.dart';
import '../modules/auth/user_forget/user_reset_password/bindings/user_reset_password_binding.dart';
import '../modules/auth/user_forget/user_reset_password/views/user_reset_password_view.dart';
import '../modules/servicer/Servicer_bottom_nav_bar/bindings/servicer_navigation_bar_binding.dart';
import '../modules/servicer/Servicer_bottom_nav_bar/views/servicer_bottom_nav_view.dart';
import '../modules/servicer/servicer_chat/servicer_chat_conversation/bindings/servicer_conversation_binding.dart';
import '../modules/servicer/servicer_chat/servicer_chat_conversation/views/servicer_conversation_view.dart';
import '../modules/servicer/servicer_chat/servicer_inbox/bindings/servicer_chat_binding.dart';
import '../modules/servicer/servicer_chat/servicer_inbox/views/servicer_chat_view.dart';
import '../modules/servicer/servicer_dashboard/bindings/servicer_dashboard_binding.dart';
import '../modules/servicer/servicer_dashboard/views/servicer_dashboard_view.dart';
import '../modules/servicer/servicer_highlight/servicer_highlight_details/binding/service_highlights_details_binding.dart';
import '../modules/servicer/servicer_highlight/servicer_highlight_details/views/service_highlights_details_page.dart';
import '../modules/servicer/servicer_highlight/servicer_highlights_page/binding/servicer_highlight_binding.dart';
import '../modules/servicer/servicer_highlight/servicer_highlights_page/views/servicer_highlight_view.dart';
import '../modules/servicer/servicer_menu/payment_method/bindings/payment_method_binding.dart';
import '../modules/servicer/servicer_menu/payment_method/view/add_new_card_view.dart';
import '../modules/servicer/servicer_menu/payment_method/view/payment_methods_view.dart';
import '../modules/servicer/servicer_menu/servicer_about_us/views/About_View.dart';
import '../modules/servicer/servicer_menu/servicer_change_password/bindings/servicer_change_password_binding.dart';
import '../modules/servicer/servicer_menu/servicer_change_password/views/servicer_change_password_view.dart';
import '../modules/servicer/servicer_menu/servicer_contact_us/contact_view/contact_us_view.dart';
import '../modules/servicer/servicer_menu/servicer_help_support/help_support_view/Help_Support_View.dart';
import '../modules/servicer/servicer_menu/servicer_menu_bar/bindings/servicer_menu_binding.dart';
import '../modules/servicer/servicer_menu/servicer_menu_bar/views/servicer_menu_view.dart';
import '../modules/servicer/servicer_menu/servicer_privacy_policy/privacy_policy_view/Privacy_Policy_View.dart';
import '../modules/servicer/servicer_menu/servicer_terms_condition/terms_condition_view/Terms_Condition_View.dart';
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

    /// verify user forget password
    GetPage(
      name: '/user_forgot',
      page: () => const UserForgotPasswordView(),
      binding: UserForgotPasswordBinding(role: UserRole.user),
    ),

    /// User forget password otp verification
    GetPage(
      name: AppRoutes.USER_OTP_VERIFICATION,
      page: () => const UserOtpVerificationView(),
      binding: UserOtpBinding(),
    ),

    /// User Reset Password Page
    GetPage(
      name: AppRoutes.USER_RESET_PASSWORD,
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

    /// user category Service Details page
    GetPage(
      name: AppRoutes.SERVICE_DETAILS,
      page: () => const ServiceDetailsView(),
      binding: ServiceDetailsBinding(),
    ),

    /// user category service review
    GetPage(name: AppRoutes.REVIEWS, page: () => const ReviewsView(), binding: ReviewsBinding()),

    ///user chat conversion
    GetPage(
      name: AppRoutes.CONVERSATION,
      page: () => const ConversationView(),
      binding: ConversationBinding(),
    ),

    /// User menu page
    GetPage(name: AppRoutes.USER_MENU, page: () => const MenuView(), binding: MenuBinding()),
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

    ///////////////////////////////////// SERVICER //////////////////////////////////////////////

    /// SERVICER Part login
    GetPage(
      name: AppRoutes.SERVICER_LOGIN,
      page: () => const ServicerLoginView(),
      binding: ServicerLoginBinding(),
    ),

    /// SERVICER Part SIGNUP
    GetPage(
      name: AppRoutes.SERVICER_SIGNUP,
      page: () => const ServicerSignupView(),
      binding: ServicerSignupBinding(),
    ),

    /// verify servicer account
    GetPage(
      name: AppRoutes.SERVICER_VERIFY_ACCOUNT,
      page: () => const ServicerVerifyAccountView(),
      binding: ServicerVerifyAccountBinding(),
    ),

    /// verify servicer forget password
    GetPage(
      name: AppRoutes.SERVICER_FORGOT_PASSWORD,
      page: () => const ServicerForgotPasswordView(),
      binding: ServicerForgotPasswordBinding(role: UserRole.service),
    ),

    /// Servicer forget password otp verification
    GetPage(
      name: AppRoutes.SERVICER_OTP_VERIFICATION,
      page: () => const ServicerOtpVerificationView(),
      binding: ServicerOtpBinding(),
    ),

    /// User Reset Password Page
    GetPage(
      name: AppRoutes.SERVICER_RESET_PASSWORD,
      page: () => const ServicerResetPasswordView(),
      binding: ServicerResetPasswordBinding(),
    ),

    /// Servicer Bottom Nav Bar
    GetPage(
      name: AppRoutes.SERVICER_BOTTOM_NAV,
      page: () => const ServicerNavigationBarPage(),
      binding: ServicerNavigationBinding(),
    ),

    /// Servicer Highlight
    GetPage(
      name: AppRoutes.SERVICER_HIGHLIGHT,
      page: () => const ServiceHighlightView(),
      binding: ServiceHighlightBinding(),
    ),

    /// Servicer Dashboard
    GetPage(
      name: AppRoutes.SERVICER_DASHBOARD,
      page: () => const ServiceDashboardView(),
      binding: ServiceDashboardBinding(),
    ),

    /// Servicer chat
    GetPage(
      name: AppRoutes.SERVICER_CHAT,
      page: () => const ServicerChatView(),
      binding: ServicerChatBinding(),
    ),

    /// Servicer Menu
    GetPage(
      name: AppRoutes.SERVICER_MENU,
      page: () => const ServicerMenuView(),
      binding: ServicerMenuBinding(),
    ),

    /// service change password
    GetPage(
      name: AppRoutes.SERVICER_CHANGE_PASSWORD,
      page: () => const ServicerChangePasswordView(),
      binding: ServicerChangePasswordBinding(),
    ),

    GetPage(name: AppRoutes.SERVICER_ABOUT, page: () => const ServicerAboutView()),
    GetPage(name: AppRoutes.SERVICER_CONTACT_US, page: () => const ServicerContactUsView()),
    GetPage(name: AppRoutes.SERVICER_HELP_SUPPORT, page: () => const ServicerHelpSupportView()),
    GetPage(name: AppRoutes.SERVICER_TERMS_CONDITION, page: () => const ServicerTermsConditionView()),
    GetPage(name: AppRoutes.SERVICER_PRIVACY_POLICY, page: () => const ServicerPrivacyPolicyView()),

    /// paymernt method
    GetPage(
          name: AppRoutes.ADD_PAYMENT_METHOD,
          page: () => AddNewCardView(),
          binding: PaymentMethodBinding(),
        ),

    GetPage(
      name: AppRoutes.PAYMENT_METHOD,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};

        return PaymentMethodsView(isSelectable: args['isSelectable'] as bool? ?? false);
      },
      binding: PaymentMethodBinding(),
    ),

    /// servicer chat conversion page
    GetPage(
      name: AppRoutes.SERVICER_CONVERSATION,
      page: () => const ServicerConversationView(),
      binding: ServicerConversationBinding(),
    ),

    /// service highlights details page
    GetPage(
      name: AppRoutes.SERVICE_HIGHLIGHTS_DETAILS,
      page: () => const ServiceHighlightsDetailsView(),
      binding: ServiceHightlightsDetailsBinding(),
    ),

    /// SERVICER CHOOSE PLAN
    GetPage(
      name: AppRoutes.SERVICE_CHOOSE_PLAN,
      page: () => const ChoosePlanView(),
      binding: ChoosePlanBinding(),
    ),

  ];
}
