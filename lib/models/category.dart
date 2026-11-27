import '../l10n/l10n.dart';

/// Model kategori pengeluaran.
class Category {
  final int? id;
  final String name;

  /// Kunci ikon (dipetakan ke IconData di layer View).
  final String icon;

  /// Warna dalam bentuk ARGB int, mis. 0xFFFF9800.
  final int colorValue;

  /// Nama untuk ditampilkan (kategori bawaan diterjemahkan).
  String get displayName => trCategory(name);

  const Category({
    this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': colorValue,
      };

  factory Category.fromMap(Map<String, Object?> map) => Category(
        id: map['id'] as int?,
        name: map['name'] as String,
        icon: map['icon'] as String,
        colorValue: map['color'] as int,
      );
}
