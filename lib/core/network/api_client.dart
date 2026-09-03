import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
   static const String baseUrl = 'http://192.168.1.25:5000/api';

  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {bool auth = false}) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  Future<Map<String, dynamic>> get(String path, {bool auth = false}) async {
    final res = await http.get(Uri.parse('$baseUrl$path'), headers: await _headers(auth: auth));
    return _handle(res);
  }

  Map<String, dynamic> _handle(http.Response res) {
    final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : {};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded as Map<String, dynamic>;
    }
    final message = decoded is Map && decoded['message'] != null
        ? decoded['message'].toString()
        : 'Something went wrong (${res.statusCode})';
    throw Exception(message);
  }
}