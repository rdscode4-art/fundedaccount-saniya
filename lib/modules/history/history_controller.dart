import 'package:get/get.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../data/models/position_model.dart';
import '../../data/repositories/trading_repository.dart';

class HistoryController extends GetxController {
  final TradingRepository _tradingRepository = Get.find<TradingRepository>();

  final filters = const ['All', 'Open Positions', 'Closed Positions'];
  final selectedFilter = 'All'.obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final history = <PositionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      history.value = await _tradingRepository.getHistory(filter: selectedFilter.value);
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.error('History', e);
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    load();
  }
}
