import 'package:get/get.dart';
import '../../core/utils/app_logger.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/wallet_repository.dart';

class WalletController extends GetxController {
  final WalletRepository _walletRepository = Get.find<WalletRepository>();

  final isLoading = true.obs;
  // Deposit uses its own flag (not `isLoading`) so the Add Funds button can
  // show a small spinner without tearing down and rebuilding the whole
  // wallet page mid-request — that swap was what made the screen visibly
  // flash/break while a deposit was in flight.
  final isSubmittingDeposit = false.obs;
  final errorMessage = RxnString();
  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final results = await Future.wait([
        _walletRepository.getWallet(),
        _walletRepository.getTransactions(),
      ]);

      wallet.value = results[0] as WalletModel;
      transactions.value = results[1] as List<TransactionModel>;
    } catch (e) {
      AppLogger.e('Wallet load failed', tag: 'Wallet', error: e);
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deposit(double amount) async {
    if (isSubmittingDeposit.value) return;
    isSubmittingDeposit.value = true;

    try {
      // Add funds, then do a full reload so `wallet.fundedAccounts`
      // stays correct (the deposit response itself doesn't include it).
      await _walletRepository.deposit(amount);

      final results = await Future.wait([
        _walletRepository.getWallet(),
        _walletRepository.getTransactions(),
      ]);

      wallet.value = results[0] as WalletModel;
      transactions.value = results[1] as List<TransactionModel>;

      AppSnackbar.success('Funds Added', '\$${amount.toStringAsFixed(2)} added to your wallet.');
    } catch (e) {
      AppLogger.e('Deposit failed', tag: 'Wallet', error: e);
      AppSnackbar.error('Deposit Failed', e);
    } finally {
      isSubmittingDeposit.value = false;
    }
  }
}
