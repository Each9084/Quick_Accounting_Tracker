import 'package:sqflite/sqflite.dart';
import '../dataModel/bill_category_entity.dart';

class BillCategoryDao {
  final Database db;

  BillCategoryDao(this.db);

  // 插入分类（用于添加用户自定义分类）
  Future<int> insertCategory(BillCategoryEntity category) async {
    return await db.insert(
      'bill_categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 获取所有分类（根据收支类型、按系统分类优先排序）
  Future<List<BillCategoryEntity>> getCategories({
    required bool isIncome,
    int? userId,
  }) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'bill_categories',
      where: 'is_income = ? AND (is_user_defined = 0 OR user_id = ?)',
      whereArgs: [isIncome ? 1 : 0, userId],
      orderBy: 'is_user_defined ASC, id ASC', // 系统分类在前
    );

    return maps.map((map) => BillCategoryEntity.fromMap(map)).toList();
  }

  // 删除用户自定义分类
  Future<int> deleteCategory(int id, int userId) async {
    return await db.delete(
      'bill_categories',
      where: 'id = ? AND is_user_defined = 1 AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  // 更新用户自定义分类
  Future<int> updateCategory(BillCategoryEntity category) async {
    return await db.update(
      'bill_categories',
      category.toMap(),
      where: 'id = ? AND is_user_defined = 1 AND user_id = ?',
      whereArgs: [category.id, category.userId],
    );
  }

  // 判断某分类是否是系统分类（用于限制删除）
  Future<bool> isSystemCategory(int id) async {
    final maps = await db.query(
      'bill_categories',
      where: 'id = ? AND is_user_defined = 0',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
