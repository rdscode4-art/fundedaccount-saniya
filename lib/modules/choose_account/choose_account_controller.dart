import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/account_model.dart';
import '../../data/repositories/account_repository.dart';

class ChooseAccountController extends GetxController {
  final AccountRepository _accountRepository = Get.find<AccountRepository>();

  final isLoading = true.obs;
  final isCreatingAccount = false.obs;
  final plans = <FundedPlanModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  Future<void> loadPlans() async {
    isLoading.value = true;
    plans.value = await _accountRepository.getFundedPlans();
    isLoading.value = false;
  }

  Future<void> selectPlan(FundedPlanModel plan) async {
    if (isCreatingAccount.value) return;
    isCreatingAccount.value = true;
    try {
      await _accountRepository.createAccount(plan.id);
      Get.toNamed(Routes.accountDetails);
    } catch (e) {
      Get.snackbar('Could not create account', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isCreatingAccount.value = false;
    }
  }
}
