import 'dart:math';

import 'package:accounting_tracker/data/dao/bill_dao.dart';
import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/mapper/bill_mapper.dart';
import 'package:accounting_tracker/data/repository/bill_repository.dart';
import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:accounting_tracker/models/billCategory.dart';
import 'package:accounting_tracker/screens/add_bill_page.dart';
import 'package:accounting_tracker/screens/search_page.dart';
import 'package:accounting_tracker/utils/date_helper.dart';
import 'package:accounting_tracker/widgets/bill/bill_card.dart';
import 'package:accounting_tracker/widgets/bill/monthly_bill_view.dart';
import 'package:accounting_tracker/widgets/summary_card.dart';
import 'package:accounting_tracker/widgets/bill/swip_background.dart';
import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../utils/month_picker_helper.dart';
import '../widgets/drawer/app_drawer.dart';

class BillHomePage extends StatefulWidget {
  final BillRepository? billRepository;

  const BillHomePage({super.key, this.billRepository});

  @override
  State<BillHomePage> createState() => _BillHomePageState();
}

class _BillHomePageState extends State<BillHomePage> {
  late final BillRepository _billRepository;

  // 该文缓存 未来拉取一次以后就不用重复拉取了
  Map<String, List<Bill>> _billsByMonth = {};

  int? _activeUserId;
  bool _isLoading = true;

  //每页通过 pageIndex 推算当前月份
  //废弃 DateTime _currentMonth = DateTime.now();

  //控制页面 滑动的作用
  late PageController _pageController;
  final int _initialPage = 1000;

