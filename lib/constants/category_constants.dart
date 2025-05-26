
//这个是负责分类常量的部分,还支持自定义
import 'package:flutter/material.dart';

import '../models/billCategory.dart';

class CategoryConstants{
  static final List<BillCategory> defaultExpenseCategories = [
    BillCategory.system(nameKey: "category_food", iconData: Icons.fastfood_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_transport", iconData: Icons.directions_bus_filled_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_shopping", iconData: Icons.shopping_cart_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_entertainment", iconData: Icons.sports_baseball_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_travel", iconData: Icons.hiking_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_rent", iconData: Icons.house_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_medical", iconData: Icons.medical_services_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_utilities", iconData: Icons.water_damage_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_study", iconData: Icons.menu_book_outlined,isIncome: false),
    BillCategory.system(nameKey: "category_other_expense", iconData: Icons.monetization_on_outlined,isIncome: false),
  ];

  static final List<BillCategory> defaultIncomeCategories = [
    BillCategory.system(nameKey: "category_salary", iconData: Icons.wallet,isIncome: true),
    BillCategory.system(nameKey: "category_part_time", iconData: Icons.work_outline,isIncome: true),
    BillCategory.system(nameKey: "category_financial", iconData: Icons.savings_outlined,isIncome: true),
    BillCategory.system(nameKey: "category_bonus", iconData: Icons.money_outlined,isIncome: true),
    BillCategory.system(nameKey: "category_investment", iconData: Icons.insights_outlined,isIncome: true),
    BillCategory.system(nameKey: "category_other_income", iconData: Icons.account_balance_wallet_outlined,isIncome: true),
  ];


}