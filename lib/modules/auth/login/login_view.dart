import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text('Welcome Back',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Login to your account',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 32),
              Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email or Mobile',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Enter email or mobile'),
                      validator: controller.validateEmailOrMobile,
                    ),
                    const SizedBox(height: 18),
                    const Text('Password',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 8),
                    Obx(() => TextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textTertiary,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          validator: controller.validatePassword,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.login,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Login'),
                  )),
              const SizedBox(height: 32),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Register',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()..onTap = controller.goToRegister,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
