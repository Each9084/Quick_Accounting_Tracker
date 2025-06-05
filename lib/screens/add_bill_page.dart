import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/repository/bill_repository.dart';
import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:accounting_tracker/service/category_service.dart';
import 'package:accounting_tracker/widgets/amount_input_bar.dart';
import 'package:accounting_tracker/widgets/custom_keyboard.dart';
import 'package:accounting_tracker/utils/custom_keyboard_pro.dart';
import 'package:accounting_tracker/widgets/note/note_input_bar.dart';
import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../models/billCategory.dart';

class AddBillPage extends StatefulWidget {
  //注入
  final BillRepository? repository;

  //编辑模式 复用这个addBillPage
  final Bill? billToEdit;

  const AddBillPage({super.key, this.repository, this.billToEdit});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  bool isIncome = false;

  //判断，不渲染主要内容，直到分类加载完：
  bool _isCategoryLoaded = false;

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

  //判断是初次添加 还是 之后编辑的
  bool _isFirstInput = true;

  //监听note输入文本框
  final TextEditingController _noteController = TextEditingController();

  List<BillCategory> _expenseCategories = [];

  List<BillCategory> _incomeCategories = [];

  @override
  void initState() {
    super.initState();

    if (widget.billToEdit != null) {
      final edit = widget.billToEdit!;
      isIncome = edit.isIncome;
      _selectedDate = edit.date;
      _selectedCategory = edit.billCategory;
      _inputAmount = edit.amount.toStringAsFixed(2);
      _noteController.text = edit.note ?? "";

      //清空 displayExpression 防止拼接旧内容,
      //如果不先点击清空,直接输入新的数字金额就不发生变化
      _displayExpression = "";
      _isFirstInput = true; // 标记为首次输入
    } else {
      _isFirstInput = true; // 新账单也初始化
    }

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final user = await UserDao.getActiveUser();
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              StringsMain.get("no_active_users_found"),
            ),
          ),
        );
      }
      return;
    }

    final expense = await CategoryService.getExpenseCategories(user.id!);
    final income = await CategoryService.getIncomeCategories(user.id!);

    //考虑 分类被删除完的情况
    if (widget.billToEdit == null) {
      // 在 setState 之前做初步判断，防止为空时出错
      if ((isIncome && income.isEmpty) || (!isIncome && expense.isEmpty)) {
        //mounted 是 State 类的一个 只读布尔属性，
        //表示当前的 State 是否仍然“挂载”（
        //即：是否仍然与 UI 树中的 Widget 关联）。
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(StringsMain.get("no_category_info_found"))),
          );
        }
        return;
      }
    }

    setState(() {
      _expenseCategories = expense;
      _incomeCategories = income;

      // 如果不是编辑状态，设置默认分类
      if (widget.billToEdit == null) {
        _selectedCategory =
            isIncome ? _incomeCategories.first : _expenseCategories.first;
      }
      _isCategoryLoaded = true;
    });
  }

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

  void _handleKeyTap(String value) {
    setState(() {
      // 如果是第一次 添加
      if (_isFirstInput) {
        // 清除旧值，只保留当前输入
        _inputAmount = (value == ".") ? "0." : value;
        _displayExpression = value;
        _isFirstInput = false;
        return;
      }

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
        _displayExpression =
            _displayExpression.substring(0, _displayExpression.length - 1);
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

  Future<void> _handleConfirm() async {
    final double? amount = double.tryParse(_inputAmount);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringsMain.get("need_enter_valid_amount")),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final isEditing = widget.billToEdit != null;

    //有可能是新加 也有可能是 更新(编辑)
    final Bill newBill = Bill(
      id: isEditing
          ? widget.billToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      date: _selectedDate,
      billCategory: _selectedCategory,
      isIncome: isIncome,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    try {
      final user = await UserDao.getActiveUser();

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(StringsMain.get("no_active_users_found")),
              backgroundColor: Colors.redAccent),
        );
        return;
      }

      //final repository = BillRepository(); 依赖就写死了
      //如果外部传入了一个 repository，就使用它（可用于测试、注入、Mock）
      //否则就使用默认的 BillRepository() 实例，确保功能正常
      final repository = widget.repository ?? BillRepository();
      if (isEditing) {
        await repository.updateBill(newBill, userId: user.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StringsMain.get("edit_Bill_updated")),
            backgroundColor: Colors.greenAccent,
          ),
        );
      } else {
        await repository.insertBill(newBill, userId: user.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StringsMain.get("add_Bill_saved")),
            backgroundColor: Colors.greenAccent,
          ),
        );
      }
      // 返回上一页
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${StringsMain.get("save_failed")}: $e"),
        ),
      );
    }

    //  返回新账单
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //禁止因为键盘弹出而调整布局 很关键 不然会压缩底部键盘的空间
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _isCategoryLoaded
            ? Column(
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
                                Text(
                                  StringsMain.get("expense"),
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  StringsMain.get("income"),
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: Colors.white,
                              fillColor: Colors.blueAccent,
                              color: Colors.black54,
                              constraints:
                                  BoxConstraints(minHeight: 36, minWidth: 100),
                              onPressed: (int index) {
                                setState(() {
                                  //从支出切换到 收入,默认选择第一个分类
                                  isIncome = index == 1;
                                  final newList = isIncome
                                      ? _incomeCategories
                                      : _expenseCategories;
                                  if (newList.isNotEmpty) {
                                    _selectedCategory = newList.first;
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
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "${_formatDateTime(_selectedDate)}",
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: GridView.builder(
                        itemCount:
                            (isIncome ? _incomeCategories : _expenseCategories)
                                .length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          //每一行有几个内容
                          crossAxisCount: 4,
                          //每两个行之间的间距
                          mainAxisSpacing: 10,
                          //每两个列之间的间距
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final category = (isIncome
                              ? _incomeCategories
                              : _expenseCategories)[index];

                          final isSelected = _selectedCategory.nameKey ==
                                  category.nameKey &&
                              _selectedCategory.iconData == category.iconData;
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
                                color: isSelected
                                    ? Colors.blue.shade200
                                    : Colors.white,
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
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
                                      category.getLocalizedName(),
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
                        },
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
              )
            : //加载中
            Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
