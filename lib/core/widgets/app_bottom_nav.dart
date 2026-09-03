import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home', route: Routes.dashboard),
    (icon: Icons.show_chart_rounded, label: 'Markets', route: Routes.tradeChart),
    (icon: Icons.swap_horiz_rounded, label: 'Trade', route: Routes.newOrder),
    (icon: Icons.account_balance_wallet_rounded, label: 'Wallet', route: Routes.wallet),
    (icon: Icons.person_rounded, label: 'Profile', route: Routes.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final selected = i == currentIndex;
            final color = selected ? AppColors.primary : AppColors.textTertiary;
            return InkWell(
              onTap: () {
                if (!selected) Get.offAllNamed(item.route);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, color: color, size: 22),
                  const SizedBox(height: 4),
                  Text(item.label, style: TextStyle(color: color, fontSize: 11)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
