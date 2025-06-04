import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/data/repository/bill_repository.dart';
import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/bill.dart';
import 'add_bill_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final BillRepository _billRepository = BillRepository();

  List<Bill> _result = [];
  bool _isLoading = false;

  void _onSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final user = await UserDao.getActiveUser();
    if (user == null) return;

    final allBills = await _billRepository.getAllBillsByUser(user.id!);
    final matched = allBills
        .where((bill) =>
        (bill.note ?? "").toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _result = matched;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd HH:mm").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(StringsMain.get("search_note")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 搜索框
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _controller,
                onSubmitted: _onSearch,
                style: TextStyle(
                  // 用户输入文字颜色
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                decoration: InputDecoration(
                  hintText: StringsMain.get("input_note_key_word"),
                  hintStyle: TextStyle(
                    // 提示文字颜色
                    color: Theme.of(context).hintColor,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () => _onSearch(_controller.text),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]  // 深色模式用深灰背景
                      : Colors.grey[100], // 浅色模式用浅灰背景,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 加载状态
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            // 无结果状态
            else if (_result.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(StringsMain.get("no_matched_bill"), style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            // 结果列表
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _result.length,
                  itemBuilder: (context, index) {
                    final bill = _result[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        onTap: () async {
                          // 跳转到编辑页面
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddBillPage(
                                billToEdit: bill,
                                repository: _billRepository,
                              ),
                            ),
                          );

                          // 重新搜索（刷新结果）
                          _onSearch(_controller.text);
                        },
                        leading: CircleAvatar(
                          backgroundColor: bill.isIncome ? Colors.green[50] : Colors.red[50],
                          child: Icon(
                            bill.isIncome ? Icons.trending_up : Icons.trending_down,
                            color: bill.isIncome ? Colors.green : Colors.redAccent,
                          ),
                        ),
                        title: Text(
                          bill.note?.isNotEmpty == true ? bill.note! : "无备注",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _formatDate(bill.date),
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          "${bill.isIncome ? '+' : '-'}${bill.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: bill.isIncome ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ),
                    );
                  }
                  ,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
