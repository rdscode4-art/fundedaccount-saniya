import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/candle_model.dart';
import '../../data/models/position_model.dart';
import 'trade_chart_controller.dart';

class TradeChartView extends GetView<TradeChartController> {
  const TradeChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    const BackButton(color: Colors.white),
                    Text(controller.symbol.value,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                    const Spacer(),
                    IconButton(onPressed: controller.loadChart, icon: const Icon(Icons.refresh, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Formatters.price(controller.currentPrice),
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(
                            '${Formatters.signedCurrency(controller.change).replaceAll('\$', '')} (${Formatters.percent(controller.changePercent)})',
                            style: TextStyle(
                              color: controller.change >= 0 ? AppColors.success : AppColors.danger,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatItem(
                        label: 'High',
                        value: Formatters.price(controller.high),
                        alignment: CrossAxisAlignment.end),
                    const SizedBox(width: 20),
                    StatItem(
                        label: 'Low',
                        value: Formatters.price(controller.low),
                        alignment: CrossAxisAlignment.end),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: controller.timeframes.map((tf) {
                    final selected = tf == controller.timeframe.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => controller.setTimeframe(tf),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary.withOpacity(0.18) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(tf,
                              style: TextStyle(
                                color: selected ? AppColors.primary : AppColors.textTertiary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 5,
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _CandlestickChart(candles: controller.candles),
                      ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Open Positions (${controller.positions.length})',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            const Text('See All', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 20),
                        Expanded(
                          child: ListView.separated(
                            itemCount: controller.positions.length,
                            separatorBuilder: (_, __) => const Divider(height: 16),
                            itemBuilder: (context, i) {
                              final p = controller.positions[i];
                              return _PositionTile(position: p);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.goToNewOrder,
                    child: const Text('New Order'),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _PositionTile extends StatelessWidget {
  final PositionModel position;
  const _PositionTile({required this.position});

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
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  SideBadge(isBuy: isBuy),
                ],
              ),
              const SizedBox(height: 2),
              Text('${position.lots} Lots · ${Formatters.price(position.entryPrice)}',
                  style: const TextStyle(color: AppColors.textTertiary, fontSize: 11)),
            ],
          ),
        ),
        Text(Formatters.signedCurrency(position.pnl),
            style: TextStyle(
                color: position.pnl >= 0 ? AppColors.success : AppColors.danger,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _CandlestickChart extends StatelessWidget {
  final List<CandleModel> candles;
  const _CandlestickChart({required this.candles});

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) return const SizedBox.shrink();
    final minY = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final maxY = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY) * 0.1;

    return BarChart(
      BarChartData(
        minY: minY - pad,
        maxY: maxY + pad,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY + pad * 2) / 4,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 54,
              getTitlesWidget: _rightTitle,
            ),
          ),
        ),
        barTouchData: BarTouchData(enabled: false),
        barGroups: List.generate(candles.length, (i) {
          final c = candles[i];
          final color = c.isBullish ? AppColors.success : AppColors.danger;
          final bodyTop = c.isBullish ? c.close : c.open;
          final bodyBottom = c.isBullish ? c.open : c.close;
          return BarChartGroupData(
            x: i,
            barRods: [
              // wick
              BarChartRodData(
                toY: c.high,
                fromY: c.low,
                width: 1.4,
                color: color.withOpacity(0.6),
                borderRadius: BorderRadius.zero,
              ),
              // body
              BarChartRodData(
                toY: bodyTop,
                fromY: bodyBottom,
                width: 5,
                color: color,
                borderRadius: BorderRadius.zero,
              ),
            ],
            barsSpace: 0,
          );
        }),
      ),
    );
  }

  static Widget _rightTitle(double value, TitleMeta meta) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        value.toStringAsFixed(4),
        style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
      ),
    );
  }
}
