import 'dart:async';

import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/dataModel/user_entity.dart';
import 'package:accounting_tracker/data/db/app_database.dart';
import 'package:accounting_tracker/l10n/strings.dart';
import 'package:accounting_tracker/screens/bill_home_page.dart';
import 'package:accounting_tracker/service/user_service.dart';
import 'package:accounting_tracker/test/db_test_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 国际化语言加载
  Strings.load(Locale("zh"));

  // 确保存在本地默认用户供本地使用
  await UserService.ensureLocalUserExists();

  runApp(const MyApp());
}

// 将async添加到函数中,即便没有显式的返回一个Future对象
// dart也会自动将函数的返回值类型转换为Future<T>

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistant Tracker',
      home: //BillHomePage(),
          BillHomePage(),
      /*builder: (context, child) {
        return MediaQuery(
          //// 全局取消因键盘引起的挤压
          data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
          child: child!,
        );
      },*/
    );
  }
}
