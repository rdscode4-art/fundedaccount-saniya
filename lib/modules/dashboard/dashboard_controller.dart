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
    final results = await Future.wait([
      _accountRepository.getActiveAccount(),
      _accountRepository.getOpenPositions(),
    ]);
    account.value = results[0] as AccountModel;
    positions.value = results[1] as List<PositionModel>;
    isLoading.value = false;
  }

  void goToDeposit() => Get.toNamed(Routes.wallet);
  void goToAccounts() => Get.toNamed(Routes.chooseAccount);
  void goToTrade() => Get.toNamed(Routes.tradeChart);
  void goToPositions() => Get.toNamed(Routes.history);
  void goToWallet() => Get.toNamed(Routes.wallet);
  void goToProfile() => Get.toNamed(Routes.profile);
}
