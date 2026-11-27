import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../l10n/l10n.dart';

final _rupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatRupiah(num value) => _rupiah.format(value);

String formatDate(DateTime d) =>
    DateFormat('EEE, d MMM y', L10n.intlLocale).format(d);

String formatMonth(DateTime d) =>
    DateFormat('MMMM y', L10n.intlLocale).format(d);

final _nonDigit = RegExp(r'\D');

String groupThousands(String digits) => digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+$)'),
      (_) => '.',
    );

int? parseThousands(String? text) =>
    int.tryParse((text ?? '').replaceAll('.', ''));

class ThousandsInputFormatter extends TextInputFormatter {
  const ThousandsInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    var cursor = newValue.selection.end;
    if (cursor < 0 || cursor > text.length) cursor = text.length;

    final deletedSeparator = text.length < oldValue.text.length &&
        text.replaceAll(_nonDigit, '') ==
            oldValue.text.replaceAll(_nonDigit, '');
    if (deletedSeparator && cursor > 0) {
      text = text.replaceRange(cursor - 1, cursor, '');
      cursor--;
    }

    final digitsAfterCursor =
        text.substring(cursor).replaceAll(_nonDigit, '').length;
    final digits =
        text.replaceAll(_nonDigit, '').replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final formatted = groupThousands(digits);

    var offset = formatted.length;
    var remaining = digitsAfterCursor;
    while (offset > 0 && remaining > 0) {
      offset--;
      if (formatted[offset] != '.') remaining--;
    }
    if (offset > 0 && formatted[offset - 1] == '.') offset--;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

String compactNumber(num v) {
  if (v >= 1000000) {
    return tr('compactMillion',
        {'v': NumberFormat('#,##0.#', L10n.intlLocale).format(v / 1000000)});
  }
  if (v >= 1000) return tr('compactThousand', {'v': (v / 1000).round()});
  return v.toStringAsFixed(0);
}

// Batas atas sumbu grafik yang "bulat" (1, 2, 2.5, 5 x 10^n).
double niceChartMax(int max) {
  if (max <= 0) return 1;
  final mag = math.pow(10, (math.log(max) / math.ln10).floor()).toDouble();
  for (final step in [1, 2, 2.5, 5, 10]) {
    if (step * mag >= max) return step * mag;
  }
  return 10 * mag;
}
