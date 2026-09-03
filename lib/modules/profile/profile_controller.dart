import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final isLoading = true.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    user.value = await _authRepository.getCurrentUser();
    isLoading.value = false;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    Get.offAllNamed(Routes.login);
  }
}
