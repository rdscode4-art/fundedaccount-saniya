import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/models/account_model.dart';
import 'choose_account_controller.dart';

class ChooseAccountView extends GetView<ChooseAccountController> {
  const ChooseAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Choose Funded Account', style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
      // No entry in AppBottomNav's own route list highlights this screen,
      // so currentIndex: -1 just leaves all icons unselected. This is here
      // so a brand-new user (who lands here with an empty nav stack) can
      // still reach Wallet to add funds before buying a challenge.
      bottomNavigationBar: const AppBottomNav(currentIndex: -1),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: controller.plans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final plan = controller.plans[i];
                return _PlanCard(plan: plan, onTap: () => controller.selectPlan(plan));
              },
            ),
            if (controller.isCreatingAccount.value)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final FundedPlanModel plan;
  final VoidCallback onTap;
  const _PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text('${Formatters.currency(plan.accountSize).replaceAll('.00', '')} Account',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
                Text('\$${plan.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MiniStat(label: 'Profit Target', value: Formatters.percent(plan.profitTarget, signed: false)),
                _MiniStat(label: 'Daily Loss', value: Formatters.percent(plan.dailyLoss, signed: false)),
                _MiniStat(label: 'Max Drawdown', value: Formatters.percent(plan.maxDrawdown, signed: false)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}