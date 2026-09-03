import '../models/account_model.dart';
import '../models/position_model.dart';
import 'account_repository.dart';

class AccountRepositoryMock implements AccountRepository {
  @override
  Future<AccountModel> getActiveAccount() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AccountModel(
      id: 'FX10245',
      status: 'Active',
      fundedBalance: 100000.00,
      equity: 102485.50,
      freeMargin: 96240.35,
      profit: 2485.50,
      profitPercent: 2.48,
      challengeTarget: 10000,
      challengeCurrent: 6200,
      dailyLossLimit: 5000,
      dailyLossUsed: 350,
      maxDrawdown: 10000,
      maxDrawdownUsed: 1200,
      tradingDays: 12,
      startedDate: '02 May 2024',
    );
  }

  @override
  Future<List<FundedPlanModel>> getFundedPlans() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      FundedPlanModel(id: 'p10k', accountSize: 10000, price: 99, profitTarget: 1000, dailyLoss: 500, maxDrawdown: 1000),
      FundedPlanModel(id: 'p25k', accountSize: 25000, price: 199, profitTarget: 2500, dailyLoss: 1250, maxDrawdown: 2500),
      FundedPlanModel(id: 'p50k', accountSize: 50000, price: 299, profitTarget: 5000, dailyLoss: 2500, maxDrawdown: 5000),
      FundedPlanModel(id: 'p100k', accountSize: 100000, price: 499, profitTarget: 10000, dailyLoss: 5000, maxDrawdown: 10000),
    ];
  }

  @override
  Future<List<PositionModel>> getOpenPositions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      PositionModel(
        id: 'pos1', symbol: 'EUR/USD', side: PositionSide.buy, lots: 1.00,
        entryPrice: 1.08745, currentPrice: 1.08990, pnl: 245.20, openedAt: '02 May 2024 10:45',
      ),
      PositionModel(
        id: 'pos2', symbol: 'XAU/USD', side: PositionSide.sell, lots: 0.50,
        entryPrice: 2310.50, currentPrice: 2308.10, pnl: -82.50, openedAt: '02 May 2024 09:30',
      ),
    ];
  }
}
