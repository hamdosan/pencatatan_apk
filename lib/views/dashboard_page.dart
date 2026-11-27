import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../services/location_service.dart';
import 'expense_form_page.dart';
import 'theme/app_theme.dart';
import 'widgets/category_icons.dart';
import 'widgets/expense_tile.dart';
import 'widgets/formatters.dart';
import 'widgets/glass.dart';
import 'widgets/month_selector.dart';
import '../l10n/l10n.dart';

const _chartAnim = Duration(milliseconds: 450);
const _chartCurve = Curves.easeOutCubic;

/// Tab "Home": ringkasan dan grafik pengeluaran.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ExpenseController>();
    if (c.error != null) return Center(child: Text(c.error!));

    return ListView(
      padding: const EdgeInsets.only(bottom: 150),
      children: [
        MonthSelector(controller: c),
        if (c.isLoading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          _Hero(controller: c),
          _StatRow(controller: c),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _TrendLineChart(controller: c),
          ),
          SectionHeader(
            title: tr('byCategory'),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          ),
          _CategoryTiles(controller: c),
          GlassCard(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: tr('byPayment')),
                const SizedBox(height: 16),
                _PaymentPieChart(controller: c),
              ],
            ),
          ),
          GlassCard(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: tr('dailyExpense')),
                const SizedBox(height: 16),
                _DailyBarChart(controller: c),
              ],
            ),
          ),
          FrostPanel(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _LocationHistory(controller: c),
          ),
        ],
      ],
    );
  }
}

