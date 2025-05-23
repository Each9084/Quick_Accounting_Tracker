// model <=> map 转换逻辑
//引入 Mapper 层来解耦，避免直接在 UI 操作数据库结构。
//Mapper 是用来连接数据库结构和业务逻辑结构的桥梁
//它将数据库实体 (Entity) 转换成界面/业务可用的模型 (Model)
//反之亦然

//把 BillEntity（用于数据库） 和 Bill（用于 UI 展示）解耦。
import 'package:accounting_tracker/data/dataModel/bill_entity.dart';
import 'package:accounting_tracker/models/billCategory.dart';
import 'package:flutter/cupertino.dart';

import '../../models/bill.dart';

class BillMapper {
  static Bill toModel(BillEntity billEntity) {
    return Bill(
        id: billEntity.id.toString(),
        amount: billEntity.amount,
        note: billEntity.note,
        date: DateTime.parse(billEntity.date),
        billCategory: BillCategory(
          name: billEntity.category_name,
          // Material 图标系统依赖 MaterialIcons 字体来识别 IconData。
          iconData: IconData(billEntity.category_icon_code,
              fontFamily: "MaterialIcons"),
        ),
        isIncome: billEntity.is_income);
  }

  static BillEntity toEntity(Bill billModel, {required int userId}) {
    return BillEntity(
      id: int.tryParse(billModel.id),
      user_id: userId,
      amount: billModel.amount,
      note: billModel.note ?? "",
      category_name: billModel.billCategory.name,
      category_icon_code: billModel.billCategory.iconData.codePoint,
      is_income: billModel.isIncome,
      date: billModel.date.toIso8601String(),
    );
  }
}
