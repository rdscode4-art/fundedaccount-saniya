import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/progress_bar.dart';
import '../../core/widgets/state_views.dart';
import 'account_details_controller.dart';

class AccountDetailsView extends GetView<AccountDetailsController> {
  const AccountDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Account Details', style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return ErrorRetryState(
            message: controller.errorMessage.value!,
            onRetry: controller.load,
          );
        }
        if (controller.account.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final a = controller.account.value!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Account #${a.id}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('Active',
                                    style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${Formatters.currency(a.fundedBalance).replaceAll('.00', '')} Account',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppCard(
                      child: Column(
                        children: [
                          RowStat(label: 'Account Balance', value: Formatters.currency(a.fundedBalance)),
                          RowStat(label: 'Equity', value: Formatters.currency(a.equity)),
                          RowStat(
                            label: 'Current Profit',
                            value: '${Formatters.signedCurrency(a.profit)} (${Formatters.percent(a.profitPercent)})',
                            valueColor: AppColors.success,
                          ),
                          RowStat(label: 'Profit Target', value: Formatters.currency(a.challengeTarget)),
                          RowStat(label: 'Remaining Target', value: Formatters.currency(a.remainingTarget)),
                          RowStat(label: 'Daily Loss Limit', value: Formatters.currency(a.dailyLossLimit)),
                          RowStat(label: 'Remaining Daily Loss', value: Formatters.currency(a.remainingDailyLoss)),
                          RowStat(label: 'Max Drawdown', value: Formatters.currency(a.maxDrawdown)),
                          RowStat(label: 'Remaining Drawdown', value: Formatters.currency(a.remainingDrawdown)),
                          RowStat(label: 'Trading Days', value: '${a.tradingDays}'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Challenge Progress',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              Text('${(a.challengeProgress * 100).round()}%',
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AppProgressBar(value: a.challengeProgress),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Account Started',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              Text(a.startedDate,
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.goToTrade,
                  child: const Text('Go to Trade'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
