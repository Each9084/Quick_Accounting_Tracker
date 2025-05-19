import 'package:accounting_tracker/models/bill.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateHelper {
  /// 返回当前 locale获取当前应用的 语言偏好 下的格式化字符串
  /// 如果仅显示月日，可传入 pattern: 'MM/dd'
  static String formatDate(DateTime date,
      {required BuildContext context, String pattern = "yMMMMd"}) {
    //context获取语言环境
    final locale = Localizations.localeOf(context).toString();
    final formatter = DateFormat(pattern, locale);
    return formatter.format(date);
  }

  // 判断两个日期是否在同一个月
  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  // 获取当前月份的名称，例如 May 2025，受 locale 影响(context)
  static String getMonthYearText(DateTime date, BuildContext context) {
    return formatDate(date, context: context, pattern: "MMMM yyyy");
  }

  // 仅显示日
  static String getDayOnly(DateTime date) {
    return DateFormat("dd").format(date);
  }

  //预处理账单数据（按日期分组）
  static Map<String, List<Bill>> groupBillsByDay(List<Bill> bills) {
    Map<String, List<Bill>> grouped = {};
    for (final bill in bills) {
      // 例如：'2025-05-26'
      final dateKey = DateHelper.formatDateKey(bill.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(bill);
    }

    return grouped;
  }

  static String formatDateKey(DateTime date) {
    return "${date.year}"
        "-${date.month.toString().padLeft(2, "0")}"
        "-${date.day.toString().padLeft(2, "0")}";
  }

  //dayKey:日期分组的唯一键（Key）
  static String getLocalizedDayLabel(String dayKey,BuildContext context){
    final date = DateTime.parse(dayKey);
    final locale = Localizations.localeOf(context).toString();
    //周几
    final weekday = DateFormat.E(locale).format(date);
    //看地域习惯 5/26 or 26/5
    final day = DateFormat.Md(locale).format(date);


    return "$day($weekday)";
  }
}
