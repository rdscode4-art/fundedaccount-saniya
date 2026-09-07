import '../models/transaction_model.dart';

abstract class WalletRepository {
  Future<WalletModel> getWallet();
  Future<List<TransactionModel>> getTransactions();
  Future<WalletModel> deposit(double amount);
}
