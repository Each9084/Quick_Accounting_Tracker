import 'package:flutter/material.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  bool isIncome = false;
  DateTime _selectedDate = DateTime.now();

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
                      isSelected: [isIncome, !isIncome],
                      children: [Text("收入"), Text("支出")],
                      borderRadius: BorderRadius.circular(10),
                      selectedColor: Colors.white,
                      fillColor: Colors.blueAccent,
                      color: Colors.black54,
                      constraints: BoxConstraints(minHeight: 36, minWidth: 100),
                      onPressed: (int index) {
                        setState(() {
                          if (index == 0) {
                            isIncome = true;
                          } else {
                            isIncome = false;
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
            child: Center(
              child: Text("后续:图标分类,自定义键盘等"),
            ),
          ),
        ],
      ),
    ));
  }
}
