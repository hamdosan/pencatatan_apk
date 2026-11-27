import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';

/// Minta konfirmasi sebelum menghapus pengeluaran berjudul [title].
Future<bool> confirmDeleteExpense(BuildContext context, String title) async {
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr('deleteTitle')),
          content: Text(tr('deleteBody', {'t': title})),
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
}
