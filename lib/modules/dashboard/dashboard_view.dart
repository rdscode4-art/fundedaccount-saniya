import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/progress_bar.dart';
import '../../data/models/position_model.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value || controller.account.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final account = controller.account.value!;
          return RefreshIndicator(
            onRefresh: controller.loadDashboard,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Good Morning, Trader 📈',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Active Account',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '#${account.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: AppColors.success,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Active',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Funded Balance',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.currency(account.fundedBalance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Formatters.signedCurrency(account.profit)} (${Formatters.percent(account.profitPercent)})',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: StatItem(
                              label: 'Equity',
                              value: Formatters.currency(account.equity),
                            ),
                          ),
                          Expanded(
                            child: StatItem(
                              label: 'Free Margin',
                              value: Formatters.currency(account.freeMargin),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Challenge Progress',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${(account.challengeProgress * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AppProgressBar(value: account.challengeProgress),
                      const SizedBox(height: 8),
                      Text(
                        'Target: ${Formatters.currency(account.challengeTarget)}   Current: ${Formatters.currency(account.challengeCurrent)}',
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Risk Monitor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(height: 20),
                      RowStat(
                        label: 'Daily Loss',
                        value:
                            '${Formatters.currency(account.fundedBalance * account.dailyLossUsed / 100)} / '
                            '${Formatters.currency(account.fundedBalance * account.dailyLossLimit / 100)}',
                      ),
                      RowStat(
                        label: 'Max Drawdown',
                        value:
                            '${Formatters.currency(account.fundedBalance * account.maxDrawdownUsed / 100)} / '
                            '${Formatters.currency(account.fundedBalance * account.maxDrawdown / 100)}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Open Positions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.goToPositions,
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      ...controller.positions.map(
                        (p) => _PositionRow(position: p),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _QuickAction(
                      icon: Icons.arrow_downward_rounded,
                      label: 'Deposit',
                      onTap: controller.goToDeposit,
                    ),
                    _QuickAction(
                      icon: Icons.credit_card_rounded,
                      label: 'Buy Account',
                      onTap: controller.goToAccounts,
                    ),
                    _QuickAction(
                      icon: Icons.candlestick_chart_rounded,
                      label: 'Trade',
                      onTap: controller.goToTrade,
                    ),
                    _QuickAction(
                      icon: Icons.list_alt_rounded,
                      label: 'Positions',
                      onTap: controller.goToPositions,
                    ),
                    _QuickAction(
                      icon: Icons.grid_view_rounded,
                      label: 'More',
                      onTap: controller.goToProfile,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _PositionRow extends StatelessWidget {
  final PositionModel position;
  const _PositionRow({required this.position});

  @override
  Widget build(BuildContext context) {
    final isBuy = position.side == PositionSide.buy;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  position.symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                SideBadge(isBuy: isBuy),
              ],
            ),
          ),
          Text(
            Formatters.signedCurrency(position.pnl),
            style: TextStyle(
              color: position.pnl >= 0 ? AppColors.success : AppColors.danger,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
