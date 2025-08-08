import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/reset_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/event/views/event_view.dart';
import '../modules/detection/views/detection_view.dart';
import '../modules/dance/views/dance_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/security_settings_view.dart';
import '../modules/profile/views/privacy_policy_view.dart';
import '../modules/profile/views/faq_view.dart';
import '../modules/home/views/news_detail_view.dart';
import '../modules/dance/bindings/dance_binding.dart';
import '../modules/profile/views/login_history_view.dart';
import '../modules/detection/views/detection_history_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.OTP_VERIFICATION,
      page: () => OtpVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: Routes.EVENT,
          page: () => const EventView(),
        ),
        GetPage(
          name: Routes.DETECTION,
          page: () => const DetectionView(),
        ),
        GetPage(
          name: Routes.DANCE,
          page: () => const DanceView(),
          binding: DanceBinding(),
        ),
        GetPage(
          name: Routes.PROFILE,
          page: () => const ProfileView(),
        ),
      ],
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: Routes.SECURITY_SETTINGS,
      page: () => const SecuritySettingsView(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
    ),
    GetPage(
      name: Routes.FAQ,
      page: () => const FaqView(),
    ),
    GetPage(
      name: Routes.NEWS_DETAIL,
      page: () => NewsDetailView(article: Get.arguments),
    ),
    GetPage(
      name: Routes.LOGIN_HISTORY,
      page: () => const LoginHistoryView(),
    ),
    GetPage(
      name: Routes.DETECTION_HISTORY,
      page: () => const DetectionHistoryView(),
    ),
  ];
}
