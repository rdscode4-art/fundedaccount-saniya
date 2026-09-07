import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/state_views.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  static const _menuItems = [
    (icon: Icons.person_outline_rounded, label: 'Personal Information'),
    (icon: Icons.verified_user_outlined, label: 'KYC Verification'),
    (icon: Icons.shield_outlined, label: 'Security'),
    (icon: Icons.lock_outline_rounded, label: 'Password'),
    (icon: Icons.security_rounded, label: 'Two-Factor Authentication'),
    (icon: Icons.credit_card_outlined, label: 'Payment Methods'),
    (icon: Icons.tune_rounded, label: 'Trading Preferences'),
    (icon: Icons.notifications_none_rounded, label: 'Notifications'),
    (icon: Icons.help_outline_rounded, label: 'Help & Support'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value != null) {
            return ErrorRetryState(
              message: controller.errorMessage.value!,
              onRetry: controller.load,
            );
          }
          if (controller.user.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = controller.user.value!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(height: 4),
                            const Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.success,
                                  size: 13,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: List.generate(_menuItems.length, (i) {
                    final item = _menuItems[i];
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            item.icon,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          title: Text(
                            item.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          trailing: item.label == 'KYC Verification'
                              ? const Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                  ),
                                )
                              : item.label == 'Two-Factor Authentication'
                              ? const Text(
                                  'On',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                  ),
                                )
                              : const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.textTertiary,
                                  size: 20,
                                ),
                        ),
                        if (i != _menuItems.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.danger,
                    size: 20,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: AppColors.danger, fontSize: 14),
                  ),
                  onTap: controller.logout,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
