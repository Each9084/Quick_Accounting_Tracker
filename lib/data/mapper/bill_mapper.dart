import 'package:accounting_tracker/data/dataModel/bill_entity.dart';
import 'package:flutter/material.dart';
import '../../models/bill.dart';
import '../../models/billCategory.dart';

class BillMapper {
  // 从数据库 Entity 转换为 UI 模型
  static Bill toModel(BillEntity entity) {
    return Bill(
      id: entity.id.toString(),
      amount: entity.amount,
      note: entity.note,
      date: DateTime.parse(entity.date),
      isIncome: entity.is_income,
      billCategory: BillCategory.fromEntity(
        id: null, // category 本身非独立表，暂不支持 ID
        nameKey: entity.category_name,
        iconData: IconData(
          entity.category_icon_code,
          fontFamily: "MaterialIcons",
        ),
        isUserDefined: false,
        userId: null,
        isIncome: entity.is_income,
      ),
    );
  }

  // 从 UI 模型转换为数据库 Entity
  static BillEntity toEntity(Bill bill, {required int userId}) {
    return BillEntity(
      id: int.tryParse(bill.id),
      user_id: userId,
      amount: bill.amount,
      note: bill.note ?? '',
      category_name: bill.billCategory.nameKey,
      category_icon_code: bill.billCategory.iconData.codePoint,
      is_income: bill.isIncome,
      date: bill.date.toIso8601String(),
    );
  }
}
