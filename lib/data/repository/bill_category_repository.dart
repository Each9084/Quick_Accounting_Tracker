import 'package:accounting_tracker/data/dao/bill_category_dao.dart';
import 'package:accounting_tracker/data/db/app_database.dart';
import 'package:accounting_tracker/data/mapper/bill_category_mapper.dart';
import 'package:accounting_tracker/models/billCategory.dart';

class BillCategoryRepository {
  /// 获取 DAO 实例（通过 AppDatabase）
  Future<BillCategoryDao> _getDao() async {
    return await AppDatabase().getBillCategoryDao();
  }

  /// 获取所有分类（包括系统 + 用户分类）
  Future<List<BillCategory>> getCategories({
    required bool isIncome,
    required int userId,
  }) async {
    final dao = await _getDao();
    final entities = await dao.getCategories(
      isIncome: isIncome,
      userId: userId,
    );

    return entities.map(BillCategoryMapper.fromEntity).toList();
  }

  /// 插入自定义分类（不允许插入系统分类）
  Future<void> insertCategory(BillCategory category) async {
    if (!category.isUserDefined || category.userId == null) {
      throw Exception("只能插入用户自定义分类");
    }

    final dao = await _getDao();
    final entity = BillCategoryMapper.toEntity(category);
    await dao.insertCategory(entity);
  }

  /// 更新自定义分类（不允许更新系统分类）
  Future<void> updateCategory(BillCategory category) async {
    if (!category.isUserDefined || category.id == null || category.userId == null) {
      throw Exception("只能更新用户自定义分类");
    }

    final dao = await _getDao();
    final entity = BillCategoryMapper.toEntity(category);
    await dao.updateCategory(entity);
  }

  /// 删除分类（只允许删除用户分类）
  Future<void> deleteCategory(int id, int userId) async {
    final dao = await _getDao();
    final isSystem = await dao.isSystemCategory(id);
    if (isSystem) {
      throw Exception("系统内置分类不可删除");
    }

    await dao.deleteCategory(id, userId);
  }
}
