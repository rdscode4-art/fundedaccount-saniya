import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String emailOrMobile, required String password});
  Future<UserModel> register({required String name, required String email, required String password});
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}
