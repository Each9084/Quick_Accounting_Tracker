import 'package:flutter/cupertino.dart';

class BillCategoryEntity {
  final int? id;
  final String nameKey;
  final int iconCodePoint; // 存储 IconData 的 codePoint
  final String iconFontFamily; // icon 所属字体
  final bool isIncome;
  final bool isUserDefined;
  final int? userId;

  BillCategoryEntity(
      {this.id,
      required this.nameKey,
      required this.iconCodePoint,
      required this.iconFontFamily,
      required this.isIncome,
      required this.isUserDefined,
      this.userId});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_key': nameKey,
      'icon_code_point': iconCodePoint,
      'icon_font_family': iconFontFamily,
      'is_income': isIncome ? 1 : 0,
      'is_user_defined': isUserDefined ? 1 : 0,
      'user_id': userId,
    };
  }

  factory BillCategoryEntity.fromMap(Map<String, dynamic> map) {
    return BillCategoryEntity(
      id: map['id'],
      nameKey: map['name_key'],
      iconCodePoint: map['icon_code_point'],
      iconFontFamily: map['icon_font_family'],
      isIncome: map['is_income'] == 1,
      isUserDefined: map['is_user_defined'] == 1,
      userId: map['user_id'],
    );
  }

  // 提供 IconData 恢复方法
  IconData get iconData => IconData(iconCodePoint, fontFamily: iconFontFamily);

}
