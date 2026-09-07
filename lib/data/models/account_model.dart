class AccountModel {
  final String id;
  final String status; // Active, Passed, Failed
  final double fundedBalance;
  final double equity;
  final double freeMargin;
  final double profit;
  final double profitPercent;
  final double challengeTarget;
  final double challengeCurrent;
  final double dailyLossLimit;
  final double dailyLossUsed;
  final double maxDrawdown;
  final double maxDrawdownUsed;
  final int tradingDays;
  final String startedDate;

  const AccountModel({
    required this.id,
    required this.status,
    required this.fundedBalance,
    required this.equity,
    required this.freeMargin,
    required this.profit,
    required this.profitPercent,
    required this.challengeTarget,
    required this.challengeCurrent,
    required this.dailyLossLimit,
    required this.dailyLossUsed,
    required this.maxDrawdown,
    required this.maxDrawdownUsed,
    required this.tradingDays,
    required this.startedDate,
  });

  double get challengeProgress =>
      challengeTarget == 0 ? 0 : (challengeCurrent / challengeTarget).clamp(0, 1);

  double get remainingTarget => (challengeTarget - challengeCurrent).clamp(0, challengeTarget);
  double get remainingDailyLoss => (dailyLossLimit - dailyLossUsed).clamp(0, dailyLossLimit);
  double get remainingDrawdown => (maxDrawdown - maxDrawdownUsed).clamp(0, maxDrawdown);

  /// Maps the response of `GET /api/accounts/active`:
  /// `{ id, status, balance, equity, freeMargin, profit, profitPercent,
  ///    challenge: { target, current }, risk: { dailyLossLimit, dailyLossUsed,
  ///    maxDrawdown, maxDrawdownUsed }, tradingDays, startedDate, plan: {...} }`
  ///
  /// Note: `risk.dailyLossLimit`/`maxDrawdown` come back from the backend as
  /// **percentages** of the funded balance (that's how `funded_plans` stores
  /// them), while `dailyLossUsed`/`maxDrawdownUsed` are also percentages once
  /// `updateAccountMetrics` has run at least once. Double-check any screen
  /// copy that assumes "$" rather than "%" for these two fields.
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final challenge = (json['challenge'] as Map?)?.cast<String, dynamic>() ?? const {};
    final risk = (json['risk'] as Map?)?.cast<String, dynamic>() ?? const {};

    return AccountModel(
      id: json['id'].toString(),
      status: json['status']?.toString() ?? 'Active',
      fundedBalance: _num(json['balance']),
      equity: _num(json['equity']),
      freeMargin: _num(json['freeMargin']),
      profit: _num(json['profit']),
      profitPercent: _num(json['profitPercent']),
      challengeTarget: _num(challenge['target']),
      challengeCurrent: _num(challenge['current']),
      dailyLossLimit: _num(risk['dailyLossLimit']),
      dailyLossUsed: _num(risk['dailyLossUsed']),
      maxDrawdown: _num(risk['maxDrawdown']),
      maxDrawdownUsed: _num(risk['maxDrawdownUsed']),
      tradingDays: json['tradingDays'] is int
          ? json['tradingDays'] as int
          : int.tryParse(json['tradingDays']?.toString() ?? '') ?? 0,
      startedDate: json['startedDate']?.toString() ?? '',
    );
  }
}

double _num(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

class FundedPlanModel {
  final String id;
  final double accountSize;
  final double price;
  final double profitTarget;
  final double dailyLoss;
  final double maxDrawdown;

  const FundedPlanModel({
    required this.id,
    required this.accountSize,
    required this.price,
    required this.profitTarget,
    required this.dailyLoss,
    required this.maxDrawdown,
  });

  /// Maps a raw row from `GET /api/accounts/plans` (snake_case, straight
  /// from Postgres): `{ id, account_size, price, profit_target,
  /// daily_loss_limit, max_drawdown }`.
  factory FundedPlanModel.fromJson(Map<String, dynamic> json) {
    return FundedPlanModel(
      id: json['id'].toString(),
      accountSize: _num(json['account_size']),
      price: _num(json['price']),
      profitTarget: _num(json['profit_target']),
      dailyLoss: _num(json['daily_loss_limit']),
      maxDrawdown: _num(json['max_drawdown']),
    );
  }
}

/// A trading (funded) account as summarized inside the Wallet screen.
/// Maps one entry from `GET /api/wallet` → `fundedAccounts[]`:
/// `{ id, planId, accountSize, fundedBalance, equity, profit, status }`.
///
/// This is intentionally separate from wallet cash — see FundX business
/// rule: funded trading capital is NOT wallet money.
class FundedAccountSummary {
  final String id;
  final String planId;
  final double accountSize;
  final double fundedBalance;
  final double equity;
  final double profit;
  final String status;

  const FundedAccountSummary({
    required this.id,
    required this.planId,
    required this.accountSize,
    required this.fundedBalance,
    required this.equity,
    required this.profit,
    required this.status,
  });

  factory FundedAccountSummary.fromJson(Map<String, dynamic> json) {
    return FundedAccountSummary(
      id: json['id'].toString(),
      planId: json['planId'].toString(),
      accountSize: _num(json['accountSize']),
      fundedBalance: _num(json['fundedBalance']),
      equity: _num(json['equity']),
      profit: _num(json['profit']),
      status: json['status']?.toString() ?? 'Active',
    );
  }
}