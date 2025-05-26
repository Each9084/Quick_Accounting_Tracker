import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:accounting_tracker/l10n/Strings.dart';

/// 分类模型，支持系统预设和用户自定义
class BillCategory {
  /// 多语言 key（如 "category_food"）
  final String nameKey;

  /// 分类图标
  final IconData iconData;

  /// 数据库自增主键，系统分类为 null
  final int? id;

  /// 是否为用户自定义分类
  final bool isUserDefined;

  /// 所属用户 id（系统分类为 null）
  final int? userId;

  /// 是否为收入分类（true=收入，false=支出）
  final bool isIncome;

  /// 通用构造函数（系统分类或用户分类均可）
  BillCategory(
      this.id,
      this.isUserDefined,
      this.userId, {
        required this.nameKey,
        required this.iconData,
        required this.isIncome,
      });

  /// 获取多语言名称
  String getLocalizedName() {
    return StringsMain.get(nameKey);
  }

  /// 从数据库构建对象的工厂方法（推荐用于 Mapper）
  factory BillCategory.fromEntity({
    required String nameKey,
    required IconData iconData,
    required bool isIncome,
    int? id,
    bool isUserDefined = false,
    int? userId,
  }) {
    return BillCategory(
      id,
      isUserDefined,
      userId,
      nameKey: nameKey,
      iconData: iconData,
      isIncome: isIncome,
    );
  }

  /// 系统内置分类的构造器（用于常量初始化）
  factory BillCategory.system({
    required String nameKey,
    required IconData iconData,
    required bool isIncome,
  }) {
    return BillCategory(
      null, // 系统分类无 id
      false, // 不是用户自定义
      null, // 无 userId
      nameKey: nameKey,
      iconData: iconData,
      isIncome: isIncome,
    );
  }
}
