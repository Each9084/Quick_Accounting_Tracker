// 公共统一导出（或管理语言切换）

import 'dart:ui';

import 'package:accounting_tracker/l10n/strings_en.dart';
import 'package:accounting_tracker/l10n/strings_zh.dart';

class Strings{
  static late Map<String,String> currentLanguage;
  static void load(Locale locale){
    if(locale.languageCode == "zh"){
      currentLanguage = localizedZh;
    }else{
      currentLanguage = localizedEn;
    }
  }

  //根据 key 获取当前语言环境下的文本字符串。
  static String get(String Key){
    //如果没有找到 key，就返回 key 自身（不会报错）
    return currentLanguage[Key]??Key;
  }
}