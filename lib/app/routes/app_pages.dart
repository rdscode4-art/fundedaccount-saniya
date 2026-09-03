import 'package:get/get.dart';
import 'app_routes.dart';

import '../../modules/splash/splash_view.dart';
import '../../modules/splash/splash_binding.dart';
import '../../modules/onboarding/onboarding_view.dart';
import '../../modules/onboarding/onboarding_binding.dart';
import '../../modules/auth/login/login_view.dart';
import '../../modules/auth/login/login_binding.dart';
import '../../modules/auth/register/register_view.dart';
import '../../modules/auth/register/register_binding.dart';
import '../../modules/dashboard/dashboard_view.dart';
import '../../modules/dashboard/dashboard_binding.dart';
import '../../modules/choose_account/choose_account_view.dart';
import '../../modules/choose_account/choose_account_binding.dart';
import '../../modules/account_details/account_details_view.dart';
import '../../modules/account_details/account_details_binding.dart';
import '../../modules/trade_chart/trade_chart_view.dart';
import '../../modules/trade_chart/trade_chart_binding.dart';
import '../../modules/new_order/new_order_view.dart';
import '../../modules/new_order/new_order_binding.dart';
import '../../modules/wallet/wallet_view.dart';
import '../../modules/wallet/wallet_binding.dart';
import '../../modules/history/history_view.dart';
import '../../modules/history/history_binding.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/profile/profile_binding.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.chooseAccount,
      page: () => const ChooseAccountView(),
      binding: ChooseAccountBinding(),
    ),
    GetPage(
      name: Routes.accountDetails,
      page: () => const AccountDetailsView(),
      binding: AccountDetailsBinding(),
    ),
    GetPage(
      name: Routes.tradeChart,
      page: () => const TradeChartView(),
      binding: TradeChartBinding(),
    ),
    GetPage(
      name: Routes.newOrder,
      page: () => const NewOrderView(),
      binding: NewOrderBinding(),
    ),
    GetPage(
      name: Routes.wallet,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
