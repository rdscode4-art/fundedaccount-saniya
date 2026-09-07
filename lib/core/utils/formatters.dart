import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currency =
      NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  static final _plain = NumberFormat('#,##0.00');

  static final _dateTime =
      DateFormat('dd MMM yyyy, hh:mm a');

  static String currency(double value) => _currency.format(value);

  static String signedCurrency(double value) {
    final sign = value >= 0 ? '+' : '-';
    return '$sign\$${_plain.format(value.abs())}';
  }

  static String percent(double value, {bool signed = true}) {
    final sign = signed ? (value >= 0 ? '+' : '') : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  static String price(double value, {int decimals = 5}) =>
      value.toStringAsFixed(decimals);

  static String dateTime(String value) {
    if (value.isEmpty) return '';

    try {
      final date = DateTime.parse(value).toLocal();
      return _dateTime.format(date);
    } catch (_) {
      return value;
    }
  }
}