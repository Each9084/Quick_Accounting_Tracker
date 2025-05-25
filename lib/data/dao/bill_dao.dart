// Data Access Objects（数据库操作）

import 'package:accounting_tracker/data/dataModel/bill_entity.dart';
import 'package:accounting_tracker/data/db/app_database.dart';
import 'package:sqflite/sqflite.dart';

class BillDao {
  static const String tableName = "bills";

  //插入账单(返回插入的自增ID)
  static Future<int> insertBill(BillEntity bill) async {
    final db = await AppDatabase.database;

    //，使用深拷贝 map,复制一份新的map,避免原对象污染,且避免将 id 传入
    final data = Map<String, dynamic>.from(bill.toMap())..remove("id");
    //// 让 SQLite 自增
    return await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //根据id更新 为什么依旧传入BillEntity:编辑页面加载了整条 BillEntity
  //后续用它的 id 和 toMap() 构建 SQL 更新语句
  static Future<int> updateBill(BillEntity bill) async {
    final db = await AppDatabase.database;

    final data = Map<String, dynamic>.from(bill.toMap())..remove("id");

    return await db.update(
      tableName,
      data,
      where: "id=?",
      whereArgs: [bill.id],
    );


  }

  //删除指定id的账单
  static Future<int> deleteBill(int id) async {
    final db = await AppDatabase.database;
    return await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //删除数据库中所有账单 !!!!慎重!!!!
  static Future<void> clearAll() async {
    final db = await AppDatabase.database;
    await db.delete(tableName);
  }

  // 查询某个用户的所有账单
  static Future<List<BillEntity>> getBillsByUser(int user_id) async {
    final db = await AppDatabase.database;
    final result = await db.query(
      tableName,
      where: "user_id=?",
      whereArgs: [user_id],
      //最新的在前
      orderBy: "date DESC",
    );
    return result.map((e) => BillEntity.fromMap(e)).toList();
  }

  // 查询某个用户在特定月份的账单
  static Future<List<BillEntity>> getBillByMonth({
    required int user_id,
    required int year,
    required int month,
  }) async {
    final db = await AppDatabase.database;

    final monthStr = month.toString().padLeft(2, "0");
    final start = "$year-$monthStr-01";
    final endDate = DateTime(year, month + 1, 0).day.toString().padLeft(2, "0");
    final end = "$year-$monthStr-$endDate";

    final result = await db.query(
      tableName,
      where: "user_id = ? AND date BETWEEN ? AND ?",
      whereArgs: [user_id, start, end],
      orderBy: "date DESC",
    );

    return result.map((e) => BillEntity.fromMap(e)).toList();
  }

  //查询指定 ID 的账单
  static Future<BillEntity?> getBillById(int id) async {
    final db = await AppDatabase.database;

    final result = await db.query(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return BillEntity.fromMap(result.first);
    }

    return null;
  }

  /// 删除某个用户的所有账单（可用于注销）
  static Future<int> deleteAllByUser(int userId) async {
    final db = await AppDatabase.database;

    return await db.delete(
      tableName,
      where: "user_id = ?",
      whereArgs: [userId],
    );
  }


}
