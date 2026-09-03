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
}
