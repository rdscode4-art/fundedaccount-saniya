import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      progress.value = i / 10;
    }
    Get.offAllNamed(Routes.onboarding);
  }
}
