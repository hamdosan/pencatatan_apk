import 'package:expense_tracker/views/widgets/formatters.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _value(String text, int cursor) => TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor),
    );

void main() {
  const formatter = ThousandsInputFormatter();

  test('groupThousands sisipkan titik tiap tiga angka', () {
    expect(groupThousands('100'), '100');
    expect(groupThousands('1000'), '1.000');
    expect(groupThousands('1234567'), '1.234.567');
  });

  test('parseThousands buang titik', () {
    expect(parseThousands('1.234.567'), 1234567);
    expect(parseThousands(''), isNull);
    expect(parseThousands(null), isNull);
  });

  test('mengetik di akhir memformat dan kursor tetap di akhir', () {
    final result =
        formatter.formatEditUpdate(_value('100', 3), _value('1000', 4));
    expect(result.text, '1.000');
    expect(result.selection.end, 5);
  });

  test('karakter selain angka dan nol di depan dibuang', () {
    expect(
      formatter.formatEditUpdate(_value('', 0), _value('a007b', 5)).text,
      '7',
    );
  });

  test('mengetik di tengah menjaga posisi kursor', () {
    final result =
        formatter.formatEditUpdate(_value('1.000', 1), _value('12.000', 2));
    expect(result.text, '12.000');
    expect(result.selection.end, 2);
  });

  test('backspace pada titik menghapus angka di kirinya', () {
    final result =
        formatter.formatEditUpdate(_value('12.000', 3), _value('12000', 2));
    expect(result.text, '1.000');
    expect(result.selection.end, 1);
  });

  test('hapus semua menghasilkan teks kosong', () {
    expect(formatter.formatEditUpdate(_value('1', 1), _value('', 0)).text, '');
  });
}
