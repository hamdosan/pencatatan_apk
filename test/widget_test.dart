import 'package:expense_tracker/controllers/expense_controller.dart';
import 'package:expense_tracker/controllers/locale_controller.dart';
import 'package:expense_tracker/controllers/theme_controller.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  // ExpenseController.init() tidak dipanggil agar test tidak menyentuh SQLite.
  Widget app() => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ExpenseController()),
          ChangeNotifierProvider(create: (_) => ThemeController()),
          ChangeNotifierProvider(create: (_) => LocaleController()),
        ],
        child: const ExpenseTrackerApp(splash: false),
      );

  testWidgets('Halaman utama tampil', (tester) async {
    await tester.pumpWidget(app());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byTooltip('Home'), findsOneWidget);
    expect(find.byTooltip('Pencatatan'), findsOneWidget);
    expect(find.byTooltip('Tambah Pengeluaran'), findsOneWidget);
  });

  testWidgets('Navigasi bawah pindah ke Pencatatan lalu kembali ke Home',
      (tester) async {
    await tester.pumpWidget(app());

    await tester.tap(find.byTooltip('Pencatatan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Pencatatan'), findsOneWidget);

    await tester.tap(find.byTooltip('Home'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('Tombol hamburger membuka drawer menu', (tester) async {
    await tester.pumpWidget(app());

    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Riwayat'), findsOneWidget);
  });

  testWidgets('Tap bulan membuka pilih bulan, tap tahun membuka pilih tahun',
      (tester) async {
    await tester.pumpWidget(app());

    await tester.tap(find.byTooltip('Pilih bulan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.textContaining('Pilih bulan ('), findsOneWidget);
    expect(find.text('Jan'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byTooltip('Pilih tahun'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Pilih tahun'), findsWidgets);
    expect(find.byType(YearPicker), findsOneWidget);
  });

  testWidgets('Form tambah memformat nominal dengan titik ribuan',
      (tester) async {
    await tester.pumpWidget(app());

    await tester.tap(find.byTooltip('Tambah Pengeluaran'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Tambah Pengeluaran'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nominal'),
      '1000',
    );
    await tester.pump();

    expect(find.text('1.000'), findsOneWidget);
  });
}
