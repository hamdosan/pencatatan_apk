import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import 'history_page.dart';
import 'widgets/formatters.dart';
import 'widgets/month_selector.dart' show kFirstYear;

/// Rekap pencatatan per bulan dalam satu tahun.
class RecapPage extends StatefulWidget {
  const RecapPage({super.key});

  @override
  State<RecapPage> createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  late int _year;
  late Future<List<MonthRecap>> _future;
  late ExpenseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ExpenseController>();
    _year = _controller.selectedMonth.year;
    _controller.addListener(_reload);
    _load();
  }

  @override
  void dispose() {
    _controller.removeListener(_reload);
    super.dispose();
  }

  void _load() => _future = _controller.recapOfYear(_year);

  /// Muat ulang saat data berubah (mis. setelah edit di halaman riwayat).
  void _reload() {
    if (mounted) setState(_load);
  }

  void _changeYear(int delta) => setState(() {
        _year += delta;
        _load();
      });

  Future<void> _openMonth(DateTime month) async {
    await _controller.selectMonth(month.year, month.month);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Rekap Bulanan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Tahun sebelumnya',
                  onPressed: _year <= kFirstYear ? null : () => _changeYear(-1),
                ),
                Text('$_year', style: theme.textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Tahun berikutnya',
                  onPressed: _year >= now.year ? null : () => _changeYear(1),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MonthRecap>>(
              future: _future,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('Gagal memuat rekap: ${snap.error}'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Bulan di masa depan tidak ditampilkan.
                final months = [
                  for (final r in snap.data!)
                    if (!r.month.isAfter(DateTime(now.year, now.month))) r,
                ].reversed.toList();
                final yearTotal = months.fold(0, (s, r) => s + r.total);
                final yearCount = months.fold(0, (s, r) => s + r.count);
                final maxTotal = months.fold(0, (m, r) => r.total > m ? r.total : m);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total tahun $_year',
                                style: theme.textTheme.labelLarge),
                            const SizedBox(height: 4),
                            Text(
                              formatRupiah(yearTotal),
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('$yearCount transaksi',
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final r in months)
                      _MonthRecapTile(
                        recap: r,
                        maxTotal: maxTotal,
                        onTap: r.count == 0 ? null : () => _openMonth(r.month),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthRecapTile extends StatelessWidget {
  const _MonthRecapTile({
    required this.recap,
    required this.maxTotal,
    this.onTap,
  });

  final MonthRecap recap;
  final int maxTotal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final change = recap.changePercent;
    final ratio = maxTotal == 0 ? 0.0 : recap.total / maxTotal;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(formatMonth(recap.month),
                              style: theme.textTheme.titleSmall),
                        ),
                        Text(
                          formatRupiah(recap.total),
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 6,
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recap.count == 0
                                ? 'Belum ada catatan'
                                : '${recap.count} transaksi',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        if (change != null && recap.total > 0)
                          Text(
                            '${change >= 0 ? '▲' : '▼'} '
                            '${change.abs().toStringAsFixed(0)}% vs bln lalu',
                            style: theme.textTheme.bodySmall?.copyWith(
                              // Pengeluaran naik = merah, turun = hijau.
                              color: change > 0
                                  ? scheme.error
                                  : Colors.green.shade600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: onTap == null ? scheme.outlineVariant : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
