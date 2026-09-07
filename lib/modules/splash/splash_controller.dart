import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/app_logger.dart';
import '../../data/repositories/auth_repository.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;
  final _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    // Resolve where we're going while the progress bar plays, so a
    // returning user isn't stuck watching a longer-than-usual splash.
    final routeFuture = _resolveInitialRoute();
    await _animateProgress();
    final route = await routeFuture;
    Get.offAllNamed(route);
  }

  Future<void> _animateProgress() async {
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      progress.value = i / 10;
    }
  }

  /// A saved token means the user logged in before — but tokens expire, so
  /// we confirm it's still valid with a real request before trusting it.
  /// Only on a confirmed, valid session do we skip straight to the
  /// dashboard; anything else falls back to onboarding/login.
  Future<String> _resolveInitialRoute() async {
    if (await _apiClient.hasToken()) {
      try {
        await Get.find<AuthRepository>().getCurrentUser();
        return Routes.dashboard;
      } catch (e) {
        AppLogger.i('Saved session is no longer valid, clearing it: $e', tag: 'Splash');
        await _apiClient.clearToken();
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool(_seenOnboardingKey) ?? false;
    return seenOnboarding ? Routes.login : Routes.onboarding;
  }

  static const _seenOnboardingKey = 'has_seen_onboarding';
}
