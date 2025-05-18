import 'package:accounting_tracker/l10n/strings.dart';
import 'package:accounting_tracker/widgets/amount_input_bar.dart';
import 'package:accounting_tracker/widgets/custom_keyboard.dart';
import 'package:accounting_tracker/widgets/custom_keyboard_pro.dart';
import 'package:accounting_tracker/widgets/note_input_bar.dart';
import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../models/billCategory.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  bool isIncome = false;
  DateTime _selectedDate = DateTime.now();

  // 当前运算符：“+” 或 “-” 或 "" 空表示保存
  String _operator = '';

  // 存储第一次的金额
  double? _firstOperand;

  // 新增：完整表达式
  String _displayExpression = "";

  //选中的分类
  late BillCategory _selectedCategory;

  // 展示输入的金额文本
  String _inputAmount = "0.00";

  //限制最大长度
  int maxInputLength = 16;

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedCategory = _expenseCategories[0];
  }

  final List<BillCategory> _expenseCategories = [
    BillCategory(name: "餐饮", iconData: Icons.fastfood_outlined),
    BillCategory(name: "公交", iconData: Icons.directions_bus_filled_outlined),
    BillCategory(name: "购物", iconData: Icons.shopping_cart_outlined),
    BillCategory(name: "娱乐", iconData: Icons.sports_baseball_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
  ];

  final List<BillCategory> _incomeCategories = [
    BillCategory(name: "工资", iconData: Icons.wallet),
    BillCategory(name: "兼职", iconData: Icons.work_outline),
    BillCategory(name: "理财", iconData: Icons.savings_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
  ];

  //选择年月日
  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (pickedTime == null) return;

    final pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDate = pickedDateTime;
    });
  }

  //负责格式化 右上角,我自己定义的是只展示
  String _formatDateTime(DateTime dt) {
    final year = dt.year.toString().padLeft(2, "0");
    final month = dt.month.toString().padLeft(2, "0");
    final day = dt.day.toString().padLeft(2, "0");
    final hour = dt.hour.toString().padLeft(2, "0");
    final min = dt.minute.toString().padLeft(2, "0");
    return "$month/$day";
  }

  /*已废弃 目前是V2
  void _handleKeyTap(String value) {
    setState(() {
      //防止用户输入多个小数点（例如：12.3.4 是非法的）
      // 如果已经有一个小数点，就忽略本次输入
      if (value == "." && _inputAmount.contains(".")) return;

      //如果当前是初始状态 "0.00"，清空它，改为用户新输入的内容
      if (_inputAmount == "0.00") {
        _inputAmount = value == "." ? "0." : value;
      } else {
        //如果不是初始值，就直接把新按下的数字拼接到末尾：
        _inputAmount += value;
      }
    });
  }*/

  /*已废弃 目前是V2
  void _handleDelete() {
    setState(() {
      if (_inputAmount.length <= 1) {
        _inputAmount = "0.00";
      } else {
        //是在做 删除金额字符串的最后一个字符
        // 也就是按下键盘上的“删除键（⌫）”时发生的逻辑。
        _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        if (_inputAmount.isEmpty) {
          _inputAmount = "0.00";
        }
      }
    });
  }*/

  void _handleKeyTap(String value) {
    setState(() {
      //避免多次小数点
      if (value == "." && _inputAmount.contains(".")) return;

      //不能输入太多
      if (_inputAmount.length >= 10 ||
          _displayExpression.length >= maxInputLength) return;
      //首位为0
      if (_inputAmount == "0.00" || _inputAmount == "0") {
        _inputAmount = value == "." ? "0." : value;
      } else {
        _inputAmount += value;
      }

      // 完整表达式
      _displayExpression += value;
    });
  }

  void _handleDelete() {
    setState(() {
      if (_inputAmount.isNotEmpty) {
        _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        _displayExpression = _displayExpression.substring(0, _displayExpression.length - 1);
      }

      if (_inputAmount.isEmpty || _inputAmount == "0") {
        _inputAmount = "0.00";
        _displayExpression = "";
      }
    });
  }


  //处理运算符点击(+/-)
  void _handleOperatorTap(String op) {
    setState(() {
      // _firstOperand:存储第一次的金额
      // ?? 0.0 的意思是:如果转换失败（返回 null），就使用默认值 0.0
      //tryParse符串转换成 double 类型相较于Parse 更加安全,防止用户输入非法
      _firstOperand = double.tryParse(_inputAmount) ?? 0.0;
      _operator = op;
      _displayExpression = _inputAmount + op;
      //清空等待第二个字符
      _inputAmount = "";
    });
  }

  //处理"="
  void _handleEquals() {
    final secondOperand = double.tryParse(_inputAmount);
    if (_firstOperand == null || secondOperand == null) return;
    double result = 0;
    if (_operator == "+") {
      result = _firstOperand! + secondOperand;
    } else if (_operator == "-") {
      result = _firstOperand! - secondOperand;
    }

    setState(() {
      _inputAmount = result.toStringAsFixed(2);
      //等于之后清空
      _displayExpression = "";
      //回归到保存
      _operator = "";
      _firstOperand = null;
    });
  }

