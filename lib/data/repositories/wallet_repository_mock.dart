import '../models/transaction_model.dart';
import 'wallet_repository.dart';

class WalletRepositoryMock implements WalletRepository {
  @override
  Future<WalletModel> getWallet() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const WalletModel(
      balance: 2485.50,
      availableBalance: 2185.50,
      totalDeposited: 5000.00,
      totalPayout: 2000.00,
    );
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      TransactionModel(
        id: 't1',
        type: TransactionType.deposit,
        amount: 1000,
        date: '02 May 2024',
        status: TransactionStatus.success,
      ),
      TransactionModel(
        id: 't2',
        type: TransactionType.payout,
        amount: -500,
        date: '30 Apr 2024',
        status: TransactionStatus.success,
      ),
      TransactionModel(
        id: 't3',
        type: TransactionType.deposit,
        amount: 1000,
        date: '25 Apr 2024',
        status: TransactionStatus.success,
      ),
      TransactionModel(
        id: 't4',
        type: TransactionType.payout,
        amount: -500,
        date: '20 Apr 2024',
        status: TransactionStatus.success,
      ),
    ];
  }
}
