import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/network/api_client.dart';
import '../../data/models/account_model.dart';
import '../../data/models/position_model.dart';
import '../../data/repositories/account_repository.dart';

class DashboardController extends GetxController {
  final AccountRepository _accountRepository = Get.find<AccountRepository>();

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final Rx<AccountModel?> account = Rx<AccountModel?>(null);
  final positions = <PositionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // Fetch the account first (not with Future.wait) — getOpenPositions()
      // needs the account id that this call resolves/caches, and a brand
      // new user won't have an account yet at all.
      account.value = await _accountRepository.getActiveAccount();
      positions.value = await _accountRepository.getOpenPositions();
    } on ApiException catch (e) {
      if (e.isNotFound) {
        // No funded account exists yet for this user — send them to pick
        // a plan instead of showing a broken dashboard.
        Get.offAllNamed(Routes.chooseAccount);
        return;
      }
      // A real failure (server down, no internet, etc) — show it and let
      // the person retry, instead of silently bouncing them somewhere else.
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Something went wrong loading your dashboard.';
    } finally {
      isLoading.value = false;
    }
  }

  void goToDeposit() => Get.toNamed(Routes.wallet);
  void goToAccounts() => Get.toNamed(Routes.chooseAccount);
  void goToTrade() => Get.toNamed(Routes.tradeChart);
  void goToPositions() => Get.toNamed(Routes.history);
  void goToProfile() => Get.toNamed(Routes.profile);
}
