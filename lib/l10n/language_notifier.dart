import 'dart:ui';//目的是为了获取系统语言

import 'package:flutter/material.dart';
import 'package:accounting_tracker/l10n/Strings.dart';

//监听并控制当前语言设置
class LanguageNotifier extends ChangeNotifier {
  Locale _locale = const Locale("en"); // 默认

  Locale get locale => _locale;

  LanguageNotifier() {
    _initializeLocale();
    //废弃_loadSavedLocale();
  }

  //主动切换语言
  Future<void> setLocale(Locale locale) async{
    _locale  = locale;
    // 会自动保存
    await StringsMain.load(locale);
    notifyListeners();
  }


  Future<void> _initializeLocale() async {

    //之前有设定本地保存语言的功能 优先查找
    final saveLocale = await StringsMain.getSavedLocale();

    //加载本地保存的设置（如果存在）这块的优先级肯定是最高的
    if(saveLocale != null){
      _locale = saveLocale;
    }else{
      //这一步就是获取系统语言
      //未来如果 多语言 可以默认在此处添加,
      final systemLocale = PlatformDispatcher.instance.locale.languageCode;
      if(systemLocale == "zh"){
        _locale = const Locale("zh");
      }else{
        _locale = const Locale("en");
      }

    }

    //在这里加载 我们的 语言资源
    await StringsMain.load(_locale);
    notifyListeners();
  }



  //废弃 整合进了_initializeLocale
  /*Future<void> _loadSavedLocale() async {
    final savedLocale = await StringsMain.getSavedLocale();
    _locale = savedLocale;
    //// 加载对应语言资源
    await StringsMain.load(savedLocale);
    //// 通知 UI 更新
    notifyListeners();
  }*/
}
