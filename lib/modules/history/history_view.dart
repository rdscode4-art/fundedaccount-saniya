import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/position_model.dart';
import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Text('History', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => Row(
                    children: controller.filters.map((f) {
                      final selected = f == controller.selectedFilter.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () => controller.selectFilter(f),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(f,
                                style: TextStyle(
                                    color: selected ? Colors.white : AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.history.isEmpty) {
                  return const Center(
                      child: Text('No records found', style: TextStyle(color: AppColors.textSecondary)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: controller.history.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, i) => _HistoryTile(position: controller.history[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final PositionModel position;
  const _HistoryTile({required this.position});

  @override
  Widget build(BuildContext context) {
    final isBuy = position.side == PositionSide.buy;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(position.symbol,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  SideBadge(isBuy: isBuy),
                ],
              ),
              const SizedBox(height: 4),
              Text('${position.lots} Lots  →  ${Formatters.price(position.entryPrice, decimals: position.entryPrice > 100 ? 2 : 5)}',
                  style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Formatters.signedCurrency(position.pnl),
                style: TextStyle(
                    color: position.pnl >= 0 ? AppColors.success : AppColors.danger,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(position.openedAt, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
