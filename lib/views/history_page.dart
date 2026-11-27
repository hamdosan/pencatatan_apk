import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import 'expense_form_page.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/expense_tile.dart';
import 'widgets/formatters.dart';
import 'widgets/glass.dart';
import '../l10n/l10n.dart';

/// Riwayat pengeluaran pada bulan yang dipilih di halaman utama,
/// dengan filter per kategori.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  /// Null = semua kategori.
  int? _categoryId;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();
    final expenses = [
      for (final e in controller.expenses)
        if (_categoryId == null || e.categoryId == _categoryId) e,
    ];

    return AppBackground(
        ambient: true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(tr('historyTitle',
                {'month': formatMonth(controller.selectedMonth)})),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: CategoryDropdown(
                  categories: controller.categories,
                  value: _categoryId,
                  allOption: tr('allCategories'),
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
              ),
              Expanded(
                child: expenses.isEmpty
                    ? Center(child: Text(tr('noExpenses')))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: expenses.length,
                        itemBuilder: (context, i) {
                          final e = expenses[i];
                          return ExpenseTile(
                            expense: e,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ExpenseFormPage(expense: e),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}
