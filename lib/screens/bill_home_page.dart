import 'dart:math';

import 'package:accounting_tracker/models/billCategory.dart';
import 'package:accounting_tracker/screens/add_bill_page.dart';
import 'package:accounting_tracker/utils/date_helper.dart';
import 'package:accounting_tracker/widgets/bill_card.dart';
import 'package:accounting_tracker/widgets/new_bill_input.dart';
import 'package:accounting_tracker/widgets/summary_card.dart';
import 'package:accounting_tracker/widgets/swipe/swip_background.dart';
import 'package:flutter/material.dart';

import '../models/bill.dart';

class BillHomePage extends StatefulWidget {
  const BillHomePage({super.key});

  @override
  State<BillHomePage> createState() => _BillHomePageState();
}

class _BillHomePageState extends State<BillHomePage> {
  final List<Bill> _bills = [];
  DateTime _currentMonth = DateTime.now();

  //控制页面 滑动的作用
  late PageController _pageController;
  final int _initialPage = 1000;

  //根据页面 index 生成目标月份
  //pageIndex 是当前滑动到的页码
  DateTime _monthFromPageIndex(int pageIndex) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month + (pageIndex - _initialPage));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  //添加账单页面
  void _openAddBillPage() async {
    final newBill = await Navigator.of(context).push<Bill>(
      MaterialPageRoute(
        builder: (context) => AddBillPage(),
      ),
    );

    if (newBill != null) {
      setState(() {
        _bills.insert(0, newBill);

        // 自动跳转到该账单的月份
        /*final int pageIndex = _initialPage + ((newBill.date.year - _currentMonth.year) * 12 + (newBill.date.month - _currentMonth.month));
        _pageController.jumpToPage(pageIndex);
        _currentMonth = DateTime(newBill.date.year, newBill.date.month);*/
      });
    }
  }

  //删除图标 -删除功能
  void _deleteBill(String id) {
    setState(() {
      //_bills.removeWhere((bill) => bill.id == id);
      for (int i = 0; i < _bills.length; i++) {
        if (_bills[i].id == id) {
          //removeAt 是 Dart 的 List 类自带的一个方法，
          //用来根据下标（index）删除列表中的元素。
          _bills.removeAt(i);
          break;
        }
      }
    });
  }

  //计算收入
  double _calculateIncome() {
    double total = 0.0;
    for (final bill in _bills) {
      if (bill.isIncome) {
        total += bill.amount;
      }
    }
    return total;
  }

  //计算支出用于显示在卡片右下角的支出逻辑
  //注意这里是负的 最终 = 收入(正)+支出(负),自动减了
  double _calculateExpense() {
    double total = 0.0;
    for (final bill in _bills) {
      if (!bill.isIncome) {
        total -= bill.amount;
      }
    }
    return total;
  }

  //每次切换月份，过滤出该月账单
  List<Bill> get _billsForCurrentMonth {
    return _bills
        .where((bill) =>
            bill.date.year == _currentMonth.year &&
            bill.date.month == _currentMonth.month)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateHelper.getMonthYearText(_currentMonth, context)),
        actions: [
          //右上角的添加按钮
          IconButton(
            //这里也从_addBill替换为_openAddBillDialog
            onPressed: _openAddBillPage,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      //每一个List 卡片
      body: Column(
        children: [
          SummaryCard(income: _calculateIncome(), expense: _calculateExpense()),
          //可滚动的账单
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonth = _monthFromPageIndex(index);
                });
              },
              //从账单列表 _bills 中筛选出符合同一年同某个月的账单，并保存为 billsForMonth
              itemBuilder: (context, index) {
                final month = _monthFromPageIndex(index);
                final billsListForMonth = _bills.where((bill) =>
                    bill.date.year == month.year &&
                    bill.date.month == month.month).toList();

               if (billsListForMonth.isEmpty){
                 return Center(
                   child: Text(
                     "暂无账单，请点击右上角添加",
                     style: TextStyle(color: Colors.grey, fontSize: 16),
                   ),
                 );
               }

               return  ListView.builder(
                 itemCount: billsListForMonth.length,
                 itemBuilder: (ctx, index) {
                   final bill = billsListForMonth[index];
                   //唯一的标识符，这时可以使用 ValueKey 来保持它们的状态
                   return Dismissible(
                     key: ValueKey(bill.id),
                     background: const SwipeBackground(),
                     direction: DismissDirection.startToEnd,
                     //滑动删除
                     confirmDismiss: (direction) async {
                       final confirmed = await showDialog(
                         context: context,
                         builder: (context) => AlertDialog(
                           title: Text("确认删除?"),
                           content: Text("你确定要删除这条账单吗?"),
                           actions: [
                             TextButton(
                               onPressed: () =>
                                   Navigator.of(ctx).pop(false),
                               child: Text("取消"),
                             ),
                             TextButton(
                               onPressed: () =>
                                   Navigator.of(ctx).pop(true),
                               child: Text(
                                 "删除",
                                 style: TextStyle(color: Colors.red),
                               ),
                             ),
                           ],
                         ),
                       );
                       // 是 null，就返回 false,是 null，就返回 confirmed 的值；
                       return confirmed ?? false;
                     },
                     onDismissed: (_) {
                       final deletedBill = bill;
                       _deleteBill(deletedBill.id);

                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text("已删除"),
                           action: SnackBarAction(
                             label: "撤销",
                             onPressed: () {
                               setState(() {
                                 _bills.insert(index, deletedBill);
                               });
                             },
                           ),
                         ),
                       );
                     },

                     child: AnimatedSwitcher(
                       duration: Duration(milliseconds: 300),
                       child: BillCard(
                         bill: bill,
                         //这个是Card的长按出菜单后删除
                         onDelete: () => _deleteBill(bill.id),
                         onEdit: () {
                           // 后续可以跳转到编辑页面
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                               content: Text("编辑功能待实现"),
                             ),
                           );
                         },
                       ),
                     ),
                   );
                 },
               );

              },


            ),
          ),
        ],
      ),
    );
  }
}
