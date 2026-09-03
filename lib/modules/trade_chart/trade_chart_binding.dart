import 'package:get/get.dart';
import 'trade_chart_controller.dart';

class TradeChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TradeChartController());
  }
}
