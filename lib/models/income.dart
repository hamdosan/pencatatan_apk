import 'expense.dart';

// Pemasukan (gaji, top-up saldo, dll). Saldo = total pemasukan - total pengeluaran.
class Income {
  final int? id;
  final int amount;
  final DateTime date;
  final String? note;

  const Income({
    this.id,
    required this.amount,
    required this.date,
    this.note,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'amount': amount,
        'date': Expense.dateToDb(date),
        'note': note,
      };

  factory Income.fromMap(Map<String, Object?> map) => Income(
        id: map['id'] as int?,
        amount: map['amount'] as int,
        date: DateTime.parse(map['date'] as String),
        note: map['note'] as String?,
      );
}
