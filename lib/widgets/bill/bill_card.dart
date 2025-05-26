import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../l10n/Strings.dart';
import '../../models/bill.dart';

// 单个卡片
class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const BillCard({
    super.key,
    required this.bill,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = bill.isIncome;
    final amountColor = isIncome ? Colors.greenAccent : Colors.deepOrangeAccent;
    return GestureDetector(

      //轻点也可以编辑
      onTap: onEdit,
      // 长按弹出编辑菜单
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("编辑帐单"),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("删除帐单"),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              )
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //左侧图标圆圈
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  bill.billCategory.iconData,
                  size: 24,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              //中间文字
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.billCategory.getLocalizedName(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (bill.note != null && bill.note!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          bill.note!,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      _formatData(bill.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isIncome ? "+" : "-"}£${bill.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    isIncome ? StringsMain.get("income") : StringsMain.get("expense"),
                    style: TextStyle(
                        color: isIncome ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatData(DateTime dt) {
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$month/$day $hour:$minute";
  }
}
