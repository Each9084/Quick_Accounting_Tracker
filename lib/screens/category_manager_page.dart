import 'package:flutter/material.dart';
import 'package:accounting_tracker/data/dao/user_dao.dart';
import 'package:accounting_tracker/models/billCategory.dart';
import 'package:accounting_tracker/service/category_service.dart';
import 'package:accounting_tracker/l10n/Strings.dart';

import '../widgets/category/add_category_dialog.dart';

class CategoryManagerPage extends StatefulWidget {
  const CategoryManagerPage({super.key});

  @override
  State<CategoryManagerPage> createState() => _CategoryManagerPageState();
}

class _CategoryManagerPageState extends State<CategoryManagerPage> {
  List<BillCategory> _expenseCategories = [];
  List<BillCategory> _incomeCategories = [];
  bool _isLoading = true;
  int? _userId;



  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  //加载
  Future<void> _loadCategories() async {
    final user = await UserDao.getActiveUser();
    if (user == null) return;
    _userId = user.id;

    final expenses = await CategoryService.getExpenseCategories(user.id!);
    final incomes = await CategoryService.getIncomeCategories(user.id!);

    setState(() {
      _expenseCategories = expenses;
      _incomeCategories = incomes;
      _isLoading = false;
    });
  }

  //删除分类
  Future<void> _deleteCategory(BillCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text(StringsMain.get("ask_for_confirm_delete_title")),
        content: Text(StringsMain.get("ask_for_confirm_delete_category_text")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:  Text(StringsMain.get("cancel"))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:  Text(StringsMain.get("delete"), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await CategoryService.deleteUserCategory(category.id!, _userId!);
      await _loadCategories();
    }
  }

  Future<void> _showEditCategoryDialog(BillCategory category) async {
    if (_userId == null || category.id == null) return;

    showDialog(
      context: context,
      builder: (_) => AddCategoryDialog(
        initialNameKey: category.nameKey,
        initialIcon: category.iconData,
        initialIsIncome: category.isIncome,
        onConfirm: (newName, newIcon, newIsIncome) async {
          // 创建一个新对象，保留原 ID 和 userId
          final updated = BillCategory(
            category.id,
            true,
            _userId!,
            nameKey: newName,
            iconData: newIcon,
            isIncome: newIsIncome,
          );

          await CategoryService.updateUserCategory(updated);
          await _loadCategories();
        },
      ),
    );
  }

  //添加的dialog
  Future<void> _showAddCategoryDialog() async {
    if (_userId == null) return;

    showDialog(
      context: context,
      builder: (_) => AddCategoryDialog(
        onConfirm: (nameKey, icon, isIncome) async {
          await CategoryService.addUserCategory(
            nameKey: nameKey,
            iconData: icon,
            isIncome: isIncome,
            userId: _userId!,
          );
          await _loadCategories();
        },
      ),
    );
  }

  Widget _buildCategorySection(String title, List<BillCategory> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            )),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map(_buildCategoryCard).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategoryCard(BillCategory category) {
    final isSystem = !category.isUserDefined;

    return GestureDetector(
      onTap: isSystem ? null : () => _showEditCategoryDialog(category),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark?Colors.grey.shade800:Colors.white,
          border: Border.all(color: Theme.of(context).brightness == Brightness.dark?Colors.grey.shade700:Colors.grey.shade200),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark?Colors.black.withOpacity(0.15):Colors.grey.shade100,
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(category.iconData, size: 28, color: Colors.blueAccent),
            const SizedBox(height: 6),
            // 自动换行的名称
            Text(
              category.getLocalizedName(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
              // 最多行数
              maxLines: 1,
              //溢出用省略号
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            if (isSystem)
               Text(StringsMain.get("system"),
                  style: TextStyle(fontSize: 10, color: Theme.of(context).brightness == Brightness.dark?Colors.white38:Colors.grey))
            else ...[
              Text(
                StringsMain.get("custom"),
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                onPressed: () => _deleteCategory(category),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(StringsMain.get("category_management")),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategorySection(StringsMain.get("expense_category"), _expenseCategories),
                    _buildCategorySection(StringsMain.get("income_category"), _incomeCategories),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCategoryDialog,
        icon: const Icon(Icons.add),
        label:  Text(StringsMain.get("add_category")),
      ),
    );
  }
}
