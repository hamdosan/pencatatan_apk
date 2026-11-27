import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import '../l10n/l10n.dart';
import '../models/income.dart';
import 'theme/app_theme.dart';
import 'widgets/formatters.dart';
import 'widgets/glass.dart';
import 'widgets/month_selector.dart';

const incomeColor = Color(0xFF43A047);
const expenseColor = Color(0xFFE53935);

// Form tambah pemasukan tambahan pada bulan terpilih.
Future<bool> showIncomeDialog(BuildContext context) async {
  final controller = context.read<ExpenseController>();
  final messenger = ScaffoldMessenger.of(context);
  final income = await showDialog<Income>(
    context: context,
    builder: (_) => _IncomeDialog(month: controller.selectedMonth),
  );
  if (income == null) return false;
  await controller.addIncome(income);
  messenger.showSnackBar(SnackBar(content: Text(tr('incomeAdded'))));
  return true;
}

Future<void> showMonthlyIncomeDialog(BuildContext context) async {
  final controller = context.read<ExpenseController>();
  final amount = await showDialog<int>(
    context: context,
    builder: (_) => _MonthlyIncomeDialog(initial: controller.monthlyIncome),
  );
  if (amount != null) await controller.setMonthlyIncome(amount);
}

// Simpan di atas (lebar penuh), Batal di bawahnya di tengah.
Widget _saveCancelActions(BuildContext context, VoidCallback onSave) =>
    SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(onPressed: onSave, child: Text(tr('save'))),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('cancel')),
          ),
        ],
      ),
    );

class _IncomeDialog extends StatefulWidget {
  const _IncomeDialog({required this.month});
  final DateTime month;

  @override
  State<_IncomeDialog> createState() => _IncomeDialogState();
}

class _IncomeDialogState extends State<_IncomeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    // Bulan berjalan: hari ini. Bulan lampau: hari terakhir bulan itu.
    final now = DateTime.now();
    final m = widget.month;
    _date = m.year == now.year && m.month == now.month
        ? now
        : DateTime(m.year, m.month + 1, 0);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final note = _noteCtrl.text.trim();
    Navigator.pop(
      context,
      Income(
        amount: parseThousands(_amountCtrl.text)!,
        date: _date,
        note: note.isEmpty ? null : note,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(tr('addIncome')),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _amountCtrl,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: const [ThousandsInputFormatter()],
                  decoration: InputDecoration(
                    labelText: tr('amount'),
                    prefixText: 'Rp ',
                  ),
                  validator: (v) {
                    final n = parseThousands(v);
                    return n == null || n <= 0 ? tr('amountInvalid') : null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: tr('date'),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(formatDate(_date)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteCtrl,
                  decoration: InputDecoration(labelText: tr('noteOptional')),
                ),
              ],
            ),
          ),
        ),
        actions: [_saveCancelActions(context, _submit)],
      );
}

class _MonthlyIncomeDialog extends StatefulWidget {
  const _MonthlyIncomeDialog({required this.initial});
  final int initial;

  @override
  State<_MonthlyIncomeDialog> createState() => _MonthlyIncomeDialogState();
}

class _MonthlyIncomeDialogState extends State<_MonthlyIncomeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _ctrl = TextEditingController(
    text: widget.initial == 0 ? '' : groupThousands('${widget.initial}'),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, parseThousands(_ctrl.text) ?? 0);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(tr('monthlyIncome')),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _ctrl,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: const [ThousandsInputFormatter()],
                decoration: InputDecoration(
                  labelText: tr('amount'),
                  prefixText: 'Rp ',
                ),
                // Kosong dianggap 0 (nonaktif).
                validator: (v) => (v ?? '').isNotEmpty &&
                        (parseThousands(v) == null || parseThousands(v)! < 0)
                    ? tr('amountNonNegative')
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 8),
              Text(
                tr('monthlyIncomeHint'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [_saveCancelActions(context, _submit)],
      );
}

class BalancePage extends StatelessWidget {
  const BalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ExpenseController>();

