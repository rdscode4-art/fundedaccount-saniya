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

  /// Maps a candle from `GET /api/trading/candles`:
  /// `{ time: "2024-05-02 10:45:00", open, high, low, close }`
  factory CandleModel.fromJson(Map<String, dynamic> json) {
    double num_(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return CandleModel(
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
      open: num_(json['open']),
      high: num_(json['high']),
      low: num_(json['low']),
      close: num_(json['close']),
    );
  }
}
