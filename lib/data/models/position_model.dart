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

  /// Maps the camelCase JSON returned by both `GET /api/accounts/:id/positions`
  /// and `GET /api/trading/history`:
  /// `{ id, symbol, side: "Buy"|"Sell", lots, entryPrice, currentPrice, pnl,
  ///    openedAt, closedAt?, isOpen }`
  factory PositionModel.fromJson(Map<String, dynamic> json) {
    double num_(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    final sideStr = (json['side'] ?? '').toString().toLowerCase();
    final isOpenRaw = json['isOpen'];

    return PositionModel(
      id: json['id'].toString(),
      symbol: json['symbol']?.toString() ?? '',
      side: sideStr == 'sell' ? PositionSide.sell : PositionSide.buy,
      lots: num_(json['lots']),
      entryPrice: num_(json['entryPrice']),
      currentPrice: num_(json['currentPrice']),
      pnl: num_(json['pnl']),
      openedAt: json['openedAt']?.toString() ?? '',
      // The open-positions endpoint always returns open positions and
      // doesn't send `isOpen` at all, so default to true when it's missing.
      isOpen: isOpenRaw is bool ? isOpenRaw : (isOpenRaw?.toString() != 'false'),
    );
  }
}
