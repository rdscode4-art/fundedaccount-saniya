enum OrderSide { buy, sell }

class OrderRequestModel {
  final String symbol;
  final OrderSide side;
  final double lotSize;
  final double riskPercent;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit;

  const OrderRequestModel({
    required this.symbol,
    required this.side,
    required this.lotSize,
    required this.riskPercent,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
  });

  double get riskRewardRatio {
    final risk = (entryPrice - stopLoss).abs();
    final reward = (takeProfit - entryPrice).abs();
    if (risk == 0) return 0;
    return reward / risk;
  }

  double get estimatedPnl {
    final reward = (takeProfit - entryPrice).abs();
    return reward * lotSize * 1000; // simplified simulation
  }

  /// The backend only accepts the exact strings "Buy" / "Sell".
  String get sideApiValue => side == OrderSide.buy ? 'Buy' : 'Sell';

  /// Builds the body for `POST /api/trading/orders`.
  Map<String, dynamic> toJson({required String accountId}) => {
        'accountId': int.tryParse(accountId) ?? accountId,
        'symbol': symbol,
        'side': sideApiValue,
        'lotSize': lotSize,
        'riskPercent': riskPercent,
        'entryPrice': entryPrice,
        'stopLoss': stopLoss,
        'takeProfit': takeProfit,
      };
}
