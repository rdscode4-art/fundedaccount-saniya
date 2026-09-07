import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_theme.dart';
import 'core/utils/app_logger.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    // Every widget-build error (a bad value reaching a widget, a null where
    // one slipped through, etc) gets logged with its full stack trace here
    // — check the debug console/DevTools "FundX" / "FlutterError" logs.
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      AppLogger.e('Flutter error: ${details.exceptionAsString()}',
          tag: 'FlutterError', error: details.exception, stackTrace: details.stack);
    };

    // In release builds, show a calm fallback instead of Flutter's raw red
    // error screen — real users should never see stack traces. Debug builds
    // keep the normal red screen since that's genuinely useful while coding.
    if (kReleaseMode) {
      ErrorWidget.builder = (details) => const _FriendlyErrorScreen();
    }

    runApp(const FundXApp());
  }, (error, stack) {
    // Catches anything that throws outside the Flutter widget tree
    // (async gaps, callbacks, etc) so it's never silently swallowed.
    AppLogger.e('Uncaught async error', tag: 'Zone', error: error, stackTrace: stack);
  });
}

class FundXApp extends StatelessWidget {
  const FundXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FundX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialBinding: InitialBinding(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}

class _FriendlyErrorScreen extends StatelessWidget {
  const _FriendlyErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.textTertiary, size: 36),
          const SizedBox(height: 12),
          const Text(
            'Something went wrong displaying this screen.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