    return AppBackground(
      ambient: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(tr('balance'))),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            MonthSelector(controller: c),
            if (c.isLoading)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _BalanceSummary(controller: c),
              GlassCard(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: tr('incomeVsExpense')),
                    const SizedBox(height: 16),
                    _IncomeExpenseChart(controller: c),
                    const SizedBox(height: 8),
                    const _Legend(),
                  ],
                ),
              ),
              _MonthlyIncomeCard(controller: c),
              SectionHeader(
                title: tr('extraIncome'),
                action: tr('addIncome'),
                onAction: () => showIncomeDialog(context),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              ),
              _ExtraIncomeList(controller: c),
            ],
          ],
        ),
      ),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final income = c.monthIncome;
    final expense = c.totalAmount;
    final balance = c.balance;
    final maxV = income > expense ? income : expense;

    final (statusIcon, statusColor, status) = balance < 0
        ? (
            Icons.trending_down,
            expenseColor,
            tr('balanceMinus', {'amount': formatRupiah(-balance)})
          )
        : balance > 0
            ? (
                Icons.trending_up,
                incomeColor,
                tr('balanceSurplus', {'amount': formatRupiah(balance)})
              )
            : (Icons.drag_handle, p.muted, tr('balanceZero'));

    Widget bar(String label, int value, Color color) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(label,
                        style: text.bodyMedium?.copyWith(color: p.muted)),
                  ),
                  Text(
                    formatRupiah(value),
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: maxV == 0 ? 0 : value / maxV),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => LinearProgressIndicator(
                    value: v,
                    minHeight: 10,
                    color: color,
                    backgroundColor: p.glass,
                  ),
                ),
              ),
            ],
          ),
        );

    return GlassCard(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('balanceOfMonth', {'month': formatMonth(c.selectedMonth)}),
            style: text.labelLarge?.copyWith(color: p.muted),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              formatRupiah(balance),
              style: text.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: balance < 0 ? expenseColor : null,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 18, color: statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    status,
                    style: text.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          bar(tr('income'), income, incomeColor),
          bar(tr('expense'), expense, expenseColor),
          const SizedBox(height: 10),
          Text(
            income == 0
                ? tr('noIncomeSet')
                : tr('spentOfIncome',
                    {'p': (expense * 100 / income).toStringAsFixed(0)}),
            style: text.bodySmall?.copyWith(color: p.muted),
          ),
        ],
      ),
    );
  }
}

// Batang berpasangan per bulan: hijau pemasukan, merah pengeluaran.
class _IncomeExpenseChart extends StatelessWidget {
  const _IncomeExpenseChart({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final trend = controller.balanceTrend;
    final p = AppPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    final labelStyle =
        Theme.of(context).textTheme.labelSmall?.copyWith(color: p.muted);
    var maxRaw = 0;
    for (final (_, i, e) in trend) {
      if (i > maxRaw) maxRaw = i;
      if (e > maxRaw) maxRaw = e;
    }
    final maxY = niceChartMax(maxRaw);
    final last = trend.length - 1;

    return SizedBox(
      height: 200,
      child: BarChart(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            for (var x = 0; x < trend.length; x++)
              BarChartGroupData(
                x: x,
                barsSpace: 3,
                barRods: [
                  for (final (value, color) in [
                    (trend[x].$2, incomeColor),
                    (trend[x].$3, expenseColor),
                  ])
                    BarChartRodData(
                      toY: value.toDouble(),
                      // Bulan terpilih tampil penuh, bulan lain lebih pudar.
                      color: color.withValues(alpha: x == last ? 1 : 0.45),
                      width: 10,
                      borderRadius: BorderRadius.circular(3),
                    ),
                ],
              ),
          ],
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY / 2,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: p.glassBorder, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: maxY / 2,
                getTitlesWidget: (v, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(compactNumber(v), style: labelStyle),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (v, meta) {
                  final x = v.toInt();
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      DateFormat('MMM', L10n.intlLocale).format(trend[x].$1),
                      style: x == last
                          ? labelStyle?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                            )
                          : labelStyle,
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => scheme.inverseSurface,
              tooltipBorderRadius: BorderRadius.circular(12),
              getTooltipItem: (group, _, rod, rodIndex) => BarTooltipItem(
                '${rodIndex == 0 ? tr('income') : tr('expense')}\n'
                '${formatRupiah(rod.toY)}',
                TextStyle(color: scheme.onInverseSurface, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(color: AppPalette.of(context).muted);
    Widget item(Color color, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            Text(label, style: style),
          ],
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        item(incomeColor, tr('income')),
        const SizedBox(width: 16),
        item(expenseColor, tr('expense')),
      ],
    );
  }
}

class _MonthlyIncomeCard extends StatelessWidget {
  const _MonthlyIncomeCard({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final amount = controller.monthlyIncome;

    return GlassCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      radius: 20,
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 4, 12),
      onTap: () => showMonthlyIncomeDialog(context),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: incomeColor,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.event_repeat, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('monthlyIncome'),
                    style: text.labelMedium?.copyWith(color: p.muted)),
                Text(
                  formatRupiah(amount),
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: tr('monthlyIncome'),
            onPressed: () => showMonthlyIncomeDialog(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class _ExtraIncomeList extends StatelessWidget {
  const _ExtraIncomeList({required this.controller});
  final ExpenseController controller;

  Future<bool> _confirmDelete(BuildContext context, Income income) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr('deleteIncomeTitle')),
          content: Text(
            tr('deleteIncomeBody', {'amount': formatRupiah(income.amount)}),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(tr('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(tr('delete')),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final incomes = controller.incomes;

    if (incomes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            tr('noExtraIncome'),
            style: text.bodyMedium?.copyWith(color: p.muted),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final income in incomes)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Dismissible(
              key: ValueKey('income_${income.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: scheme.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsetsDirectional.only(end: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) => _confirmDelete(context, income),
              onDismissed: (_) {
                controller.deleteIncome(income.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(tr('incomeDeleted'))),
                );
              },
              child: GlassCard(
                radius: 20,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: incomeColor.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.south_west,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            income.note ?? tr('income'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            formatDate(income.date),
                            style: text.bodySmall?.copyWith(color: p.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+${formatRupiah(income.amount)}',
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: incomeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
