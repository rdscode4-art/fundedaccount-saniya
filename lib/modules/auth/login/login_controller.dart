import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;

  String? validateEmailOrMobile(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email or mobile number';
    final isEmailShaped = v.contains('@');
    if (isEmailShaped && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
      return 'Enter a valid email address';
    }
    if (!isEmailShaped && v.replaceAll(RegExp(r'[\s\-]'), '').length < 7) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Enter your password';
    return null;
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      await _authRepository.login(
        emailOrMobile: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      AppSnackbar.error('Login failed', e);
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
