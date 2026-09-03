import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/account_model.dart';
import '../../data/repositories/account_repository.dart';

class ChooseAccountController extends GetxController {
  final AccountRepository _accountRepository = Get.find<AccountRepository>();

  final isLoading = true.obs;
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

  void selectPlan(FundedPlanModel plan) => Get.toNamed(Routes.accountDetails);
}
