import '../models/account_model.dart';
import '../models/position_model.dart';

abstract class AccountRepository {
  Future<AccountModel> getActiveAccount();
  Future<List<FundedPlanModel>> getFundedPlans();
  Future<List<PositionModel>> getOpenPositions();
}
