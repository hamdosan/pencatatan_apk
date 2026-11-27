import 'package:expense_tracker/controllers/expense_controller.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/views/balance_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Pemasukan tetap 4 jt, pengeluaran 5 jt.
class _FakeController extends ExpenseController {
  @override
  int get monthlyIncome => 4000000;

  @override
  int get totalAmount => 5000000;

  @override
  bool get isLoading => false;

  @override
  DateTime get selectedMonth => DateTime(2026, 11);

  @override
  List<(DateTime, int, int)> get balanceTrend => [
        (DateTime(2026, 10), 4000000, 3000000),
        (DateTime(2026, 11), 4000000, 5000000)
      ];
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('pemasukan bolak-balik lewat map', () {
    final i = Income(amount: 100000, date: DateTime(2026, 11, 2), note: 'Gaji');
    final i2 = Income.fromMap(i.toMap()..['id'] = 3);
    expect((i2.id, i2.amount, i2.date, i2.note),
        (3, 100000, DateTime(2026, 11, 2), 'Gaji'));
  });

  test('saldo bulan = pemasukan tetap - pengeluaran', () {
    final c = _FakeController();
    expect(c.monthIncome, 4000000);
    expect(c.balance, -1000000);
  });

  testWidgets('halaman saldo menampilkan minus 1 jt dan grafik',
      (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(ChangeNotifierProvider<ExpenseController>(
      create: (_) => _FakeController(),
      child: const MaterialApp(home: BalancePage()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Saldo Anda minus Rp 1.000.000'), findsOneWidget);
    expect(find.text('-Rp 1.000.000'), findsOneWidget);
    expect(find.text('Terpakai 125% dari pemasukan'), findsOneWidget);
    expect(find.text('Pemasukan vs pengeluaran'), findsOneWidget);
  });
}
