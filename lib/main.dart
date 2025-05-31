import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:accounting_tracker/screens/bill_home_page.dart';
import 'package:accounting_tracker/screens/category_manager_page.dart';
import 'package:accounting_tracker/screens/language_setting_page.dart';
import 'package:accounting_tracker/screens/setting_page.dart';
import 'package:accounting_tracker/service/user_service.dart';
import 'package:accounting_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'l10n/language_notifier.dart';
import 'theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // 确保存在本地默认用户供本地使用
  await UserService.ensureLocalUserExists();

  runApp(Phoenix(
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LanguageNotifier()), // 新增
      ],
      child: const MyApp(),
    ),
  ),);
}

// 将async添加到函数中,即便没有显式的返回一个Future对象
// dart也会自动将函数的返回值类型转换为Future<T>

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final languageNotifier = Provider.of<LanguageNotifier>(context);

    return MaterialApp(
      title: 'Assistant Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.themeMode,
      locale: languageNotifier.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      home: BillHomePage(),
      routes: {
        "/category": (context) => CategoryManagerPage(),
        "/language": (context) => const LanguageSettingPage(),
        "/settings": (context) => const SettingPage(),
      },
    );
  }
}
