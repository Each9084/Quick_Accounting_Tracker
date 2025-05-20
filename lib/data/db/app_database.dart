//数据库初始化

import 'package:accounting_tracker/data/db/migration_v1.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  //单例模式: _instance 变量存储了 AppDatabase 类的唯一实例
  static final AppDatabase _instance = AppDatabase._internal();

  //这个工厂构造函数用于 返回单例实例。
  //也就是说，无论你调用 AppDatabase() 多次
  //都会得到相同的实例，而不是每次都创建一个新的实例。
  factory AppDatabase() => _instance;

  //构造函数负责创建这个实例,确保只能在类的内部被调用
  //外部无法创建新的实例
  AppDatabase._internal();

  static Database? _db;

  //懒加载 getter，用来获取数据库实例
  static Future<Database> get database async {
    if (_db != null) return _db!;
    //异步初始化数据库
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    //获取 SQLite 数据库存储的路径 来自sqflite
    final dbPath = await getDatabasesPath();
    //join 将数据库存储路径与数据库文件名 accounting.db 结合起来
    //形成完整的数据库文件路径
    final path = join(dbPath, "accounting.db");

    //如果数据库不存在,创建新的表结构
    return await openDatabase(
        path, version: 1,
        //db 是 sqflite 自动提供的数据库连接对象
        onCreate: (db,version) async{
          await MigrationV1.createTables(db);
        },
      //如果未来有升级的版本,可以在这里定义onUpgrade
      onUpgrade: (db,oldVersion,newVersion)async{
        // 可插入 version >1 的迁移逻辑
      },
        //在数据库连接后、其他操作之前配置数据库
        //启用外键约束
      onConfigure: (db) async{
          await db.execute("PRAGMA foreign_keys = ON");
      }
    );
  }

}

