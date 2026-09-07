import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_snackbar.dart';
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
  final errorMessage = RxnString();
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
    errorMessage.value = null;
    try {
      candles.value = await _tradingRepository.getCandles(symbol: symbol.value, timeframe: timeframe.value);
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.error('Chart', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPositions() async {
    try {
      positions.value = await _accountRepository.getOpenPositions();
    } catch (e) {
      AppSnackbar.error('Positions', e);
    }
  }

  Future<void> closePosition(String positionId) async {
    try {
      await _tradingRepository.closePosition(positionId);
      await loadPositions();
      AppSnackbar.success('Position Closed', 'The position was closed successfully.');
    } catch (e) {
      AppSnackbar.error('Close Failed', e);
    }
  }

  void setTimeframe(String tf) {
    timeframe.value = tf;
    loadChart();
  }

  void goToNewOrder() => Get.toNamed(Routes.newOrder);
}
