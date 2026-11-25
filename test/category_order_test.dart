import 'package:expense_tracker/database/database_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter_test/flutter_test.dart';

Category _category(String name) =>
    Category(name: name, icon: 'other', colorValue: 0xFF607D8B);

void main() {
  test('urutan DB hasil migrasi mengikuti urutan tampilan', () {
    // Urutan id pada DB yang dimigrasi dari v1 ke v3.
    const migrated = [
      'Makanan',
      'Transportasi',
      'Belanja',
      'Tagihan',
      'Hiburan',
      'Kesehatan',
      'Pendidikan',
      'Lainnya',
      'QR',
      'Biaya Admin',
      'Game',
    ];

    final sorted = DatabaseHelper.inDisplayOrder(migrated.map(_category));

    expect(sorted.map((c) => c.name), [
      'Makanan',
      'Transportasi',
      'QR',
      'Biaya Admin',
      'Game',
      'Belanja',
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
