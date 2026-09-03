import 'package:get/get.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/account_repository_mock.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_http.dart';
import '../../data/repositories/trading_repository.dart';
import '../../data/repositories/trading_repository_mock.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../data/repositories/wallet_repository_mock.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(AuthRepositoryHttp(), permanent: true);
    Get.put<AccountRepository>(AccountRepositoryMock(), permanent: true);
    Get.put<TradingRepository>(TradingRepositoryMock(), permanent: true);
    Get.put<WalletRepository>(WalletRepositoryMock(), permanent: true);
  }
}