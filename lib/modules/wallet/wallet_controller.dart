import 'package:get/get.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/wallet_repository.dart';

class WalletController extends GetxController {
  final WalletRepository _walletRepository = Get.find<WalletRepository>();

  final isLoading = true.obs;
  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final results = await Future.wait([
      _walletRepository.getWallet(),
      _walletRepository.getTransactions(),
    ]);
    wallet.value = results[0] as WalletModel;
    transactions.value = results[1] as List<TransactionModel>;
    isLoading.value = false;
  }
}
