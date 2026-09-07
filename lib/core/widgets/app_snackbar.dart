import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';

/// One consistent look for every toast in the app: colored left accent +
/// icon that matches the message type, dark surface to match the theme,
/// and short auto-dismiss timing. Use these instead of calling
/// `Get.snackbar` directly so every screen feels the same.
class AppSnackbar {
  AppSnackbar._();

  static void success(String title, String message) => _show(
        title: title,
        message: message,
        color: AppColors.success,
        icon: Icons.check_circle_rounded,
      );

  static void error(String title, Object error) => _show(
        title: title,
        message: _cleanMessage(error),
        color: AppColors.danger,
        icon: Icons.error_rounded,
        duration: const Duration(seconds: 4),
      );

  static void info(String title, String message) => _show(
        title: title,
        message: message,
        color: AppColors.primary,
        icon: Icons.info_rounded,
      );

  static void warning(String title, String message) => _show(
        title: title,
        message: message,
        color: AppColors.warning,
        icon: Icons.warning_rounded,
      );

  static String _cleanMessage(Object error) {
    final text = error.toString();
    // Covers both the old bare `Exception(...)` and any stray toString()
    // that still leaks the Dart type prefix.
    return text.replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  static void _show({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Close any snackbar still animating out first — calling Get.snackbar
    // twice in quick succession (e.g. a fast failed-then-retried request)
    // can otherwise throw inside the overlay.
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surfaceLighter,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      duration: duration,
      icon: Icon(icon, color: color),
      leftBarIndicatorColor: color,
      boxShadows: [
        BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6)),
      ],
      titleText: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
      messageText: Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
    );
  }
}
