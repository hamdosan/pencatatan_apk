import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../l10n/l10n.dart';

class ExcelExportService {
  static const _rupiah = CustomNumericNumFormat(formatCode: '"Rp" #,##0');
  static const _percent = CustomNumericNumFormat(formatCode: '0.0%');

  static final _title = CellStyle(bold: true, fontSize: 14);
  static final _header = CellStyle(
    bold: true,
    backgroundColorHex: ExcelColor.fromHexString('#B2DFDB'),
    horizontalAlign: HorizontalAlign.Center,
  );
  static final _money = CellStyle(numberFormat: _rupiah);
  static final _moneyBold = CellStyle(numberFormat: _rupiah, bold: true);
  static final _pct = CellStyle(numberFormat: _percent);
  static final _bold = CellStyle(bold: true);

  static String _short(int year, int m) =>
      DateFormat('MMM', L10n.intlLocale).format(DateTime(year, m));

  static String _shortFile(int year, int m) =>
      DateFormat('MMM', 'en_US').format(DateTime(year, m));

  static String periodLabel(int year, Set<int> months) {
    final sorted = months.toList()..sort();
    if (sorted.length == 12) return tr('yearLabel', {'y': year});
    if (sorted.length == 1) {
      return DateFormat('MMMM y', L10n.intlLocale)
          .format(DateTime(year, sorted.first));
    }
    return '${sorted.map((m) => _short(year, m)).join(', ')} $year';
  }

  static String fileName(int year, Set<int> months) {
    final sorted = months.toList()..sort();
    final prefix = tr('fileRecap');
    if (sorted.length == 12) return '${prefix}_$year.xlsx';
    if (sorted.length == 1) {
      return '${prefix}_$year-${sorted.first.toString().padLeft(2, '0')}.xlsx';
    }
    return '${prefix}_${year}_${sorted.map((m) => _shortFile(year, m)).join('-')}.xlsx';
  }

  static Uint8List build({
    required int year,
    required Set<int> months,
    required List<MonthRecap> recaps,
    required List<Expense> expenses,
    required Category? Function(int id) categoryOf,
  }) {
    final excel = Excel.createExcel();
    final recapName = tr('sheetRecap');
    excel.rename(excel.getDefaultSheet()!, recapName);

    final period = periodLabel(year, months);
    final selectedRecaps = [
      for (final r in recaps)
        if (months.contains(r.month.month)) r,
    ];
    final selectedExpenses = [
      for (final e in expenses)
        if (e.date.year == year && months.contains(e.date.month)) e,
    ];

    _writeRecap(excel[recapName], period, selectedRecaps);
    _writeCategories(
        excel[tr('sheetByCategory')], period, selectedExpenses, categoryOf);
    _writeDetail(excel[tr('sheetDetail')], selectedExpenses, categoryOf);
    excel.setDefaultSheet(recapName);

    return Uint8List.fromList(excel.encode()!);
  }

  static void _set(Sheet s, int col, int row, CellValue? v, [CellStyle? st]) =>
      s.updateCell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
        v,
        cellStyle: st,
      );

  static void _headerRow(Sheet s, int row, List<String> labels) {
    for (var i = 0; i < labels.length; i++) {
      _set(s, i, row, TextCellValue(labels[i]), _header);
    }
  }

  static void _writeRecap(
    Sheet s,
    String period,
    List<MonthRecap> recaps,
  ) {
    _set(s, 0, 0, TextCellValue(tr('recapTitle', {'p': period})), _title);
    _headerRow(
        s, 2, [tr('month'), tr('txCount'), tr('total'), tr('changeVsLast')]);

    var row = 3;
    var total = 0, count = 0;
    for (final r in recaps) {
      _set(s, 0, row,
          TextCellValue(DateFormat('MMMM y', L10n.intlLocale).format(r.month)));
      _set(s, 1, row, IntCellValue(r.count));
      _set(s, 2, row, IntCellValue(r.total), _money);
      final change = r.changePercent;
      _set(
          s,
          3,
          row,
          change == null ? TextCellValue('-') : DoubleCellValue(change / 100),
          change == null ? null : _pct);
      total += r.total;
      count += r.count;
      row++;
    }
    _set(s, 0, row, TextCellValue(tr('totalUpper')), _bold);
    _set(s, 1, row, IntCellValue(count), _bold);
    _set(s, 2, row, IntCellValue(total), _moneyBold);

    s.setColumnWidth(0, 16);
    s.setColumnWidth(1, 18);
    s.setColumnWidth(2, 18);
    s.setColumnWidth(3, 24);
  }

  static void _writeCategories(
    Sheet s,
    String period,
    List<Expense> expenses,
    Category? Function(int id) categoryOf,
  ) {
    final totals = <int, int>{}, counts = <int, int>{};
    for (final e in expenses) {
      totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amount;
      counts[e.categoryId] = (counts[e.categoryId] ?? 0) + 1;
    }
    final grand = totals.values.fold(0, (a, b) => a + b);
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _set(s, 0, 0, TextCellValue(tr('byCategoryTitle', {'p': period})), _title);
    _headerRow(s, 2, [tr('category'), tr('txCount'), tr('total'), tr('share')]);
    var row = 3;
    for (final e in sorted) {
      _set(s, 0, row, TextCellValue(categoryOf(e.key)?.displayName ?? '-'));
      _set(s, 1, row, IntCellValue(counts[e.key]!));
      _set(s, 2, row, IntCellValue(e.value), _money);
      _set(s, 3, row, DoubleCellValue(grand == 0 ? 0 : e.value / grand), _pct);
      row++;
    }
    _set(s, 0, row, TextCellValue(tr('totalUpper')), _bold);
    _set(s, 2, row, IntCellValue(grand), _moneyBold);

    s.setColumnWidth(0, 20);
    s.setColumnWidth(1, 18);
    s.setColumnWidth(2, 18);
    s.setColumnWidth(3, 10);
  }

  static void _writeDetail(
    Sheet s,
    List<Expense> expenses,
    Category? Function(int id) categoryOf,
  ) {
    _headerRow(s, 0, [tr('date'), tr('category'), tr('amount'), tr('note')]);
    var row = 1;
    for (final e in expenses) {
      _set(
          s,
          0,
          row,
          DateCellValue(
              year: e.date.year, month: e.date.month, day: e.date.day));
      _set(s, 1, row,
          TextCellValue(categoryOf(e.categoryId)?.displayName ?? '-'));
      _set(s, 2, row, IntCellValue(e.amount), _money);
      _set(s, 3, row, TextCellValue(e.note ?? ''));
      row++;
    }
    s.setColumnWidth(0, 12);
    s.setColumnWidth(1, 18);
    s.setColumnWidth(2, 16);
    s.setColumnWidth(3, 32);
  }
}
