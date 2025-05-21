import 'package:accounting_tracker/data/dataModel/user_entity.dart';
import 'package:accounting_tracker/data/db/app_database.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  static const String tableName = "users";

  //插入用户,若存在则替换
  static Future<void> insertUser(UserEntity user) async {
    final db = await AppDatabase.database;
    //将 UserEntity 转换为数据库表能够理解的格式。
    //如果插入的数据与已有数据冲突 则用新数据替换旧数据
    await db.insert(
      tableName,
      // 移除 id 让 SQLite 自动分配
      user.toMap(),
        //..remove("id"),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 查询指定 ID 的用户
  static Future<UserEntity?> getUserById(String id) async {
    final db = await AppDatabase.database;
    final maps = await db.query(
      tableName,
      where: "id=?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserEntity.fromMap(maps.first);
    }

    return null;
  }

  //查询所有用户
  static Future<List<UserEntity>> getAllUsers() async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => UserEntity.fromMap(map)).toList();
  }

  // 删除用户 !!! 会触发联级删除 用户的账单
  static Future<int> deleteUser(String id) async {
    final db = await AppDatabase.database;
    return await db.delete(
      tableName,
      where: "id=?",
      whereArgs: [id],
    );
  }

  // 更新用户信息
  static Future<int> updateUser(UserEntity user) async {
    final db = await AppDatabase.database;

    //创建一个副本 移除id,避免试图更新主键字段。
    final dataToUpdate = Map<String,dynamic>.from(user.toMap())..remove("id");
    return await db.update(
      tableName,
      dataToUpdate,
      where: "id=?",
      whereArgs: [user.id],
    );
  }

  //设置当前用户为活跃（只允许一个活跃用户）
  static Future<void> setActivityUser(String uid) async {
    final db = await AppDatabase.database;
    await db.transaction((txn) async {
      await txn.update(tableName, {'isActive': 0});
      await txn.update(
          tableName, {'isActive': 1}, where: 'uid = ?', whereArgs: [uid]);
    });
  }

  //获取当前活跃用户

  static Future<UserEntity?> getActiveUser() async {
    final db = await AppDatabase.database;
    final result = await db.query(tableName,where:"isActive = 1");
    if(result.isNotEmpty){
      return UserEntity.fromMap(result.first);
    }
    return null;
  }
}
