import 'dart:math';

import 'package:accounting_tracker/data/dao/bill_dao.dart';
import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/mapper/bill_mapper.dart';
import 'package:accounting_tracker/models/billCategory.dart';
import 'package:accounting_tracker/screens/add_bill_page.dart';
import 'package:accounting_tracker/utils/date_helper.dart';
import 'package:accounting_tracker/widgets/bill/bill_card.dart';
import 'package:accounting_tracker/widgets/bill/monthly_bill_view.dart';
import 'package:accounting_tracker/widgets/new_bill_input.dart';
import 'package:accounting_tracker/widgets/summary_card.dart';
import 'package:accounting_tracker/widgets/bill/swip_background.dart';
import 'package:flutter/material.dart';

import '../models/bill.dart';

class BillHomePage extends StatefulWidget {
  const BillHomePage({super.key});

  @override
  State<BillHomePage> createState() => _BillHomePageState();
}

class _BillHomePageState extends State<BillHomePage> {
  List<Bill> _bills = [];

  int? _activeUserId;
  bool _isLoading = true;

  DateTime _currentMonth = DateTime.now();

  //控制页面 滑动的作用
  late PageController _pageController;
  final int _initialPage = 1000;

  //根据页面 index 生成目标月份
  //pageIndex 是当前滑动到的页码
  DateTime _monthFromPageIndex(int pageIndex) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + (pageIndex - _initialPage));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _loadInitialData();
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

  //初始化,获取当前活跃用户 UserEntity,确保页面一加载就有数据可展示
  //没有活跃用户则直接返回，防止后续查询出错
  void _loadInitialData() async {
    final user = await UserDao.getActiveUser();
    if ((user == null)) {
      //TODO:跳转登录页或显示提示
      print("当前没有活跃");
      return;
    }

    //保存当前用户 ID，后续所有账单查询都基于这个 user_id 进行。
    _activeUserId = user.id;
    await _loadBillsForMonth(_currentMonth);

    setState(() {
      _isLoading = false;
    });
  }

  //查询指定月份（年 + 月）的账单记录，并更新页面状态。
  Future<void> _loadBillsForMonth(DateTime month) async {
    if (_activeUserId == null) return;
    final bills = await BillDao.getBillByMonth(
      user_id: _activeUserId!,
      year: month.year,
      month: month.month,
    );

    setState(() {
      _bills = bills.map((e) => BillMapper.toModel(e)).toList();
    });
  }

  //监听 PageView 滑动翻页事件，更新当前月份，并加载新月账单。
  void _onMonthChanged(int index) async {
    setState(() {
      _isLoading = true;
    });

    _currentMonth = _monthFromPageIndex(index);
    await _loadBillsForMonth(_currentMonth);

    setState(() {
      _isLoading = false;
    });
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
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onMonthChanged,
                    //从账单列表 _bills 中筛选出符合同一年同某个月的账单，并保存为 billsForMonth
                    itemBuilder: (context, index) {
                      final month = _monthFromPageIndex(index);
                      final billsListForMonth = _bills
                          .where((bill) =>
                              bill.date.year == month.year &&
                              bill.date.month == month.month)
                          .toList();

                      if (billsListForMonth.isEmpty) {
                        return Center(
                          child: Text(
                            "暂无账单，请点击右上角添加",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        );
                      }

                      //结构为: "2025-05-26": [bill1, bill2],
                      final grouped =
                          DateHelper.groupBillsByDay(billsListForMonth);
                      //返回所有的键(日期字符串)为list,得到了一个包含所有日期的列表。
                      //sort() 与compareTo按降序 (从大:最新 到 小:最旧)对这些日期进行排序
                      //compareTo 比较两个字符串,如果 b 在字典顺序上大于 a，则返回一个正数
                      // 表示 b 比 a 大，因此会被排在前面（降序排列）。
                      final sortedKeys = grouped.keys.toList()
                        ..sort((a, b) => b.compareTo(a));
                      //从这里开始
                      return MonthlyBillView(
                          bills: billsListForMonth,
                          onDelete: _deleteBill,
                          onEdit: (bill) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("编辑功能待实现")),
                            );
                          });
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
