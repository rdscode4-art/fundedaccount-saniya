import '../../core/network/api_client.dart';
import '../../core/network/session_store.dart';
import '../models/account_model.dart';
import '../models/position_model.dart';
import 'account_repository.dart';

class AccountRepositoryHttp implements AccountRepository {
  final ApiClient _client = ApiClient();

  // Memoizes the in-flight "fetch active account" call so that if
  // getActiveAccount() and getOpenPositions() happen to run at the same time
  // (e.g. Future.wait on the dashboard), we don't fire the request twice.
  Future<AccountModel>? _activeAccountFuture;

  Future<AccountModel> _fetchActiveAccount() {
    _activeAccountFuture ??= () async {
      final data = await _client.get('/accounts/active', auth: true);
      final account = AccountModel.fromJson(
        (data['account'] as Map?)?.cast<String, dynamic>() ?? data,
      );
      SessionStore.activeAccountId = account.id;
      return account;
    }();
    return _activeAccountFuture!;
  }

  @override
  Future<AccountModel> getActiveAccount() async {
    // Force a fresh fetch (clear the memoized future) so pull-to-refresh /
    // screen re-entry always shows the latest balance & risk numbers.
    _activeAccountFuture = null;
    return _fetchActiveAccount();
  }

  @override
  Future<List<FundedPlanModel>> getFundedPlans() async {
    final data = await _client.get('/accounts/plans');
    final list = (data['plans'] as List?) ?? const [];
    return list
        .map((e) => FundedPlanModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<List<PositionModel>> getOpenPositions() async {
    final accountId = SessionStore.activeAccountId ?? (await _fetchActiveAccount()).id;
    final data = await _client.get('/accounts/$accountId/positions', auth: true);
    final list = (data['positions'] as List?) ?? const [];
    return list
        .map((e) => PositionModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<AccountModel> createAccount(String planId) async {
    final data = await _client.post(
      '/accounts',
      {'planId': int.tryParse(planId) ?? planId},
      auth: true,
    );
    final account = AccountModel.fromJson(
      (data['account'] as Map?)?.cast<String, dynamic>() ?? data,
    );
    SessionStore.activeAccountId = account.id;
    // Prime the memoized "active account" cache with what we just created,
    // so an immediate getActiveAccount() call (e.g. on the Account Details
    // screen right after) doesn't need a second round trip.
    _activeAccountFuture = Future.value(account);
    return account;
  }
}
