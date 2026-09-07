import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/app_logger.dart';

/// Every failed API call throws this instead of a bare [Exception], so UI
/// code can tell the difference between "server told us no" (has a
/// [statusCode]) and "request never reached the server" ([statusCode] is
/// null — timeout, no internet, DNS failure, etc).
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  /// True for "not found" style responses (e.g. no active funded account
  /// yet) — callers can use this to route somewhere useful instead of
  /// showing a scary error.
  bool get isNotFound => statusCode == 404;

  /// True when we couldn't reach the server at all (timeout, offline, DNS).
  bool get isNetworkError => statusCode == null;

  @override
  String toString() => message;
}

class ApiClient {
  // Physical Android device on the same Wi-Fi as your PC.
  // Update this if your PC's IPv4 address changes (run `ipconfig` to check).
  static const String baseUrl = 'http://192.168.1.25:5000/api';

  static const Duration _timeout = Duration(seconds: 15);

  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  /// True if a token is saved, i.e. the user was logged in last time the
  /// app ran. Doesn't guarantee the token is still valid server-side —
  /// callers should confirm with a real request (see SplashController).
  Future<bool> hasToken() async => (await getToken())?.isNotEmpty ?? false;

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {bool auth = false}) {
    return _run('POST', path, () async {
      final res = await http
          .post(Uri.parse('$baseUrl$path'), headers: await _headers(auth: auth), body: jsonEncode(body))
          .timeout(_timeout);
      return res;
    }, requestBody: body);
  }

  Future<Map<String, dynamic>> get(String path, {bool auth = false, Map<String, dynamic>? query}) {
    return _run('GET', path, () async {
      var uri = Uri.parse('$baseUrl$path');
      if (query != null && query.isNotEmpty) {
        uri = uri.replace(queryParameters: query.map((k, v) => MapEntry(k, v.toString())));
      }
      final res = await http.get(uri, headers: await _headers(auth: auth)).timeout(_timeout);
      return res;
    });
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body, {bool auth = false}) {
    return _run('PATCH', path, () async {
      final res = await http
          .patch(Uri.parse('$baseUrl$path'), headers: await _headers(auth: auth), body: jsonEncode(body))
          .timeout(_timeout);
      return res;
    }, requestBody: body);
  }

  /// Wraps every call with logging + a single place that turns network-level
  /// failures (timeout, no internet, DNS) into a friendly [ApiException]
  /// instead of letting a raw SocketException/TimeoutException reach the UI.
  Future<Map<String, dynamic>> _run(
    String method,
    String path,
    Future<http.Response> Function() send, {
    Map<String, dynamic>? requestBody,
  }) async {
    final stopwatch = Stopwatch()..start();
    AppLogger.api('→ $method $path${requestBody != null ? '  body=$requestBody' : ''}');
    try {
      final res = await send();
      stopwatch.stop();
      AppLogger.api('← $method $path  ${res.statusCode}  (${stopwatch.elapsedMilliseconds}ms)  ${res.body}');
      return _handle(res);
    } on TimeoutException {
      stopwatch.stop();
      AppLogger.e('✕ $method $path timed out after ${_timeout.inSeconds}s');
      throw const ApiException('The server is taking too long to respond. Please try again.');
    } on SocketException catch (e) {
      stopwatch.stop();
      AppLogger.e('✕ $method $path — no connection', error: e);
      throw const ApiException('Can\'t reach the server. Check your internet connection and try again.');
    } on http.ClientException catch (e) {
      stopwatch.stop();
      AppLogger.e('✕ $method $path — client error', error: e);
      throw const ApiException('Can\'t reach the server right now. Please try again.');
    } on FormatException catch (e) {
      stopwatch.stop();
      AppLogger.e('✕ $method $path — bad response format', error: e);
      throw const ApiException('Got an unexpected response from the server.');
    } on ApiException {
      rethrow;
    } catch (e, st) {
      stopwatch.stop();
      AppLogger.e('✕ $method $path — unexpected error', error: e, stackTrace: st);
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Map<String, dynamic> _handle(http.Response res) {
    final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : {};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded as Map<String, dynamic>;
    }
    final message = decoded is Map && decoded['message'] != null
        ? decoded['message'].toString()
        : 'Something went wrong (${res.statusCode})';
    throw ApiException(message, statusCode: res.statusCode);
  }
}