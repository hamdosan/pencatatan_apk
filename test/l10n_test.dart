import 'package:expense_tracker/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('setiap teks punya terjemahan untuk semua bahasa', () {
    expect(debugStringsComplete, isTrue);
  });

  test('tr mengganti placeholder sesuai bahasa aktif', () {
    L10n.current = AppLanguage.en;
    expect(tr('nTransactions', {'n': 3}), '3 transactions');
    L10n.current = AppLanguage.id;
    expect(tr('nTransactions', {'n': 3}), '3 transaksi');
  });
}
