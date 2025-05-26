import 'package:accounting_tracker/data/dataModel/bill_category_entity.dart';
import '../../models/billCategory.dart';

class BillCategoryMapper {
  // 从 Entity 转换为 UI 模型
  static BillCategory fromEntity(BillCategoryEntity entity) {
    return BillCategory.fromEntity(
      id: entity.id,
      nameKey: entity.nameKey,
      iconData: entity.iconData,
      isUserDefined: entity.isUserDefined,
      userId: entity.userId,
      isIncome: entity.isIncome,
    );
  }

  // 从 UI 模型 转换为 Entity 用于数据库存储
  static BillCategoryEntity toEntity(BillCategory category) {
    return BillCategoryEntity(
      id: category.id,
      nameKey: category.nameKey,
      iconCodePoint: category.iconData.codePoint,
      iconFontFamily: category.iconData.fontFamily ?? "MaterialIcons",
      isIncome: category.isIncome,
      isUserDefined: category.isUserDefined,
      userId: category.userId,
    );
  }
}
