// 公共统一导出（或管理语言切换）加载多语言资源

import 'dart:ui';

import 'package:accounting_tracker/l10n/strings_en.dart';
import 'package:accounting_tracker/l10n/strings_zh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StringsMain{
  static late Map<String,String> _localizedStrings;
  static const String _localeKey = 'app_locale';

  static Future<void> load(Locale locale) async {
    switch (locale.languageCode) {
      case "en":
        _localizedStrings = localizedEn;

      case 'zh':
        _localizedStrings = localizedZh;
        break;


    }

    // 保存用户语言选择
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  //根据 key 获取当前语言环境下的文本字符串。
  static String get(String Key){
    //如果没有找到 key，就返回 key 自身（不会报错）
    return _localizedStrings[Key]??Key;
  }

  // 读取持久化的语言设置
  static Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();

    final code = prefs.getString(_localeKey);
    //没保存过就返回 null 为了适应 手机的本地语言
    if (code == null) return null;
    return Locale(code);
  }
}