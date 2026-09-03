import 'package:get/get.dart';
import '../../data/models/position_model.dart';
import '../../data/repositories/trading_repository.dart';

class HistoryController extends GetxController {
  final TradingRepository _tradingRepository = Get.find<TradingRepository>();

  final filters = const ['All', 'Open Positions', 'Closed Positions'];
  final selectedFilter = 'All'.obs;
  final isLoading = true.obs;
  final history = <PositionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    history.value = await _tradingRepository.getHistory(filter: selectedFilter.value);
    isLoading.value = false;
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    load();
  }
}
