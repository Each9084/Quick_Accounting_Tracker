import 'package:accounting_tracker/constants/category_constants.dart';
import 'package:accounting_tracker/data/repository/bill_category_repository.dart';
import 'package:accounting_tracker/models/billCategory.dart';
import 'package:flutter/material.dart';

class CategoryService {
  static final BillCategoryRepository _repository = BillCategoryRepository();

  /// 获取所有“支出”分类（系统分类 + 当前用户自定义分类）
  static Future<List<BillCategory>> getExpenseCategories(int userId) async {
    final systemCategories = CategoryConstants.defaultExpenseCategories;

    final userDefined = await _repository.getCategories(
      isIncome: false,
      userId: userId,
    );

    return [...systemCategories, ...userDefined];
  }

  /// 获取所有“收入”分类（系统分类 + 当前用户自定义分类）
  static Future<List<BillCategory>> getIncomeCategories(int userId) async {
    final systemCategories = CategoryConstants.defaultIncomeCategories;

    final userDefined = await _repository.getCategories(
      isIncome: true,
      userId: userId,
    );

    return [...systemCategories, ...userDefined];
  }

  /// 添加一个用户自定义分类
  static Future<void> addUserCategory({
    required String nameKey,
    required IconData iconData,
    required bool isIncome,
    required int userId,
  }) async {
    final newCategory = BillCategory.fromEntity(
      id: null,
      isUserDefined: true,
      userId: userId,
      nameKey: nameKey,
      iconData: iconData,
      isIncome: isIncome,
    );

    await _repository.insertCategory(newCategory);
  }

  /// 删除一个用户自定义分类（仅允许删除 isUserDefined = true 的）
  static Future<void> deleteUserCategory(int categoryId, int userId) async {
    await _repository.deleteCategory(categoryId, userId);
  }

  //编辑（更新）一个用户自定义分类
  static Future<void> updateUserCategory(BillCategory category) async {
    await _repository.updateCategory(category);
  }
}
