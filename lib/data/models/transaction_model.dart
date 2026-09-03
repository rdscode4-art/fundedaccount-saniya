enum TransactionType { deposit, payout }

enum TransactionStatus { success, pending, approved, failed }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String date;
  final TransactionStatus status;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class WalletModel {
  final double balance;
  final double availableBalance;
  final double totalDeposited;
  final double totalPayout;

  const WalletModel({
    required this.balance,
    required this.availableBalance,
    required this.totalDeposited,
    required this.totalPayout,
  });
}
