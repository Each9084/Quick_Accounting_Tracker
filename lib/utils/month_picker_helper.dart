import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

class MonthPickerHelper {
  static Future<int?> pickMonthAndGetPageIndex({
    required BuildContext context,
    required DateTime initialMonth,
    required int initialPage,
  }) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: initialMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          backgroundColor: Colors.transparent,// 控制大小
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth:360,maxHeight: 500), // 或你想要的高度
              child: child!,
            ),
          ),
        );
      },
    );

    if (selected == null) return null;

    final now = DateTime.now();
    final diff = (selected.year - now.year) * 12 + (selected.month - now.month);
    return initialPage + diff;
  }
}
