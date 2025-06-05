import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:accounting_tracker/widgets/bill/swip_background.dart';
import 'package:flutter/material.dart';
import 'package:accounting_tracker/models/bill.dart';
import 'package:accounting_tracker/utils/date_helper.dart';
import 'bill_card.dart';

//单月分组展示组件每一页的内容（对应某一个月）
//负责：按天分组、展示标题、生成 Dismissible BillCard
class MonthlyBillView extends StatelessWidget {
  final List<Bill> bills;
  final Function(String) onDelete;
  final Function(Bill) onEdit;

  const MonthlyBillView({
    super.key,
    required this.bills,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    //结构为: "2025-05-26": [bill1, bill2],
    final grouped = DateHelper.groupBillsByDay(bills);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    //返回所有的键(日期字符串)为list,得到了一个包含所有日期的列表。
    //sort() 与compareTo按降序 (从大:最新 到 小:最旧)对这些日期进行排序
    //compareTo 比较两个字符串,如果 b 在字典顺序上大于 a，则返回一个正数
    // 表示 b 比 a 大，因此会被排在前面（降序排列）
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (ctx, index) {
        final dayKey = sortedKeys[index];
        final billsOfDay = grouped[dayKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                DateHelper.getLocalizedDayLabel(dayKey, context),
                style:  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark?Colors.white:Colors.black87,
                ),
              ),
            ),
            ...billsOfDay.map((bill) => Dismissible(
              key: ValueKey(bill.id),
              background: const SwipeBackground(),
              direction: DismissDirection.startToEnd,
              confirmDismiss: (direction) async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title:  Text(StringsMain.get("ask_for_confirm_delete_title")),
                    content:  Text(StringsMain.get("ask_for_confirm_delete_text")),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child:  Text(StringsMain.get("cancel")),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child:  Text(StringsMain.get("delete"), style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                return confirmed ?? false;
              },
              onDismissed: (_) => onDelete(bill.id),
              child: BillCard(
                bill: bill,
                onDelete: () => onDelete(bill.id),
                onEdit: () => onEdit(bill),
              ),
            )),
          ],
        );
      },
    );
  }
}
