import 'account_model.dart';

enum TransactionType { deposit, challengePurchase }

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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final typeValue = json['type']?.toString().toLowerCase() ?? 'deposit';
    final statusValue = json['status']?.toString().toLowerCase() ?? 'pending';

    return TransactionModel(
      id: json['id'].toString(),
      type: typeValue == 'challenge_purchase'
          ? TransactionType.challengePurchase
          : TransactionType.deposit,
      amount: _toDouble(json['amount']),
      date: json['createdAt']?.toString() ?? '',
      status: _parseStatus(statusValue),
    );
  }

  static TransactionStatus _parseStatus(String value) {
    switch (value) {
      case 'success':
      case 'completed':
        return TransactionStatus.success;

      case 'pending':
        return TransactionStatus.pending;

      case 'approved':
        return TransactionStatus.approved;

      case 'failed':
        return TransactionStatus.failed;

      default:
        return TransactionStatus.pending;
    }
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}

class WalletModel {
  final double balance;
  final double availableBalance;
  final double totalDeposited;
  final double totalPayout;
  final List<FundedAccountSummary> fundedAccounts;

  const WalletModel({
    required this.balance,
    required this.availableBalance,
    required this.totalDeposited,
    required this.totalPayout,
    this.fundedAccounts = const [],
  });

  factory WalletModel.fromJson(
    Map<String, dynamic> json, {
    List<dynamic>? fundedAccountsJson,
  }) {
    final rawAccounts = fundedAccountsJson ?? const [];

    return WalletModel(
      balance: _toDouble(json['balance']),
      availableBalance: _toDouble(json['availableBalance']),
      totalDeposited: _toDouble(json['totalDeposited']),
      totalPayout: _toDouble(json['totalPayout']),
      fundedAccounts: rawAccounts
          .map((a) => FundedAccountSummary.fromJson(
                Map<String, dynamic>.from(a),
              ))
          .toList(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}