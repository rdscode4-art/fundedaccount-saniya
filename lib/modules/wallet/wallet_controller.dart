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

    try {
      final results = await Future.wait([
        _walletRepository.getWallet(),
        _walletRepository.getTransactions(),
      ]);

      wallet.value = results[0] as WalletModel;
      transactions.value = results[1] as List<TransactionModel>;
    } catch (e) {
      Get.snackbar(
        'Wallet',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deposit(double amount) async {
    try {
      isLoading.value = true;

      // Add funds, then do a full reload so `wallet.fundedAccounts`
      // stays correct (the deposit response itself doesn't include it).
      await _walletRepository.deposit(amount);

      final results = await Future.wait([
        _walletRepository.getWallet(),
        _walletRepository.getTransactions(),
      ]);

      wallet.value = results[0] as WalletModel;
      transactions.value = results[1] as List<TransactionModel>;

      Get.snackbar(
        'Funds Added',
        '\$${amount.toStringAsFixed(2)} added to your wallet.',
      );
    } catch (e) {
      Get.snackbar(
        'Deposit Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }
}