import 'dart:math';

import 'package:accounting_tracker/models/billCategory.dart';
import 'package:accounting_tracker/screens/add_bill_page.dart';
import 'package:accounting_tracker/widgets/bill_card.dart';
import 'package:accounting_tracker/widgets/new_bill_input.dart';
import 'package:accounting_tracker/widgets/summary_card.dart';
import 'package:flutter/material.dart';

import '../models/bill.dart';

class BillHomePage extends StatefulWidget {
  const BillHomePage({super.key});

  @override
  State<BillHomePage> createState() => _BillHomePageState();
}

class _BillHomePageState extends State<BillHomePage> {
  final List<Bill> _bills = [];

  /*这是最初的版本,测试添加固定的内容

 void _addBill() {
    final newBill = Bill(
      id: Random().nextDouble().toString(),
      note: 'example',
      amount: 10.0,
      date: DateTime.now(),
      category: 'food',
    );

    setState(() {
      //_bills.add(newBill); 这个样子 是往下面添加的
      _bills.insert(0, newBill);
    });
  }*/

  //打开添加的dialog (废弃,我们采用进入新的页面的方式来完成)
  /* void _openAddBillDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return NewBillInput(onSubmit: (String? note, double amount,
              BillCategory billCategory, DateTime date, bool isIncome) {
            final newBill = Bill(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              amount: amount,
              note: note,
              date: date,
              billCategory: billCategory,
              isIncome: isIncome,
            );
            setState(() {
              _bills.insert(0, newBill);
            });
          });
        });
  }*/

  void _openAddBillPage() async{
    final newBill = await Navigator.of(context).push<Bill>(
      MaterialPageRoute(
        builder: (context) => AddBillPage(),
      ),
    );

    if(newBill!=null){
      setState(() {
        _bills.insert(0, newBill);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账单助手'),
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
            child: ListView.builder(
              itemCount: _bills.length,
              itemBuilder: (ctx, index) {
                final bill = _bills[index];
                //唯一的标识符，这时可以使用 ValueKey 来保持它们的状态
                return Dismissible(
                  key: ValueKey(bill.id),
                  child: BillCard(
                    bill: bill,
                    onDelete: () => _deleteBill,
                    onEdit: () {
                      // 后续可以跳转到编辑页面
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("编辑功能待实现"),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
