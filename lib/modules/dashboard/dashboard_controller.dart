import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/account_model.dart';
import '../../data/models/position_model.dart';
import '../../data/repositories/account_repository.dart';

class DashboardController extends GetxController {
  final AccountRepository _accountRepository = Get.find<AccountRepository>();

  final isLoading = true.obs;
  final Rx<AccountModel?> account = Rx<AccountModel?>(null);
  final positions = <PositionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      // Fetch the account first (not with Future.wait) — getOpenPositions()
      // needs the account id that this call resolves/caches, and a brand
      // new user won't have an account yet at all.
      account.value = await _accountRepository.getActiveAccount();
      positions.value = await _accountRepository.getOpenPositions();
    } catch (e) {
      // Most likely: no funded account exists yet for this user. Send them
      // to pick a plan instead of showing a broken dashboard.
      isLoading.value = false;
      Get.offAllNamed(Routes.chooseAccount);
      return;
    }
    isLoading.value = false;
  }

  void goToDeposit() => Get.toNamed(Routes.wallet);
  void goToAccounts() => Get.toNamed(Routes.chooseAccount);
  void goToTrade() => Get.toNamed(Routes.tradeChart);
  void goToPositions() => Get.toNamed(Routes.history);
  void goToWallet() => Get.toNamed(Routes.wallet);
  void goToProfile() => Get.toNamed(Routes.profile);
}
