import 'dart:ffi';

import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../l10n/Strings.dart';

class CustomKeyboardPro extends StatelessWidget {
  //当前是否在运算状态,"+","-"或者 就是" "的确认
  final String operator;
  final VoidCallback onDelete;
  final VoidCallback onConfirm;
  final VoidCallback onEquals;
  final VoidCallback onClear;

  //回调函数参数，负责处理数字键和小数点的点击逻辑。
  //它本身不负责逻辑，只负责通知外部你点了什么键
  // 外部的onKeyTap: (value){}里的 value就是传到外部的值
  final void Function(String) onKeyTap;

  //回调函数字段，用来响应运算符按钮（+ 或 -）点击事件。
  final void Function(String) onOperatorTap;

  const CustomKeyboardPro({
    super.key,
    required this.operator,
    required this.onDelete,
    required this.onConfirm,
    required this.onEquals,
    required this.onKeyTap,
    required this.onOperatorTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      /* height: double.infinity,
      width: double.infinity,*/
      padding: EdgeInsets.all(1),
      color: Colors.grey.shade100,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyHeight = (constraints.maxHeight - 40) / 4;
          return Table(
            columnWidths: {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
            },
            children: [
              _buildRow(["1", "2", "3", "⌫"],keyHeight),
              _buildRow(["4", "5", "6", "+"],keyHeight),
              _buildRow(["7", "8", "9", "-"],keyHeight),
              _buildLastRow(keyHeight),
            ],
          );
        },
      ),
    );
  }

  TableRow _buildRow(List<String> values, double keyHeight) {
    return TableRow(
      children: values.map((label) {
        if (label == '⌫') {
          return _buildKey(label, onDelete, isIcon: true, height: keyHeight);
        } else if (label == "+" || label == "-") {
          return _buildKey(label, () => onOperatorTap(label),
              isSelected: operator == label, height: keyHeight);
        } else {
          //// ()=>是函数的“引用”，只有点击时才执行
          // 直接写onKeyTap(label) 是函数的“调用”，会立刻执行并返回 void
          // 我们要传递的是一个“回调函数”而不是“函数调用结果”。
          return _buildKey(label, () => onKeyTap(label), height: keyHeight);
        }
      }).toList(),
    );
  }

  //最后一行特殊按钮
  TableRow _buildLastRow(double keyHeight) {
    return TableRow(
      children: [
        _buildKey(StringsMain.get("clear"), onClear,
            isClear: true, height: keyHeight),
        _buildKey("0", () => onKeyTap("0"), height: keyHeight),
        _buildKey(".", () => onKeyTap("."), height: keyHeight),
        _buildKey(
          operator == "" ? StringsMain.get("confirm") : "=",
          operator == "" ? onConfirm : onEquals,
          isConfirm: true,
          height: keyHeight,
        ),
        // 最右边空白，用来“假装合并”
      ],
    );
  }

  //按钮构建器
  Widget _buildKey(
    //{}里的是命名可选参数
    String label,
    VoidCallback onPressed, {
    bool isConfirm = false,
    bool isSelected = false,
    bool isIcon = false,
    bool isClear = false,
    required double height,
  }) {
    final backgroundColor = isConfirm
        ? Colors.blueAccent
        : isSelected
            ? Colors.blue.shade100
            : isClear
                ? Colors.redAccent
                : Colors.white;
    final foregroundColor =
        isConfirm || isSelected || isClear ? Colors.white : Colors.black87;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(1, 2),
                ),
              ]),
          alignment: Alignment.center,
          child: isIcon
              ? Icon(
                  Icons.backspace_outlined,
                  color: foregroundColor,
                )
              : Text(
                  label,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: foregroundColor),
                ),
        ),
      ),
    );
  }
}
