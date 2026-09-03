enum PositionSide { buy, sell }

class PositionModel {
  final String id;
  final String symbol;
  final PositionSide side;
  final double lots;
  final double entryPrice;
  final double currentPrice;
  final double pnl;
  final String openedAt;
  final bool isOpen;

  const PositionModel({
    required this.id,
    required this.symbol,
    required this.side,
    required this.lots,
    required this.entryPrice,
    required this.currentPrice,
    required this.pnl,
    required this.openedAt,
    this.isOpen = true,
  });
}
