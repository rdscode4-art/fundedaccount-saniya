import 'package:get/get.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/account_repository_http.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_http.dart';
import '../../data/repositories/trading_repository.dart';
import '../../data/repositories/trading_repository_http.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../data/repositories/wallet_repository_http.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Auth, Account & Trading are now wired to the real FundX backend.
    // Order matters: TradingRepositoryHttp looks up AccountRepository via
    // Get.find(), so Account must be registered first.
    Get.put<AuthRepository>(AuthRepositoryHttp(), permanent: true);
    Get.put<AccountRepository>(AccountRepositoryHttp(), permanent: true);
    Get.put<TradingRepository>(TradingRepositoryHttp(), permanent: true);

    // TODO: no wallet/payout endpoints exist on the backend yet.
    // WalletRepositoryHttp throws UnimplementedError until that API is built.
    Get.put<WalletRepository>(WalletRepositoryHttp(), permanent: true);
  }
}