import '../models/candle_model.dart';
import '../models/order_model.dart';
import '../models/position_model.dart';

abstract class TradingRepository {
  Future<List<CandleModel>> getCandles({required String symbol, required String timeframe});
  Future<void> placeOrder(OrderRequestModel order);
  Future<List<PositionModel>> getHistory({String filter = 'All'});
}
