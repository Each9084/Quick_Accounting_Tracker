import 'package:accounting_tracker/data/dao/bill_dao.dart';
import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/db/app_database.dart';

class CacheUtil {
  /// 清除所有用户和账单数据
  static Future<void> clearAllData() async {
    final db = await AppDatabase.database;
    await db.delete("bills");
    await db.delete("users");
    // 如果你有分类表、账本表也一并清除
    // await db.delete("categories");
    // await db.delete("books");
  }
}
