import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController(text: 'johntrader@gmail.com');
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;

    Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar('Missing details', 'Please enter your email/mobile and password');
      return;
    }
    isLoading.value = true;
    try {
      await _authRepository.login(
        emailOrMobile: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar('Login failed', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(Routes.register);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
