import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(String nameKey, IconData icon, bool isIncome) onConfirm;

  final String? initialNameKey;
  final IconData? initialIcon;
  final bool? initialIsIncome;

  const AddCategoryDialog(
      {super.key,
      required this.onConfirm,
      this.initialNameKey,
      this.initialIcon,
      this.initialIsIncome});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late TextEditingController _nameController = TextEditingController();
  IconData? _selectedIcon;
  bool _isIncome = false;

  // 可供选择的图标（未来可根据设计扩展）
  final List<IconData> _availableIcons = [
    Icons.fastfood,
    Icons.shopping_cart,
    Icons.directions_bus,
    Icons.savings,
    Icons.house,
    Icons.work_outline,
    Icons.money_outlined,
    Icons.spa_outlined,
    Icons.cake_outlined,
    Icons.book_outlined,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: widget.initialNameKey ?? "");
    _selectedIcon = widget.initialIcon;
    _isIncome = widget.initialIsIncome ?? false;

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.indigo.shade300,
      title: const Text("添加分类", style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 分类名称输入
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "分类名称",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 收支切换
            ToggleButtons(
              isSelected: [_isIncome == false, _isIncome == true],
              onPressed: (index) {
                setState(() => _isIncome = index == 1);
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: Colors.blueAccent,
              color: Colors.black54,
              constraints: const BoxConstraints(minHeight: 36, minWidth: 100),
              children: const [
                Text("支出"),
                Text("收入"),
              ],
            ),

            const SizedBox(height: 16),

            // 图标选择
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _availableIcons.map((icon) {
                final isSelected = icon == _selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        isSelected ? Colors.blueAccent : Colors.grey.shade200,
                    child: Icon(icon,
                        color: isSelected ? Colors.white : Colors.black87),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("取消"),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty || _selectedIcon == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("请填写完整信息")),
              );
              return;
            }

            widget.onConfirm(name, _selectedIcon!, _isIncome);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          child: const Text("确认"),
        )
      ],
    );
  }
}
