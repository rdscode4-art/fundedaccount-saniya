import 'dart:math';
import '../models/candle_model.dart';
import '../models/order_model.dart';
import '../models/position_model.dart';
import 'trading_repository.dart';

class TradingRepositoryMock implements TradingRepository {
  @override
  Future<List<CandleModel>> getCandles({required String symbol, required String timeframe}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final rand = Random(symbol.hashCode);
    double price = 1.08400;
    final candles = <CandleModel>[];
    final now = DateTime.now();
    for (int i = 40; i >= 0; i--) {
      final open = price;
      final change = (rand.nextDouble() - 0.48) * 0.0025;
      final close = open + change;
      final high = max(open, close) + rand.nextDouble() * 0.0008;
      final low = min(open, close) - rand.nextDouble() * 0.0008;
      candles.add(CandleModel(
        time: now.subtract(Duration(minutes: i * 15)),
        open: open,
        high: high,
        low: low,
        close: close,
      ));
      price = close;
    }
    return candles;
  }

  @override
  Future<void> placeOrder(OrderRequestModel order) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<List<PositionModel>> getHistory({String filter = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final all = const [
      PositionModel(id: 'h1', symbol: 'EUR/USD', side: PositionSide.buy, lots: 1.00, entryPrice: 1.08745, currentPrice: 1.08745, pnl: 24.50, openedAt: '02 May 2024 10:45', isOpen: true),
      PositionModel(id: 'h2', symbol: 'XAU/USD', side: PositionSide.sell, lots: 2310.50, entryPrice: 2310.50, currentPrice: 2308.10, pnl: -48.00, openedAt: '02 May 2024 09:30', isOpen: false),
      PositionModel(id: 'h3', symbol: 'GBP/USD', side: PositionSide.buy, lots: 1.30, entryPrice: 1.25560, currentPrice: 1.25560, pnl: 26.00, openedAt: '01 May 2024 16:20', isOpen: false),
      PositionModel(id: 'h4', symbol: 'USD/JPY', side: PositionSide.sell, lots: 1.50, entryPrice: 153.800, currentPrice: 153.800, pnl: 26.00, openedAt: '01 May 2024 11:10', isOpen: false),
      PositionModel(id: 'h5', symbol: 'AUD/USD', side: PositionSide.buy, lots: 0.65, entryPrice: 0.65900, currentPrice: 0.65900, pnl: 15.00, openedAt: '30 Apr 2024 15:45', isOpen: false),
    ];
    if (filter == 'Open Positions') return all.where((e) => e.isOpen).toList();
    if (filter == 'Closed Positions') return all.where((e) => !e.isOpen).toList();
    return all;
  }
}
