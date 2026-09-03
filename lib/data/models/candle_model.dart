class CandleModel {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  const CandleModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  bool get isBullish => close >= open;
}
