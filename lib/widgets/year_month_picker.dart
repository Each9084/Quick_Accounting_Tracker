import 'package:flutter/material.dart';

class YearMonthPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const YearMonthPickerDialog({super.key, required this.initialDate});

  @override
  State<YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();

  /// 静态方法，用于显示选择器并返回结果
  static Future<DateTime?> show(BuildContext context, DateTime initialDate) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => YearMonthPickerDialog(initialDate: initialDate),
    );
  }
}

class _YearMonthPickerDialogState extends State<YearMonthPickerDialog> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("选择年月"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<int>(
            value: selectedYear,
            isExpanded: true,
            items: List.generate(26, (i) => 2010 + i)
                .map((year) => DropdownMenuItem(value: year, child: Text("$year")))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => selectedYear = val);
            },
          ),
          DropdownButton<int>(
            value: selectedMonth,
            isExpanded: true,
            items: List.generate(12, (i) => i + 1)
                .map((month) => DropdownMenuItem(
              value: month,
              child: Text(MaterialLocalizations.of(context)
                  .formatMonthYear(DateTime(selectedYear, month))),
            ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => selectedMonth = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("取消"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, DateTime(selectedYear, selectedMonth)),
          child: const Text("确认"),
        ),
      ],
    );
  }
}