/// Sapaan di kiri + kartu total bulan ini di kanan.
class _Hero extends StatefulWidget {
  const _Hero({required this.controller});
  final ExpenseController controller;

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> {
  /// Nominal total disembunyikan sampai kartu diketuk.
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final trend = c.monthlyTrend;
    final prev = trend.length >= 2 ? trend[trend.length - 2].$2 : 0;
    final change = prev == 0 ? null : (c.totalAmount - prev) * 100 / prev;
    final up = (change ?? 0) > 0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: text.bodyMedium?.copyWith(color: p.muted),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    tr('heroTitle'),
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 10,
            child: GlassCard(
              radius: 22,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              onTap: () => setState(() => _hidden = !_hidden),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.22),
                  Colors.white.withValues(alpha: 0.06),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tr('totalMonth', {
                            'month': DateFormat('MMMM', L10n.intlLocale)
                                .format(c.selectedMonth)
                          }),
                          style: text.labelMedium?.copyWith(
                            color: p.muted,
                            height: 1.3,
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) => RotationTransition(
                          turns: Tween(begin: 0.75, end: 1.0).animate(anim),
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                        child: Icon(
                          _hidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          key: ValueKey(_hidden),
                          size: 22,
                          color: p.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    layoutBuilder: (current, previous) => Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [...previous, if (current != null) current],
                    ),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.4),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: FittedBox(
                      key: ValueKey(_hidden),
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        _hidden ? 'Rp ••••••' : formatRupiah(c.totalAmount),
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (change != null)
                    Row(
                      children: [
                        Icon(
                          up ? Icons.north_east : Icons.south_east,
                          size: 14,
                          color: up
                              ? const Color(0xFFFF8A80)
                              : const Color(0xFF7EE2A8),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            tr('vsLastMonth',
                                {'p': change.abs().toStringAsFixed(0)}),
                            style: text.labelSmall?.copyWith(color: p.muted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      tr('nTransactions', {'n': c.expenses.length}),
                      style: text.labelSmall?.copyWith(color: p.muted),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return tr('morning');
    if (h < 15) return tr('afternoon');
    if (h < 19) return tr('evening');
    return tr('night');
  }
}

/// Dua kartu kecil: rata-rata per hari & jumlah transaksi.
class _StatRow extends StatelessWidget {
  const _StatRow({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final daysCounted = c.isCurrentMonth ? now.day : c.dailyTotals.length;
    final avg = daysCounted == 0 ? 0 : c.totalAmount ~/ daysCounted;

    Widget chip(IconData icon, String label, String value, {int flex = 1}) =>
        Expanded(
          flex: flex,
          child: GlassCard(
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.glass,
                    border: Border.all(color: p.glassBorder),
                  ),
                  child: Icon(icon, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: text.labelSmall?.copyWith(color: p.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          value,
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          chip(Icons.receipt_long, tr('transactions'), '${c.expenses.length}',
              flex: 4),
          const SizedBox(width: 12),
          chip(Icons.today, tr('avgPerDay'), formatRupiah(avg), flex: 6),
        ],
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({this.height = 180});
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: Center(
          child: Text(
            tr('noData'),
            style: TextStyle(color: AppPalette.of(context).muted),
          ),
        ),
      );
}

/// Label ringkas: 1.500.000 -> 1,5jt; 25.000 -> 25rb.
String _compact(num v) {
  if (v >= 1000000) {
    return tr('compactMillion',
        {'v': NumberFormat('#,##0.#', L10n.intlLocale).format(v / 1000000)});
  }
  if (v >= 1000) return tr('compactThousand', {'v': (v / 1000).round()});
  return v.toStringAsFixed(0);
}

/// Batas atas sumbu Y yang "bulat" agar garis bantu rapi.
double _niceMax(int max) {
  if (max <= 0) return 1;
  final mag = math.pow(10, (math.log(max) / math.ln10).floor()).toDouble();
  for (final step in [1, 2, 2.5, 5, 10]) {
    if (step * mag >= max) return step * mag;
  }
  return 10 * mag;
}

/// Grafik garis halus 6 bulan; titik bulan terpilih selalu disorot.
class _TrendLineChart extends StatelessWidget {
  const _TrendLineChart({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final trend = controller.monthlyTrend;
    final p = AppPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final labelStyle = text.labelSmall?.copyWith(color: p.muted);

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tr('trendMonths', {'n': ExpenseController.trendMonths}),
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (trend.every((t) => t.$2 == 0)) {
      return Column(children: [header, const _EmptyChart(height: 200)]);
    }

    final base = _niceMax(trend.map((t) => t.$2).reduce(math.max));
    final maxY = base * 1.25;
    final line = scheme.onSurface;
    final bar = LineChartBarData(
      spots: [
        for (var i = 0; i < trend.length; i++)
          FlSpot(i.toDouble(), trend[i].$2.toDouble()),
      ],
      isCurved: true,
      curveSmoothness: 0.35,
      preventCurveOverShooting: true,
      color: line,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      showingIndicators: [trend.length - 1],
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            line.withValues(alpha: 0.18),
            line.withValues(alpha: 0),
          ],
        ),
      ),
    );
    final lastIndex = trend.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        SizedBox(
          height: 220,
          child: LineChart(
            duration: _chartAnim,
            curve: _chartCurve,
            LineChartData(
              minY: 0,
              maxY: maxY,
              minX: 0,
              maxX: lastIndex.toDouble(),
              lineBarsData: [bar],
              showingTooltipIndicators: [
                ShowingTooltipIndicators([
                  LineBarSpot(bar, 0, bar.spots[lastIndex]),
                ]),
              ],
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: base / 2,
                    getTitlesWidget: (v, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(
                        v > base ? '' : _compact(v),
                        style: labelStyle,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 26,
                    getTitlesWidget: (v, meta) {
                      final i = v.toInt();
                      if (i < 0 || i >= trend.length || v != i.toDouble()) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          DateFormat('MMM', L10n.intlLocale)
                              .format(trend[i].$1),
                          style: labelStyle,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: false,
                getTouchedSpotIndicator: (barData, indexes) => [
                  for (final _ in indexes)
                    TouchedSpotIndicatorData(
                      FlLine(
                        color: line.withValues(alpha: 0.7),
                        strokeWidth: 1.5,
                        dashArray: [5, 4],
                      ),
                      FlDotData(
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                          radius: 5,
                          color: line,
                          strokeWidth: 3,
                          strokeColor: line.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                ],
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipColor: (_) => p.glass.withValues(alpha: 0.35),
                  tooltipBorder: BorderSide(color: p.glassBorder),
                  tooltipBorderRadius: BorderRadius.circular(12),
                  tooltipPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  getTooltipItems: (spots) => [
                    for (final s in spots)
                      LineTooltipItem(
                        _compactRupiah(s.y),
                        TextStyle(
                          color: line,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '\n${DateFormat('MMM y', L10n.intlLocale).format(trend[s.x.toInt()].$1)}',
                            style: TextStyle(
                              color: p.muted,
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _compactRupiah(num v) => 'Rp ${_compact(v)}';

/// Kartu-kartu kategori 2 kolom (seperti "Bills due" pada referensi).
class _CategoryTiles extends StatelessWidget {
  const _CategoryTiles({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final data = c.totalByCategory;
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;

    if (data.isEmpty) {
      return const GlassCard(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: _EmptyChart(height: 80),
      );
    }

    final total = c.totalAmount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        const gap = 12.0;
        final cols = constraints.maxWidth >= 600 ? 3 : 2;
        final w = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final entry in data)
              () {
                final cat = c.categoryOf(entry.key);
                final color = Color(cat?.colorValue ?? 0xFF607D8B);
                final ratio = total == 0 ? 0.0 : entry.value / total;
                return SizedBox(
                  width: w,
                  child: GlassCard(
                    radius: 22,
                    padding: const EdgeInsets.all(14),
                    onTap: () => _showCategoryExpenses(context, entry.key),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                iconFor(cat?.icon ?? 'other'),
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(ratio * 100).round()}%',
                              style: text.labelMedium?.copyWith(
                                color: p.muted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          cat?.displayName ?? '-',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            formatRupiah(entry.value),
                            style: text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 4,
                            color: color,
                            backgroundColor: p.glass,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }(),
          ],
        );
      }),
    );
  }
}

/// Lembar bawah berisi daftar pengeluaran bulan ini untuk satu kategori.
void _showCategoryExpenses(BuildContext context, int categoryId) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CategoryExpensesSheet(categoryId: categoryId),
  );
}

class _CategoryExpensesSheet extends StatelessWidget {
  const _CategoryExpensesSheet({required this.categoryId});
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    // watch: daftar ikut berubah bila pengeluaran diubah/dihapus dari form.
    final c = context.watch<ExpenseController>();
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final cat = c.categoryOf(categoryId);
    final color = Color(cat?.colorValue ?? 0xFF607D8B);
    final items = c.expenses.where((e) => e.categoryId == categoryId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final sum = items.fold<int>(0, (s, e) => s + e.amount);
    final total = c.totalAmount;
    final ratio = total == 0 ? 0.0 : sum / total;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, scroll) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.bgTop, p.bgBottom],
          ),
        ),
        child: CustomScrollView(
          controller: scroll,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: p.muted.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlassCard(
                      radius: 22,
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              iconFor(cat?.icon ?? 'other'),
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat?.displayName ?? '-',
                                  style: text.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  tr('categorySheetSub', {
                                    'n': items.length,
                                    'p': (ratio * 100).round()
                                  }),
                                  style: text.bodySmall?.copyWith(
                                    color: p.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatRupiah(sum),
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    tr('noCategoryExpense'),
                    style: text.bodyMedium?.copyWith(color: p.muted),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) => ExpenseTile(
                    expense: items[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ExpenseFormPage(expense: items[i]),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

const _paymentColors = {
  PaymentMethod.cash: Color(0xFF43A047),
  PaymentMethod.qr: Color(0xFF1E88E5),
  PaymentMethod.tf: Color(0xFFFB8C00),
};

const _paymentIcons = {
  PaymentMethod.cash: Icons.payments_outlined,
  PaymentMethod.qr: Icons.qr_code_2,
  PaymentMethod.tf: Icons.account_balance_outlined,
};

/// Donat porsi pengeluaran per metode pembayaran + legenda nominal.
class _PaymentPieChart extends StatelessWidget {
  const _PaymentPieChart({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final data = controller.totalByPayment;
    final total = data.values.fold(0, (a, b) => a + b);
    if (total == 0) return const _EmptyChart(height: 140);

    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: PieChart(
            duration: _chartAnim,
            curve: _chartCurve,
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 38,
              sections: [
                for (final m in PaymentMethod.values)
                  if (data[m]! > 0)
                    PieChartSectionData(
                      value: data[m]!.toDouble(),
                      color: _paymentColors[m],
                      radius: 26,
                      title: '${(data[m]! / total * 100).round()}%',
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              for (final m in PaymentMethod.values)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(_paymentIcons[m],
                          size: 18, color: _paymentColors[m]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(m.label, style: text.bodyMedium),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            formatRupiah(data[m]!),
                            style: text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: data[m] == 0 ? p.muted : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  const _DailyBarChart({required this.controller});
  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    final daily = controller.dailyTotals;
    if (daily.every((v) => v == 0)) return const _EmptyChart();

    final p = AppPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    final labelStyle =
        Theme.of(context).textTheme.labelSmall?.copyWith(color: p.muted);
    final maxY = _niceMax(daily.reduce(math.max));

    return SizedBox(
      height: 180,
      child: BarChart(
        duration: _chartAnim,
        curve: _chartCurve,
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceBetween,
          barGroups: [
            for (var i = 0; i < daily.length; i++)
              BarChartGroupData(x: i + 1, barRods: [
                BarChartRodData(
                  toY: daily[i].toDouble(),
                  color: scheme.onSurface.withValues(alpha: 0.85),
                  width: 5,
                  borderRadius: BorderRadius.circular(3),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: p.glass,
                  ),
                ),
              ]),
          ],
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: maxY / 2,
                getTitlesWidget: (v, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(_compact(v), style: labelStyle),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (v, meta) {
                  final d = v.toInt();
                  final show = d == 1 || d % 5 == 0;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(show ? '$d' : '', style: labelStyle),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => scheme.inverseSurface,
              tooltipBorderRadius: BorderRadius.circular(12),
              getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                  BarTooltipItem(
                tr('tooltipDay',
                    {'d': group.x, 'amount': formatRupiah(rod.toY)}),
                TextStyle(color: scheme.onInverseSurface, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Daftar pengeluaran bulan ini yang tercatat dengan lokasi.
/// Ditampilkan di dalam [FrostPanel] (tema terang).
class _LocationHistory extends StatefulWidget {
  const _LocationHistory({required this.controller});
  final ExpenseController controller;

  @override
  State<_LocationHistory> createState() => _LocationHistoryState();
}

class _LocationHistoryState extends State<_LocationHistory> {
  static const _collapsedCount = 5;
  bool _expanded = false;

  Future<void> _openMap(Expense e) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok =
        await LocationService.instance.openInMaps(e.latitude!, e.longitude!);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(tr('mapOpenFailed'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final items = c.locationHistory;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final canExpand = items.length > _collapsedCount;

    final header = SectionHeader(
      title: tr('locationHistory'),
      action: canExpand ? (_expanded ? tr('collapse') : tr('seeAll')) : null,
      onAction: () => setState(() => _expanded = !_expanded),
    );

    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                tr('noLocation'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
            ),
          ),
        ],
      );
    }

    final visible = _expanded ? items : items.take(_collapsedCount).toList();

    // Jumlah transaksi per tempat untuk menampilkan lokasi tersering.
    final visits = <String, int>{};
    for (final e in items) {
      final key = e.address ??
          LocationService.formatCoordinates(e.latitude!, e.longitude!);
      visits[key] = (visits[key] ?? 0) + 1;
    }
    final top = visits.entries.reduce((a, b) => b.value > a.value ? b : a);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                top.value > 1
                    ? tr('mostFrequent', {'place': top.key, 'n': top.value})
                    : tr('placesTx'),
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              tr('amount'),
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (final e in visible)
          _LocationTile(
            expense: e,
            controller: c,
            onMap: () => _openMap(e),
          ),
      ],
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.expense,
    required this.controller,
    required this.onMap,
  });

  final Expense expense;
  final ExpenseController controller;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) {
    final e = expense;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final cat = controller.categoryOf(e.categoryId);
    final color = Color(cat?.colorValue ?? 0xFF607D8B);
    final place = e.address ??
        LocationService.formatCoordinates(e.latitude!, e.longitude!);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ExpenseFormPage(expense: e)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(iconFor(cat?.icon ?? 'other'), color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat?.displayName ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.place, size: 13, color: muted),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          place,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              theme.textTheme.bodySmall?.copyWith(color: muted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatRupiah(e.amount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('d MMM', L10n.intlLocale).format(e.date),
                  style: theme.textTheme.labelSmall?.copyWith(color: muted),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.map_outlined, size: 20),
              tooltip: tr('openInMap'),
              visualDensity: VisualDensity.compact,
              onPressed: onMap,
            ),
          ],
        ),
      ),
    );
  }
}
