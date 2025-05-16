import 'package:accounting_tracker/models/billCategory.dart';
import 'package:flutter/material.dart';

// 添加账单页面金额输入行（带分类图标）
class AmountInputBar extends StatelessWidget {
  final BillCategory category;
  final String amountText;

  const AmountInputBar({
    super.key,
    required this.category,
    required this.amountText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            category.iconData,
            size: 28,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            category.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            '£ $amountText',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }
}
