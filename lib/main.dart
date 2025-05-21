import 'dart:async';

import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/dataModel/user_entity.dart';
import 'package:accounting_tracker/data/db/app_database.dart';
import 'package:accounting_tracker/l10n/strings.dart';
import 'package:accounting_tracker/screens/bill_home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 国际化语言加载
  Strings.load(Locale("zh"));

  await testDatabaseConnection();

  runApp(const MyApp());
}

// 将async添加到函数中,即便没有显式的返回一个Future对象
// dart也会自动将函数的返回值类型转换为Future<T>
Future<void> testDatabaseConnection() async {
  //get获取到实例
  final db = await AppDatabase.database;
  print("✅ 数据库初始化成功，路径为：${db.path}");

  await UserDao.insertUser(
    UserEntity(
        id: 00,
        uid: "firebase-uid-abc123",
        username: "Neil",
        email: "Neil@gmail.com",
        createdAt: DateTime.now(),
        avatarUrl: null,
        token: "mock_token"),
  );

  final users = await UserDao.getAllUsers();
  print("当前用户是:${users.map((u)=>u.username).toList()}");
  print(users.toList());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistant Tracker',
      home: BillHomePage(),
    );
  }
}
