import 'package:accounting_tracker/models/billCategory.dart';

//每个账单
class Bill {
  final String id; // 每笔账单唯一ID
  final String? note; // 描述，如“早餐”
  final double amount; // 金额
  final DateTime date; // 发生日期
  final BillCategory billCategory;
  final bool isIncome;// 分类，如“饮食”

  Bill(
      {required this.id,
      this.note,
      required this.amount,
      required this.date,
      required this.billCategory,
      required this.isIncome});
}