  //变量保存当前页码
  int _currentPageIndex = 1000; // 初始页码，和 initialPage 一致

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
    _billRepository = widget.billRepository ?? BillRepository();
    _loadInitialData();
  }

  //添加账单页面
  void _openAddBillPage() async {
    final newBill = await Navigator.of(context).push<Bill>(
      MaterialPageRoute(
        //传递依赖 把这一个已经创建好的 Repository 实例“注入”给了 AddBillPage
        //它不再自己创建 repository，而是依赖外部传入,所以调用它时就要显式地传入
        builder: (context) => AddBillPage(
          repository: _billRepository,
        ),
      ),
    );

    //拉取 最新的
    await _loadBillsForMonth(_getCurrentAppBarMonth(),forceReload: true);
  }

  //删除图标 -删除功能
  void _deleteBill(String billId) async {
    //是的 我的model是String 数据库是int 但无所谓 这不就是解耦的意义么
    final parsedId = int.tryParse(billId);

    if (parsedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringsMain.get("Invalid_billing_ID")),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final deleted = await _billRepository.deleteBill(parsedId);
      if (deleted > 0) {
        await _loadBillsForMonth(_getCurrentAppBarMonth(),forceReload: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StringsMain.get("Deleted_successfully")),
            backgroundColor: Colors.greenAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StringsMain.get("Failed_to_delete_bill")),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringsMain.get("Deleted_fail_error") + ":{$e}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  //每次切换月份，过滤出该月账单 获取当前月份的账单
  List<Bill> _getBillsForMonth(DateTime month) {
    final key = "${month.year}-${month.month}";
    return _billsByMonth[key] ?? [];
  }

  //计算支出用于显示在卡片右下角的支出逻辑
  //注意这里是负的 最终 = 收入(正)+支出(负),自动减了

  //初始化,获取当前活跃用户 UserEntity,确保页面一加载就有数据可展示
  //没有活跃用户则直接返回，防止后续查询出错
  void _loadInitialData() async {
    final user = await UserDao.getActiveUser();
    if ((user == null)) {
      //TODO:跳转登录页或显示提示
      print(Text(StringsMain.get("status_not_inactive"),),);
      return;
    }

    //保存当前用户 ID，后续所有账单查询都基于这个 user_id 进行。
    _activeUserId = user.id;
    //使用 index 推算
    await _loadBillsForMonth(_monthFromPageIndex(_initialPage));

    setState(() {
      _isLoading = false;
    });
  }

  //查询指定月份（年 + 月）的账单记录，并更新页面状态。
  //只拉取一次 增加forceReload,在每次添加/编辑完 强制更新缓存
  Future<void> _loadBillsForMonth(DateTime month,{bool forceReload = false}) async {
    if (_activeUserId == null) return;

    final key = "${month.year}-${month.month}";
    // 已缓存，跳过加载
    if (!forceReload &&_billsByMonth.containsKey(key)) return;

    final bills = await _billRepository.getBillsByMonth(
      userId: _activeUserId!,
      year: month.year,
      month: month.month,
    );

    setState(() {
      _billsByMonth[key] = bills;
    });
  }

  //只拉取数据，不再更新任何 UI 状态
  void _onMonthChanged(int index) async {

    //更新状态 滑动顶部需要实时显示当前的日期
    _currentPageIndex = index;
    final month = _monthFromPageIndex(index);
    await _loadBillsForMonth(month);
    //刷新 AppBar 顶部日期
    setState(() {});
  }

  //显示在AppBar的日期
  DateTime _getCurrentAppBarMonth() {
    if (_pageController.hasClients) {
      return _monthFromPageIndex(_currentPageIndex);
    }
    return _monthFromPageIndex(_initialPage);
  }


  //顶部点击日期 选择后跳转
  Future<void> _pickMonthAndJump() async {
    final targetIndex = await MonthPickerHelper.pickMonthAndGetPageIndex(
      context: context,
      initialMonth: _getCurrentAppBarMonth(),
      initialPage: _initialPage,
    );

    if (targetIndex != null) {
      final selectedMonth = _monthFromPageIndex(targetIndex);
      _pageController.jumpToPage(targetIndex);
      await _loadBillsForMonth(selectedMonth, forceReload: true);
      setState(() {
        _currentPageIndex = targetIndex;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddBillPage,
        backgroundColor: Colors.indigo.shade900,
        child: const Icon(Icons.add, color: Colors.yellow),
      ),
      drawer: const AppDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.indigo.shade800,
          elevation: 1.5,
          // 展示菜单图标
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 左侧头像
                Builder(
                    builder: (context) => InkWell(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          borderRadius: BorderRadius.circular(20),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            radius: 20,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        )),
                const SizedBox(width: 12),
                // 紧贴头像的日期文本
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello!",
                      style: TextStyle(fontSize: 13, color: Colors.indigo.shade100,),
                    ),
                    InkWell(
                      onTap: _pickMonthAndJump,
                      child: Row(
                        children: [
                          Text(
                            DateHelper.getMonthYearText(_getCurrentAppBarMonth(), context),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Icon(Icons.arrow_drop_down_outlined,color: Colors.white,),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
              icon: const Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),
      ),
      //每一个List 卡片
      body: Column(
        children: [
          //可滚动的账单
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onMonthChanged,
                    itemBuilder: (context, index) {
                      final month = _monthFromPageIndex(index);
                      final billsListForMonth = _getBillsForMonth(month);

                      return Column(
                        children: [
                          SummaryCard(
                            income: billsListForMonth
                                .where((b) => b.isIncome)
                                .fold(0.0, (sum, b) => sum + b.amount),
                            expense: billsListForMonth
                                .where((b) => !b.isIncome)
                                .fold(0.0, (sum, b) => sum - b.amount),
                          ),
                          Expanded(
                            child: billsListForMonth.isEmpty
                                ?  Center(
                                    child: Text(
                                      StringsMain.get("no_bill_reminder"),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16,),
                                    ),
                                  )
                                : MonthlyBillView(
                                    bills: billsListForMonth,
                                    onDelete: _deleteBill,
                                    onEdit: (bill) async {
                                      //edit的功能实现 比较复杂
                                      // 1.从 BillHomePage 的 MonthlyBillView 中触发编辑
                                      // 2.AddBillPage 接收到 billToEdit，并进入编辑模式
                                      // 3.在 initState() 中预填内容
                                      // 4.是在 _handleConfirm() 中判断是否为编辑模式，并调用更新接口
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AddBillPage(
                                            repository: _billRepository,
                                            // 在这里传入要编辑的账单
                                            billToEdit: bill,
                                          ),
                                        ),
                                      );
                                      //编辑后刷新
                                      await _loadBillsForMonth(month,forceReload: true);
                                    },
                                  ),
                          )
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
