import 'package:flutter/material.dart';
import 'package:accounting_tracker/l10n/Strings.dart';

class LanguageNotifier extends ChangeNotifier {
  Locale _locale = const Locale("en"); // 默认

  Locale get locale => _locale;

  LanguageNotifier() {
    _loadSavedLocale();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await StringsMain.load(locale);
    notifyListeners();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await StringsMain.getSavedLocale();
    _locale = savedLocale;
    await StringsMain.load(savedLocale);
    notifyListeners();
  }
}
