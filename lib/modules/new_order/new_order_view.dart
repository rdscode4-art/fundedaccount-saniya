import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/models/order_model.dart';
import 'new_order_controller.dart';

class NewOrderView extends GetView<NewOrderController> {
  const NewOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New Order', style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(controller.symbol.value,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            )),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white))],
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SideButton(
                        label: 'Buy',
                        color: AppColors.success,
                        selected: controller.side.value == OrderSide.buy,
                        onTap: () => controller.selectSide(OrderSide.buy),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SideButton(
                        label: 'Sell',
                        color: AppColors.danger,
                        selected: controller.side.value == OrderSide.sell,
                        onTap: () => controller.selectSide(OrderSide.sell),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _StepperField(
                  label: 'Lot Size',
                  value: controller.lotSize.value.toStringAsFixed(2),
                  onMinus: () => controller.adjustLot(-0.01),
                  onPlus: () => controller.adjustLot(0.01),
                ),
                _StepperField(
                  label: 'Risk',
                  value: '${controller.riskPercent.value.toStringAsFixed(2)}%',
                  onMinus: () => controller.adjustRisk(-0.1),
                  onPlus: () => controller.adjustRisk(0.1),
                ),
                _StepperField(
                  label: 'Entry Price',
                  value: Formatters.price(controller.entryPrice.value),
                  onMinus: () => controller.adjustEntry(-0.00005),
                  onPlus: () => controller.adjustEntry(0.00005),
                ),
                _StepperField(
                  label: 'Stop Loss',
                  value: Formatters.price(controller.stopLoss.value),
                  onMinus: () => controller.adjustStopLoss(-0.00005),
                  onPlus: () => controller.adjustStopLoss(0.00005),
                ),
                _StepperField(
                  label: 'Take Profit',
                  value: Formatters.price(controller.takeProfit.value),
                  onMinus: () => controller.adjustTakeProfit(-0.00005),
                  onPlus: () => controller.adjustTakeProfit(0.00005),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Risk / Reward', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    Text('1:${controller.riskReward.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Est. P&L', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    Text(Formatters.signedCurrency(controller.estimatedPnl),
                        style: const TextStyle(
                            color: AppColors.success, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.side.value == OrderSide.buy ? AppColors.success : AppColors.danger,
                    ),
                    onPressed: controller.isPlacingOrder.value ? null : controller.placeOrder,
                    child: controller.isPlacingOrder.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Place ${controller.side.value == OrderSide.buy ? 'Buy' : 'Sell'} Order'),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class _SideButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _SideButton({required this.label, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}

class _StepperField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  const _StepperField({required this.label, required this.value, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Row(
            children: [
              _iconBtn(Icons.remove, onMinus),
              Container(
                width: 90,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              _iconBtn(Icons.add, onPlus),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
