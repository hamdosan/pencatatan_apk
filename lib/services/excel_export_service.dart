import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import '../models/category.dart';
import '../models/expense.dart';

/// Membuat file .xlsx rekap tahunan:
/// - "Rekap"       : total & jumlah transaksi per bulan
/// - "Per Kategori": total per kategori setahun
/// - "Detail"      : semua transaksi
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

  static String fileName(int year) => 'Rekap_Pengeluaran_$year.xlsx';

  /// [recaps] = 12 bulan dari [ExpenseController.recapOfYear];
  /// bulan setelah [lastMonth] tidak ditulis.
  static Uint8List build({
    required int year,
    required List<MonthRecap> recaps,
    required List<Expense> expenses,
    required Category? Function(int id) categoryOf,
    required DateTime lastMonth,
  }) {
    final excel = Excel.createExcel();
    final recapName = 'Rekap $year';
    excel.rename(excel.getDefaultSheet()!, recapName);

    _writeRecap(excel[recapName], year, recaps, lastMonth);
    _writeCategories(excel['Per Kategori'], year, expenses, categoryOf);
    _writeDetail(excel['Detail'], expenses, categoryOf);
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
    int year,
    List<MonthRecap> recaps,
    DateTime lastMonth,
  ) {
    _set(s, 0, 0, TextCellValue('Rekap Pengeluaran Tahun $year'), _title);
    _headerRow(s, 2, ['Bulan', 'Jumlah Transaksi', 'Total', 'Perubahan vs Bulan Lalu']);

    var row = 3;
    var total = 0, count = 0;
    for (final r in recaps) {
      if (r.month.isAfter(lastMonth)) break;
      _set(s, 0, row, TextCellValue(DateFormat('MMMM', 'id_ID').format(r.month)));
      _set(s, 1, row, IntCellValue(r.count));
      _set(s, 2, row, IntCellValue(r.total), _money);
      final change = r.changePercent;
      _set(s, 3, row,
          change == null ? TextCellValue('-') : DoubleCellValue(change / 100),
          change == null ? null : _pct);
      total += r.total;
      count += r.count;
      row++;
    }
    _set(s, 0, row, TextCellValue('TOTAL'), _bold);
    _set(s, 1, row, IntCellValue(count), _bold);
    _set(s, 2, row, IntCellValue(total), _moneyBold);

    s.setColumnWidth(0, 16);
    s.setColumnWidth(1, 18);
    s.setColumnWidth(2, 18);
    s.setColumnWidth(3, 24);
  }

  static void _writeCategories(
    Sheet s,
    int year,
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

    _set(s, 0, 0, TextCellValue('Pengeluaran per Kategori $year'), _title);
    _headerRow(s, 2, ['Kategori', 'Jumlah Transaksi', 'Total', 'Porsi']);
    var row = 3;
    for (final e in sorted) {
      _set(s, 0, row, TextCellValue(categoryOf(e.key)?.name ?? '-'));
      _set(s, 1, row, IntCellValue(counts[e.key]!));
      _set(s, 2, row, IntCellValue(e.value), _money);
      _set(s, 3, row, DoubleCellValue(grand == 0 ? 0 : e.value / grand), _pct);
      row++;
    }
    _set(s, 0, row, TextCellValue('TOTAL'), _bold);
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
    _headerRow(s, 0, ['Tanggal', 'Judul', 'Kategori', 'Nominal', 'Catatan']);
    var row = 1;
    for (final e in expenses) {
      _set(s, 0, row,
          DateCellValue(year: e.date.year, month: e.date.month, day: e.date.day));
      _set(s, 1, row, TextCellValue(e.title));
      _set(s, 2, row, TextCellValue(categoryOf(e.categoryId)?.name ?? '-'));
      _set(s, 3, row, IntCellValue(e.amount), _money);
      _set(s, 4, row, TextCellValue(e.note ?? ''));
      row++;
    }
    s.setColumnWidth(0, 12);
    s.setColumnWidth(1, 28);
    s.setColumnWidth(2, 18);
    s.setColumnWidth(3, 16);
    s.setColumnWidth(4, 32);
  }
}
