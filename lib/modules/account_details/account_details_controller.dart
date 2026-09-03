import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/account_model.dart';
import '../../data/repositories/account_repository.dart';

class AccountDetailsController extends GetxController {
  final AccountRepository _accountRepository = Get.find<AccountRepository>();

  final isLoading = true.obs;
  final Rx<AccountModel?> account = Rx<AccountModel?>(null);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    account.value = await _accountRepository.getActiveAccount();
    isLoading.value = false;
  }

  void goToTrade() => Get.offAllNamed(Routes.tradeChart);
}
