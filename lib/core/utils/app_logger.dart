import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Lightweight tagged logger. Everything is a no-op in release builds so
/// nothing sensitive (tokens, request bodies) ever ships to a real user's
/// console.
///
/// Use `AppLogger.api(...)` from the network layer and `AppLogger.e(...)`
/// from anywhere you catch an exception you want visible while debugging.
class AppLogger {
  AppLogger._();

  static void i(String message, {String tag = 'FundX'}) {
    if (!kDebugMode) return;
    developer.log(message, name: tag);
  }

  static void e(String message, {String tag = 'FundX', Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 1000, // SEVERE — makes real errors easy to spot/filter in the console
    );
  }

  /// One line per API call: method, path, status, and timing. Call once
  /// for the request and once for the response/error.
  static void api(String message) => i(message, tag: 'API');
}