//清除按钮
  void _handleClear() {
    setState(() {
      _inputAmount = '0.00';
      _firstOperand = null;
      _operator = '';
      _displayExpression = '';
    });
  }


  void _handleConfirm() {
    final double? amount = double.tryParse(_inputAmount);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("请输入有效金额"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newBill = Bill(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        date: _selectedDate,
        billCategory: _selectedCategory,
        isIncome: isIncome,
        note: _noteController.text.isEmpty ? null : _noteController.text);

    //  返回新账单
    Navigator.of(context).pop(newBill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //返回按钮
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back),
                ),
                //收支切换
                Expanded(
                  child: Center(
                    child: ToggleButtons(
                      isSelected: [
                        !isIncome,
                        isIncome,
                      ],
                      children: [
                        Text(Strings.get("expense")),
                        Text(Strings.get("income")),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      selectedColor: Colors.white,
                      fillColor: Colors.blueAccent,
                      color: Colors.black54,
                      constraints: BoxConstraints(minHeight: 36, minWidth: 100),
                      onPressed: (int index) {
                        setState(() {
                          if (index == 0) {
                            isIncome = false;
                          } else {
                            isIncome = true;
                          }
                        });
                      },
                    ),
                  ),
                ),

                InkWell(
                  onTap: _pickDate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${_formatDateTime(_selectedDate)}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                //日期选择
              ],
            ),
          ),
          AmountInputBar(
            category: _selectedCategory,
            amountText: _displayExpression.isNotEmpty
                ? _displayExpression
                : _inputAmount,
          ),
          //const Divider(),
          SizedBox(
            height: 290,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: GridView.count(
                //每一行有几个内容
                crossAxisCount: 4,
                //每两个行之间的间距
                mainAxisSpacing: 10,
                //每两个列之间的间距
                crossAxisSpacing: 10,
                children: (isIncome ? _incomeCategories : _expenseCategories)
                    .map((category) {
                  final isSelected = _selectedCategory.name == category.name;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade200 : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.blueAccent,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          else
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(1, 2),
                            )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: AnimatedScale(
                        //选中放大1.2
                        scale: isSelected ? 1.2 : 1.0,
                        duration: Duration(milliseconds: 150),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category.iconData,
                              size: 26,
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.black87,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          NoteInputBar(controller: _noteController),

          Expanded(
            //height: MediaQuery.of(context).size.height * 0.5,
            flex: 1,
            child: CustomKeyboardPro(
              onKeyTap: _handleKeyTap,
              onDelete: _handleDelete,
              onConfirm: _handleConfirm,
              operator: _operator,
              onEquals: _handleEquals,
              onOperatorTap: _handleOperatorTap,
              onClear: _handleClear,
            ),
          ),
        ],
      ),
    ));
  }
}
