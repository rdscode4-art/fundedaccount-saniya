import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  final double value; // 0..1
  final double height;
  final Color color;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        backgroundColor: AppColors.surfaceLighter,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
