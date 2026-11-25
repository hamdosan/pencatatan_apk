import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/views/widgets/category_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final categories = [
    for (var i = 0; i < 11; i++)
      Category(id: i, name: 'Kat $i', icon: 'other', colorValue: 0xFF607D8B),
  ];

  Future<void> pump(
    WidgetTester tester, {
    ValueChanged<int?>? onChanged,
    String? allOption,
    List<Category>? items,
  }) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: CategoryDropdown(
                categories: items ?? categories,
                value: null,
                onChanged: onChanged ?? (_) {},
                allOption: allOption,
              ),
            ),
          ),
        ),
      );

  double listHeight(WidgetTester tester) =>
      tester.getSize(find.byType(ListView)).height;

  testWidgets('tertutup di awal, tap menampilkan 5 item dan sisanya scroll',
      (tester) async {
    await pump(tester);
    expect(find.byType(ListView), findsNothing);

    await tester.tap(find.byType(InputDecorator));
    await tester.pump(const Duration(milliseconds: 100));
    expect(listHeight(tester), greaterThan(0));
    await tester.pumpAndSettle();

    // Tinggi area 5 item (dikurangi border 1px atas dan bawah).
    expect(listHeight(tester), 5 * 48.0 - 2);
    expect(find.text('Kat 4'), findsOneWidget);
    expect(find.text('Kat 10'), findsNothing);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Kat 10'), findsOneWidget);
  });

  testWidgets('kategori sedikit mengecilkan tinggi daftar', (tester) async {
    await pump(tester, items: categories.take(2).toList());

    await tester.tap(find.byType(InputDecorator));
    await tester.pumpAndSettle();

    expect(listHeight(tester), 2 * 48.0 - 2);
  });

  testWidgets('memilih item menutup daftar dan mengirim id', (tester) async {
    int? selected;
    await pump(tester, onChanged: (v) => selected = v);

    await tester.tap(find.byType(InputDecorator));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kat 3'));
    await tester.pumpAndSettle();

    expect(selected, 3);
    expect(find.byType(ListView), findsNothing);
    expect(find.text('Kat 3'), findsOneWidget);
  });

  testWidgets('allOption tampil di atas dan mengirim null', (tester) async {
    int? selected = 3;
    await pump(tester, allOption: 'Semua', onChanged: (v) => selected = v);
    expect(find.text('Semua'), findsOneWidget);

    await tester.tap(find.byType(InputDecorator));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Semua').last);
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });
}
