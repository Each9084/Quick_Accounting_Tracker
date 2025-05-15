// 添加账单的对话框或表单组件
import 'package:accounting_tracker/models/billCategory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewBillInput extends StatefulWidget {
  // 回调函数字段 onSubmit,
  // 当用户填写完表单点击“确定”按钮后，把输入的内容传回给外层（即主页面），由外层决定如何处理这些数据。
  final Function(String? note, double amount, BillCategory category, DateTime date,bool isIncome)
      onSubmit;

  //你在 NewBillInput 的构造函数中要求外部传进来一个 onSubmit 函数：
  const NewBillInput({super.key, required this.onSubmit});

  @override
  State<NewBillInput> createState() => _NewBillInputState();
}

class _NewBillInputState extends State<NewBillInput> {
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = false; //默认支出

  late DateTime _selectedDate = DateTime.now();

  late BillCategory _selectedCategory;

  final List<BillCategory> _categories = [
    BillCategory(name: "food", iconData: Icons.fastfood),
    BillCategory(name: "transport", iconData: Icons.directions_bus),
    BillCategory(name: "shopping", iconData: Icons.shopping_cart),
    BillCategory(name: "other", iconData: Icons.help_outline),
  ];

  void _submit() {
    final note = _noteController.text.isEmpty ? null : _noteController.text;
    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount < 0) {
      //加入snackBar,非空或者非数字都不行
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Text("请输入有效金额"),
            ],
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
          //悬浮
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    ;

    //在 Flutter 的 State 类中，有个内置变量叫 widget
    //它指的是当前 State 对应的 StatefulWidget 实例本身。
    //所以 widget.onSubmit 表示：访问你组件外部传进来的回调函数。
    widget.onSubmit(note, amount, _selectedCategory, _selectedDate,_isIncome);
    Navigator.of(context).pop(); //关闭对话框
  }

  //创建选择器方法,日期这部分
  void _pickDateTime() async {
    //日期
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );

    if (pickedDate == null) return;

    //时间
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (pickedTime == null) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDate = newDateTime;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedCategory = _categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加账单'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _noteController,
            decoration: InputDecoration(labelText: '备注(可选)'),
          ),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: "amount"),
          ),
          DropdownButton<BillCategory>(
              value: _selectedCategory,
              //遍历映射,会对列表中每一个元素执行一次函数,生成一个新的集合
              // cat 就是这个函数的每一次传入的元素值
              items: _categories.map((cat) {
                //value的cat是设置这个选项的值，后续当用户选择时会返回这个值
                //Text是显示在上面的值
                // 所以这三个 cat 是同一个变量名，分别出现在接收 → 使用为值 → 用作显示的三个位置。
                return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(cat.iconData),
                        Text(cat.name),
                      ],
                    ));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              }),
          SwitchListTile(value: _isIncome, onChanged: (value){
            setState(() {
              _isIncome = value;
            });
          },
          title: Text("收入"),
          subtitle: Text("切换为收入/支出"),
          activeColor: Colors.green,),
          Row(
            children: [
              Expanded(
                child: Text(
                  //这是截取前 16 个字符:2025-05-13 16:20
                  "日期:${_selectedDate.toLocal().toString().substring(0, 16)}",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: _pickDateTime,
                child: Text("选择日期"),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submit,
          child: Text("confirm"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("cancel"),
        )
      ],
    );
  }
}
