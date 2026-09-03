import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/trading_repository.dart';

class NewOrderController extends GetxController {
  final TradingRepository _tradingRepository = Get.find<TradingRepository>();

  final symbol = 'EUR/USD'.obs;
  final side = OrderSide.buy.obs;
  final lotSize = 0.10.obs;
  final riskPercent = 1.00.obs;
  final entryPrice = 1.08745.obs;
  final stopLoss = 1.08300.obs;
  final takeProfit = 1.09500.obs;
  final isPlacingOrder = false.obs;

  void selectSide(OrderSide s) => side.value = s;

  void adjustLot(double delta) => lotSize.value = _RoundExt(
    ((lotSize.value + delta).clamp(0.01, 100)).toDouble(),
  ).toPrecision(2);
  void adjustRisk(double delta) => riskPercent.value = _RoundExt(
    ((riskPercent.value + delta).clamp(0.1, 10)).toDouble(),
  ).toPrecision(2);
  void adjustEntry(double delta) => entryPrice.value = _RoundExt(
    ((entryPrice.value + delta).clamp(0, 999999)).toDouble(),
  ).toPrecision(5);
  void adjustStopLoss(double delta) => stopLoss.value = _RoundExt(
    ((stopLoss.value + delta).clamp(0, 999999)).toDouble(),
  ).toPrecision(5);
  void adjustTakeProfit(double delta) => takeProfit.value = _RoundExt(
    ((takeProfit.value + delta).clamp(0, 999999)).toDouble(),
  ).toPrecision(5);

  OrderRequestModel get _request => OrderRequestModel(
    symbol: symbol.value,
    side: side.value,
    lotSize: lotSize.value,
    riskPercent: riskPercent.value,
    entryPrice: entryPrice.value,
    stopLoss: stopLoss.value,
    takeProfit: takeProfit.value,
  );

  double get riskReward => _request.riskRewardRatio;
  double get estimatedPnl => _request.estimatedPnl;

  Future<void> placeOrder() async {
    isPlacingOrder.value = true;
    try {
      await _tradingRepository.placeOrder(_request);
      Get.back();
      Get.snackbar(
        'Order Placed',
        '${side.value.name.toUpperCase()} order for $symbol submitted',
      );
    } finally {
      isPlacingOrder.value = false;
    }
  }
}

extension _RoundExt on double {
  double toPrecision(int digits) {
    double factor = 1;
    for (int i = 0; i < digits; i++) {
      factor *= 10;
    }
    return (this * factor).round() / factor;
  }
}
