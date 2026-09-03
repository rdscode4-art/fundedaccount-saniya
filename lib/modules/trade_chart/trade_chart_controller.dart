import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/candle_model.dart';
import '../../data/models/position_model.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/trading_repository.dart';

class TradeChartController extends GetxController {
  final TradingRepository _tradingRepository = Get.find<TradingRepository>();
  final AccountRepository _accountRepository = Get.find<AccountRepository>();

  final symbol = 'EUR/USD'.obs;
  final timeframe = '15m'.obs;
  final isLoading = true.obs;
  final candles = <CandleModel>[].obs;
  final positions = <PositionModel>[].obs;

  final timeframes = const ['1m', '5m', '15m', '1H', '4H', '1D'];

  @override
  void onInit() {
    super.onInit();
    loadChart();
    loadPositions();
  }

  double get currentPrice => candles.isEmpty ? 0 : candles.last.close;
  double get high => candles.isEmpty ? 0 : candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
  double get low => candles.isEmpty ? 0 : candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
  double get change => candles.length < 2 ? 0 : candles.last.close - candles.first.open;
  double get changePercent => candles.isEmpty || candles.first.open == 0
      ? 0
      : (change / candles.first.open) * 100;

  Future<void> loadChart() async {
    isLoading.value = true;
    candles.value = await _tradingRepository.getCandles(symbol: symbol.value, timeframe: timeframe.value);
    isLoading.value = false;
  }

  Future<void> loadPositions() async {
    positions.value = await _accountRepository.getOpenPositions();
  }

  void setTimeframe(String tf) {
    timeframe.value = tf;
    loadChart();
  }

  void goToNewOrder() => Get.toNamed(Routes.newOrder);
}
