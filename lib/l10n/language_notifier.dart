
import 'package:flutter/material.dart';
import 'Strings.dart';
//动态控制语言 封装语言切换逻辑
class LanguageNotifier extends ChangeNotifier {
  Locale _locale = const Locale("zh"); // 默认中文

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    StringsMain.load(locale); // 加载语言包
    notifyListeners();
  }
}
