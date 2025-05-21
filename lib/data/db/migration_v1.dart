//定义数据库迁移文件

import 'package:sqflite/sqflite.dart';

class MigrationV1 {
  static Future<void> createTables(Database db) async {
    await db.execute("""
    CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT,
    uid TEXT UNIQUE,
    username TEXT,
    email TEXT,
    avatarUrl TEXT,
    createdAt TEXT,
    token TEXT,
    isActive INTEGER
      )
     """);

    //REAL 数据类型:用来表示带小数点的数值
    //ON DELETE CASCADE:级联删除
    //某个用户记录被删除，则 bills 表中所有关联的账单记录也会被自动删除
    await db.execute("""CREATE TABLE bills( id INTEGER PRIMARY KEY, 
        user_id TEXT, 
        amount REAL,
        note TEXT,
        date TEXT,
        category_name TEXT,
        category_icon_code INTEGER,
        is_income INTEGER,
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
        )
        """);
  }
}
