import 'package:flutter/material.dart';
import '../data/dao/user_dao.dart';
import '../data/dao/bill_dao.dart';
import '../data/dataModel/bill_entity.dart';
import '../data/dataModel/user_entity.dart';


class DBTestPage extends StatelessWidget {
  const DBTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("数据库测试页面")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _insertTestUser,
              child: const Text("插入测试用户"),
            ),
            ElevatedButton(
              onPressed: _insertTestBill,
              child: const Text("插入测试账单"),
            ),
            ElevatedButton(
              onPressed: _queryBills,
              child: const Text("查询所有账单"),
            ),
            ElevatedButton(
              onPressed: _deleteAll,
              child: const Text("清空所有数据"),
            ),
          ],
        ),
      ),
    );
  }

  /// 插入用户
  Future<void> _insertTestUser() async {
    final user = UserEntity(
      uid: "debug_uid_001",
      username: "测试用户",
      email: "debug@test.com",
      avatarUrl: "",
      createdAt: DateTime.now(),
      token: "test-token",
      isActive: true,
    );

    final id = await UserDao.insertUser(user);
    debugPrint("插入用户成功，id = $id");
  }

  /// 插入账单（前提是至少有一个用户）
  Future<void> _insertTestBill() async {
    final users = await UserDao.getAllUsers();
    if (users.isEmpty) {
      debugPrint("插入账单失败：请先插入用户");
      return;
    }

    final userId = users.first.id!;
    final bill = BillEntity(
      user_id: userId,
      amount: 88.88,
      note: "测试账单",
      date: DateTime.now().toIso8601String(),
      category_name: "测试分类",
      category_icon_code: 0xe88a,
      is_income: false,
    );

    final id = await BillDao.insertBill(bill);
    debugPrint("插入账单成功，id = $id");
  }

  /// 查询所有账单
  Future<void> _queryBills() async {
    final users = await UserDao.getAllUsers();
    if (users.isEmpty) {
      debugPrint("无用户，无法查询账单");
      return;
    }

    final bills = await BillDao.getBillsByUser(users.first.id!);
    debugPrint("共查询到账单 ${bills.length} 条");
    for (var bill in bills) {
      debugPrint("金额：${bill.amount}，备注：${bill.note}，日期：${bill.date}");
    }
  }

  /// 清空所有数据
  Future<void> _deleteAll() async {
    await BillDao.clearAll();
    await UserDao.clearAll();
    debugPrint("所有数据已清空");
  }
}
