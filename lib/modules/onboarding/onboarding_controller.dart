import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';

class OnboardingStep {
  final String title;
  final String subtitle;
  final int
  icon; // codepoint index reference not needed, use enum instead in view
  const OnboardingStep(this.title, this.subtitle, this.icon);
}

class OnboardingController extends GetxController {
  final pageIndex = 0.obs;

  final steps = const [
    OnboardingStep(
      'Choose Account',
      'Select a funded account that fits your goals',
      0,
    ),
    OnboardingStep(
      'Pass Challenge',
      'Complete the challenge by hitting profit targets',
      1,
    ),
    OnboardingStep(
      'Trade & Grow',
      'Follow the rules, manage risk and grow your account',
      2,
    ),
    OnboardingStep(
      'Track Progress',
      'Monitor your funded account performance',
      3,
    ),
  ];

  Future<void> getStarted() async {
    // So a returning user who logs out later lands on Login next time,
    // not back through the full onboarding carousel (Splash checks this).
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    Get.toNamed(Routes.login);
  }
}
