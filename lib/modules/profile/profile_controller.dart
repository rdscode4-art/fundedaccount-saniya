import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      user.value = await _authRepository.getCurrentUser();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      Get.offAllNamed(Routes.login);
    } catch (e) {
      AppSnackbar.error('Logout failed', e);
    }
  }
}
