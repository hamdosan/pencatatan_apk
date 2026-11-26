import 'package:expense_tracker/controllers/expense_controller.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/views/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class _FakeController extends ExpenseController {
  static const _categories = [
    Category(id: 1, name: 'Makanan', icon: 'food', colorValue: 0xFFFF9800),
    Category(id: 2, name: 'Game', icon: 'game', colorValue: 0xFF00BCD4),
  ];

  @override
  List<Category> get categories => _categories;

  @override
  List<Expense> get expenses => [
        Expense(
          id: 1,
          title: 'Nasi goreng',
          amount: 15000,
          categoryId: 1,
          date: DateTime(2026, 10, 2),
        ),
        Expense(
          id: 2,
          title: 'Voucher',
          amount: 50000,
          categoryId: 2,
          date: DateTime(2026, 10, 1),
        ),
      ];

  @override
  DateTime get selectedMonth => DateTime(2026, 10);

  @override
  Category? categoryOf(int id) =>
      _categories.where((c) => c.id == id).firstOrNull;
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  Future<void> pick(WidgetTester tester, String name) async {
    await tester.tap(find.byType(InputDecorator));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(ListView).first,
      matching: find.text(name),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('judul memuat bulan, filter menyisakan kategori terpilih',
      (tester) async {
    // Animasi latar berjalan terus; matikan agar pumpAndSettle bisa selesai.
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(
      ChangeNotifierProvider<ExpenseController>(
        create: (_) => _FakeController(),
        child: const MaterialApp(home: HistoryPage()),
      ),
    );

    expect(find.text('Riwayat Oktober 2026'), findsOneWidget);
    expect(find.text('Nasi goreng'), findsOneWidget);
    expect(find.text('Voucher'), findsOneWidget);

    await pick(tester, 'Makanan');
    expect(find.text('Nasi goreng'), findsOneWidget);
    expect(find.text('Voucher'), findsNothing);

    await pick(tester, 'Semua kategori');
    expect(find.text('Voucher'), findsOneWidget);
  });
}
