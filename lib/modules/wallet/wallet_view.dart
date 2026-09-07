import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/account_model.dart';
import '../../data/models/transaction_model.dart';
import 'wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  Future<void> _showAddFundsDialog(BuildContext context) async {
    // The dialog manages its own TextEditingController in _AddFundsDialog's
    // State — its dispose() only fires once Flutter actually removes the
    // widget from the tree (i.e. after the closing animation finishes).
    // Disposing a controller manually right after `showDialog` returns is
    // too early: the AlertDialog is still animating out and its TextField
    // is still mounted, which is what caused the
    // "TextEditingController used after being disposed" crash.
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => const _AddFundsDialog(),
    );

    if (result == null) return; // cancelled, or couldn't parse a number

    if (result <= 0) {
      AppSnackbar.warning('Invalid amount', 'Enter an amount greater than \$0');
      return;
    }

    if (result > 100000) {
      AppSnackbar.warning('Amount too high', 'Maximum deposit is \$100,000');
      return;
    }

    controller.deposit(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
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
          if (controller.wallet.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final w = controller.wallet.value!;
          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                const Text(
                  'Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Wallet Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const Icon(
                            Icons.visibility_outlined,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Formatters.currency(w.balance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Available Balance ${Formatters.currency(w.availableBalance)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        color: AppColors.surface,
                        child: StatItem(
                          label: 'Total Deposited',
                          value: Formatters.currency(w.totalDeposited),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppCard(
                        child: StatItem(
                          label: 'Total Payout',
                          value: Formatters.currency(w.totalPayout),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surfaceLight,
                            ),
                            onPressed: controller.isSubmittingDeposit.value
                                ? null
                                : () => _showAddFundsDialog(context),
                            child: controller.isSubmittingDeposit.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Add Funds'),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Trading Accounts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (w.fundedAccounts.isEmpty)
                  AppCard(
                    child: Text(
                      'No funded accounts yet. Buy a challenge to get started.',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  ...w.fundedAccounts.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _FundedAccountCard(account: a),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'See All',
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (controller.transactions.isEmpty)
                  const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No transactions yet',
                    subtitle: 'Deposits and purchases will appear here.',
                  )
                else
                  ...controller.transactions.map(
                    (t) => _TransactionTile(transaction: t),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _FundedAccountCard extends StatelessWidget {
  final FundedAccountSummary account;
  const _FundedAccountCard({required this.account});

  Color get _statusColor {
    switch (account.status) {
      case 'Passed':
        return AppColors.success;
      case 'Failed':
        return AppColors.danger;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${Formatters.currency(account.accountSize).replaceAll('.00', '')} Funded Account',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  account.status,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatItem(
                label: 'Balance',
                value: Formatters.currency(account.fundedBalance),
              ),
              StatItem(
                label: 'Equity',
                value: Formatters.currency(account.equity),
                alignment: CrossAxisAlignment.center,
              ),
              StatItem(
                label: 'Profit',
                value: Formatters.signedCurrency(account.profit),
                valueColor: account.profit >= 0 ? AppColors.success : AppColors.danger,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == TransactionType.deposit;
    final color = isDeposit ? AppColors.success : AppColors.danger;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDeposit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDeposit ? 'Deposit' : 'Challenge Purchase',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  Formatters.dateTime(transaction.date),
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.signedCurrency(transaction.amount),
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _statusText(transaction.status),
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.approved:
        return 'Approved';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}

/// Own StatefulWidget so its TextEditingController is disposed by the
/// framework at the right point in the dialog's lifecycle (after the close
/// animation finishes), not manually the instant `Navigator.pop` is called.
class _AddFundsDialog extends StatefulWidget {
  const _AddFundsDialog();

  @override
  State<_AddFundsDialog> createState() => _AddFundsDialogState();
}

class _AddFundsDialogState extends State<_AddFundsDialog> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      title: const Text(
        'Add Funds',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      content: TextField(
        controller: _amountController,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          prefixText: '\$ ',
          prefixStyle: const TextStyle(color: Colors.white70, fontSize: 18),
          hintText: 'Enter amount',
          hintStyle: const TextStyle(color: AppColors.textTertiary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        onSubmitted: (v) => Navigator.of(context).pop(double.tryParse(v.trim())),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            final value = double.tryParse(_amountController.text.trim());
            Navigator.of(context).pop(value);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}