import 'package:get/get.dart';

import 'app_routes.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/otp_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/profile_setup/profile_setup_binding.dart';
import '../modules/profile_setup/personal_details_view.dart';
import '../modules/profile_setup/email_verification_view.dart';
import '../modules/profile_setup/pan_verification_view.dart';
import '../modules/loan/loan_binding.dart';
import '../modules/loan/loan_calculator_view.dart';
import '../modules/loan/loan_offer_view.dart';
import '../modules/loan/loan_status_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profileSetup,
      page: () => const PersonalDetailsView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => const EmailVerificationView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.panVerification,
      page: () => const PanVerificationView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.loanCalculator,
      page: () => const LoanCalculatorView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.loanOffer,
      page: () => const LoanOfferView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.loanStatus,
      page: () => const LoanStatusView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
