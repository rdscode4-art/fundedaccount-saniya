import 'package:fundx_trading_app/core/network/api_client.dart';

import '../models/transaction_model.dart';
import 'wallet_repository.dart';

class WalletRepositoryHttp implements WalletRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<WalletModel> getWallet() async {
    final data = await _client.get(
      '/wallet',
      auth: true,
    );

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to load wallet');
    }

    final walletJson = data['wallet'];

    if (walletJson == null) {
      throw Exception('Wallet data not found');
    }

    final fundedAccountsJson = data['fundedAccounts'];

    return WalletModel.fromJson(
      Map<String, dynamic>.from(walletJson),
      fundedAccountsJson: fundedAccountsJson is List ? fundedAccountsJson : const [],
    );
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final data = await _client.get(
      '/wallet/transactions',
      auth: true,
    );

    if (data['success'] != true) {
      throw Exception(
        data['message'] ?? 'Failed to load transactions',
      );
    }

    final transactionsJson = data['transactions'];

    if (transactionsJson is! List) {
      return [];
    }

    return transactionsJson
        .map(
          (item) => TransactionModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  @override
  Future<WalletModel> deposit(double amount) async {
    final data = await _client.post(
      '/wallet/deposit',
      {
        'amount': amount,
      },
      auth: true,
    );

    if (data['success'] != true) {
      throw Exception(
        data['message'] ?? 'Failed to add funds',
      );
    }

    final walletJson = data['wallet'];

    if (walletJson == null) {
      throw Exception('Wallet data not found');
    }

    // Deposit response doesn't include fundedAccounts (deposit never
    // touches trading accounts) — WalletController reloads full wallet
    // right after this call to keep fundedAccounts in sync.
    return WalletModel.fromJson(
      Map<String, dynamic>.from(walletJson),
    );
  }
}