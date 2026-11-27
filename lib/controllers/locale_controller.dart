import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../services/reminder_service.dart';

class LocaleController extends ChangeNotifier {
  static const _key = 'app_language';

  AppLanguage get language => L10n.current;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    L10n.current = AppLanguage.fromCode(prefs.getString(_key));
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (lang == L10n.current) return;
    L10n.current = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, lang.code);
    // Teks notifikasi pengingat ikut bahasa baru.
    await ReminderService.instance.reschedule();
  }
}
