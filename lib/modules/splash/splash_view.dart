import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/progress_bar.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.candlestick_chart_rounded,
                    color: AppColors.primary, size: 42),
              ),
              const SizedBox(height: 20),
              const Text('FUNDX',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2)),
              const SizedBox(height: 6),
              const Text('Trade. Prove. Earn.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const Spacer(flex: 4),
              Obx(() => Column(
                    children: [
                      AppProgressBar(value: controller.progress.value),
                      const SizedBox(height: 10),
                      const Text('Loading...',
                          style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                    ],
                  )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
