import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../services/location_service.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/delete_dialog.dart';
import 'widgets/formatters.dart';
import 'widgets/glass.dart';
import '../l10n/l10n.dart';

/// Form tambah / ubah pengeluaran. [expense] null = mode tambah.
class ExpenseFormPage extends StatefulWidget {
  const ExpenseFormPage({super.key, this.expense});
  final Expense? expense;

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;
  int? _categoryId;
  PaymentMethod _payment = PaymentMethod.cash;
  late DateTime _date;
  bool _saving = false;
  double? _lat;
  double? _lng;
  String? _address;
  bool _locating = false;

  bool get _isEdit => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _amountCtrl = TextEditingController(
      text: e == null ? '' : groupThousands(e.amount.toString()),
    );
    _noteCtrl = TextEditingController(text: e?.note ?? '');
    _categoryId = e?.categoryId;
    _payment = e?.paymentMethod ?? PaymentMethod.cash;
    _date = e?.date ?? DateTime.now();
    _lat = e?.latitude;
    _lng = e?.longitude;
    _address = e?.address;
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

  Future<void> _pickLocation() async {
    setState(() => _locating = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final loc = await LocationService.instance.getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _lat = loc.latitude;
        _lng = loc.longitude;
        _address = loc.address;
      });
    } on LocationException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(tr('locationFailed', {'e': e}))),
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _clearLocation() => setState(() {
        _lat = null;
        _lng = null;
        _address = null;
      });

  Widget _buildLocationField(BuildContext context) {
    final hasLocation = _lat != null && _lng != null;
    final theme = Theme.of(context);
    return InputDecorator(
      decoration: InputDecoration(
        labelText: tr('locationOptional'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasLocation) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.place, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_address ?? tr('addressUnknown')),
                      Text(
                        LocationService.formatCoordinates(_lat!, _lng!),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _locating || _saving ? null : _pickLocation,
                icon: _locating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(_locating
                    ? tr('locating')
                    : hasLocation
                        ? tr('updateLocation')
                        : tr('getLocation')),
              ),
              if (hasLocation) ...[
                TextButton.icon(
                  onPressed: () =>
                      LocationService.instance.openInMaps(_lat!, _lng!),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(tr('map')),
                ),
                TextButton.icon(
                  onPressed: _locating ? null : _clearLocation,
                  icon: const Icon(Icons.close),
                  label: Text(tr('delete')),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final controller = context.read<ExpenseController>();
    final note = _noteCtrl.text.trim();
    // Judul tidak lagi diinput/ditampilkan: isi dengan nama kategori.
    final title =
        controller.categories.firstWhere((c) => c.id == _categoryId).name;
    final expense = Expense(
      id: widget.expense?.id,
      title: title,
      amount: parseThousands(_amountCtrl.text)!,
      categoryId: _categoryId!,
      date: _date,
      note: note.isEmpty ? null : note,
      latitude: _lat,
      longitude: _lng,
      address: _lat == null ? null : _address,
      paymentMethod: _payment,
    );

    if (_isEdit) {
      await controller.updateExpense(expense);
    } else {
      await controller.addExpense(expense);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final expense = widget.expense!;
    final confirmed = await confirmDeleteExpense(
        context,
        context
                .read<ExpenseController>()
                .categoryOf(expense.categoryId)
                ?.displayName ??
            tr('expense'));
    if (!confirmed || !mounted) return;
    setState(() => _saving = true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await context.read<ExpenseController>().deleteExpense(expense.id!);
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(content: Text(tr('expenseDeleted'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<ExpenseController>().categories;

    return AppBackground(
        ambient: true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(_isEdit ? tr('editExpense') : tr('addExpense')),
            actions: [
              if (_isEdit)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: tr('delete'),
                  onPressed: _saving ? null : _delete,
                ),
            ],
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CategoryDropdown(
                    categories: categories,
                    value: _categoryId,
                    onChanged: (v) => setState(() => _categoryId = v),
                    validator: (v) => v == null ? tr('chooseCategory') : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [ThousandsInputFormatter()],
                    decoration: InputDecoration(
                      labelText: tr('amount'),
                      prefixText: 'Rp ',
                    ),
                    validator: (v) {
                      final n = parseThousands(v);
                      if (n == null || n <= 0) {
                        return tr('amountInvalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputDecorator(
                    decoration: InputDecoration(labelText: tr('payment')),
                    child: SegmentedButton<PaymentMethod>(
                      segments: const [
                        ButtonSegment(
                            value: PaymentMethod.cash,
                            label: Text('Cash'),
                            icon: Icon(Icons.payments_outlined)),
                        ButtonSegment(
                            value: PaymentMethod.qr,
                            label: Text('QR'),
                            icon: Icon(Icons.qr_code_2)),
                        ButtonSegment(
                            value: PaymentMethod.tf,
                            label: Text('TF'),
                            icon: Icon(Icons.account_balance_outlined)),
                      ],
                      selected: {_payment},
                      showSelectedIcon: false,
                      onSelectionChanged: (s) =>
                          setState(() => _payment = s.first),
                    ),
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
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: tr('noteOptional'),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLocationField(context),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.save),
                    label: Text(_isEdit ? tr('saveChanges') : tr('save')),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
