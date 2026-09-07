import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/network/session_store.dart';
import '../models/candle_model.dart';
import '../models/order_model.dart';
import '../models/position_model.dart';
import 'account_repository.dart';
import 'trading_repository.dart';

class TradingRepositoryHttp implements TradingRepository {
  final ApiClient _client = ApiClient();

  // Needed to resolve the active account id when nothing has cached it yet
  // (e.g. user deep-links straight into Trade+Chart). Make sure
  // AccountRepository is registered in InitialBinding before this one.
  AccountRepository get _accountRepository => Get.find<AccountRepository>();

  Future<String> _accountId() async {
    if (SessionStore.activeAccountId != null) return SessionStore.activeAccountId!;
    final account = await _accountRepository.getActiveAccount();
    return account.id;
  }

  /// UI timeframes ('1m','5m','15m','1H','4H','1D') -> Twelve Data / backend
  /// timeframes ('1min','5min','15min','1h','4h','1day').
  String _mapTimeframe(String tf) {
    switch (tf) {
      case '1m':
        return '1min';
      case '5m':
        return '5min';
      case '15m':
        return '15min';
      case '30m':
        return '30min';
      case '1H':
        return '1h';
      case '4H':
        return '4h';
      case '1D':
        return '1day';
      default:
        return '15min';
    }
  }

  /// UI filters ('All','Open Positions','Closed Positions') -> backend
  /// filters ('All','Open','Closed').
  String _mapFilter(String filter) {
    switch (filter) {
      case 'Open Positions':
        return 'Open';
      case 'Closed Positions':
        return 'Closed';
      default:
        return 'All';
    }
  }

  @override
  Future<List<CandleModel>> getCandles({required String symbol, required String timeframe}) async {
    final data = await _client.get(
      '/trading/candles',
      auth: true,
      query: {
        'symbol': symbol,
        'timeframe': _mapTimeframe(timeframe),
        'limit': 100,
      },
    );
    final list = (data['candles'] as List?) ?? const [];
    return list
        .map((e) => CandleModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<void> placeOrder(OrderRequestModel order) async {
    final accountId = await _accountId();
    await _client.post('/trading/orders', order.toJson(accountId: accountId), auth: true);
  }

  @override
  Future<void> closePosition(String positionId) async {
    await _client.patch('/trading/positions/$positionId/close', {}, auth: true);
  }

  @override
  Future<List<PositionModel>> getHistory({String filter = 'All'}) async {
    final accountId = await _accountId();
    final data = await _client.get(
      '/trading/history',
      auth: true,
      query: {
        'accountId': accountId,
        'filter': _mapFilter(filter),
      },
    );
    final list = (data['trades'] as List?) ?? const [];
    return list
        .map((e) => PositionModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }
}
