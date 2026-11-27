import 'package:expense_tracker/database/database_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter_test/flutter_test.dart';

Category _category(String name) =>
    Category(name: name, icon: 'other', colorValue: 0xFF607D8B);

void main() {
  test('urutan DB hasil migrasi mengikuti urutan tampilan', () {
    // Urutan id pada DB yang dimigrasi dari v1 ke v3 (nama setelah v6).
    const migrated = [
      'Makanan',
      'Transportasi',
      'Shopee',
      'Tagihan',
      'Hiburan',
      'Kesehatan',
      'Pendidikan',
      'Lainnya',
      'Minum',
      'Biaya Admin',
      'Top-Up',
    ];

    final sorted = DatabaseHelper.inDisplayOrder(migrated.map(_category));

    expect(sorted.map((c) => c.name), [
      'Makanan',
      'Transportasi',
      'Minum',
      'Biaya Admin',
      'Top-Up',
      'Shopee',
      'Tagihan',
      'Hiburan',
      'Kesehatan',
      'Pendidikan',
      'Lainnya',
    ]);
  });

  test('nama tidak dikenal ditaruh paling akhir sesuai urutan asal', () {
    final sorted = DatabaseHelper.inDisplayOrder(
      ['Baru 1', 'Lainnya', 'Baru 2', 'Makanan'].map(_category),
    );

    expect(
      sorted.map((c) => c.name),
      ['Makanan', 'Lainnya', 'Baru 1', 'Baru 2'],
    );
  });
}
