import 'package:flutter/material.dart';

import '../models/billCategory.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  bool isIncome = false;
  DateTime _selectedDate = DateTime.now();

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
  ];

  final List<BillCategory> _incomeCategories = [
    BillCategory(name: "工资", iconData: Icons.wallet),
    BillCategory(name: "兼职", iconData: Icons.work_outline),
    BillCategory(name: "理财", iconData: Icons.savings_outlined),
    BillCategory(name: "其他", iconData: Icons.miscellaneous_services_outlined),
  ];

  //选中的分类
  late BillCategory _selectedCategory;

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
                      children: [Text("支出"), Text("收入")],
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
          const Divider(),
          Expanded(
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
        ],
      ),
    ));
  }
}
