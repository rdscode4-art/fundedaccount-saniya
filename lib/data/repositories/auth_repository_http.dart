import 'package:fundx_trading_app/core/network/api_client.dart';
import 'package:fundx_trading_app/data/models/user_model.dart';
import 'package:fundx_trading_app/data/repositories/auth_repository.dart';

class AuthRepositoryHttp implements AuthRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<UserModel> login({required String emailOrMobile, required String password}) async {
    final data = await _client.post('/auth/login', {
      'email': emailOrMobile,
      'password': password,
    });
    await _client.saveToken(data['token']);
    return UserModel.fromJson(data['user']);
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    final data = await _client.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    await _client.saveToken(data['token']);
    return UserModel.fromJson(data['user']);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final data = await _client.get('/auth/me', auth: true);
    return UserModel.fromJson(data['user'] ?? data);
  }

  @override
  Future<void> logout() async {
    await _client.clearToken();
  }
}