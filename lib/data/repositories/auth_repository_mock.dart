import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryMock implements AuthRepository {
  UserModel _user = UserModel(
    id: 'u1',
    name: 'John Trader',
    email: 'johntrader@gmail.com',
    isVerified: true,
    isKycVerified: true,
    twoFactorEnabled: true,
  );

  @override
  Future<UserModel> login({required String emailOrMobile, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _user;
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _user = UserModel(id: 'u1', name: name, email: email, isVerified: false);
    return _user;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
