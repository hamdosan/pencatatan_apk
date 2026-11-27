import 'dart:ui' show Locale;

import 'package:intl/intl.dart';

part 'strings.dart';

/// Bahasa yang didukung aplikasi. Urutan enum = urutan kolom di [_strings].
enum AppLanguage {
  id('Bahasa Indonesia', 'id', 'id_ID'),
  en('English', 'en', 'en_US'),
  ja('日本語', 'ja', 'ja_JP'),
  zh('中文', 'zh', 'zh_CN'),
  de('Deutsch', 'de', 'de_DE'),
  ru('Русский', 'ru', 'ru_RU'),
  pt('Português', 'pt', 'pt_BR'),
  ar('العربية', 'ar', 'ar');

  const AppLanguage(this.nativeName, this.code, this.intlLocale);

  /// Nama bahasa dalam bahasanya sendiri (untuk dropdown).
  final String nativeName;
  final String code;

  /// Locale untuk package intl (format tanggal).
  final String intlLocale;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) => AppLanguage.values
      .firstWhere((l) => l.code == code, orElse: () => AppLanguage.id);
}

/// Bahasa aktif. Diatur oleh LocaleController.
class L10n {
  L10n._();

  static AppLanguage _current = AppLanguage.id;
  static AppLanguage get current => _current;

  static set current(AppLanguage lang) {
    _current = lang;
    Intl.defaultLocale = lang.intlLocale;
  }

  /// Locale intl aktif, mis. 'en_US'.
  static String get intlLocale => _current.intlLocale;
}

/// Terjemahkan [key] ke bahasa aktif. Placeholder `{nama}` diganti dari [args].
/// Kunci yang tidak dikenal dikembalikan apa adanya.
String tr(String key, [Map<String, Object?> args = const {}]) {
  final row = _strings[key];
  var s = row == null ? key : row[L10n.current.index];
  args.forEach((k, v) => s = s.replaceAll('{$k}', '$v'));
  return s;
}

/// Nama kategori bawaan (tersimpan dalam bahasa Indonesia di DB) diterjemahkan;
/// kategori lain ditampilkan apa adanya.
String trCategory(String name) {
  final row = _categoryNames[name];
  return row == null ? name : row[L10n.current.index];
}

/// Untuk pengujian: semua baris harus punya terjemahan lengkap.
bool get debugStringsComplete =>
    _strings.values.every((r) => r.length == AppLanguage.values.length) &&
    _categoryNames.values.every((r) => r.length == AppLanguage.values.length);
