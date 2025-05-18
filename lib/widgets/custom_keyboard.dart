import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  // 等价于final void Function() onDelete;无参数、无返回值的回调函数。
  // 每点击一个键盘键（比如 "5"）
  final void Function(String) onKeyTap;

  // 点了“⌫ 删除”
  final VoidCallback onDelete;

  // 用户点了“确定”
  final VoidCallback onConfirm;

  const CustomKeyboard({
    super.key,
    required this.onKeyTap,
    required this.onDelete,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final keyBoards = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      ".",
      "0",
      "⌫",
    ];

    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.grey.shade300,
      child: GridView.builder(
        itemCount: keyBoards.length + 1, //多一个确认键
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // 宽高比：宽 / 高
          childAspectRatio: 2.2,
          // 每列之间的间距
          crossAxisSpacing: 10,
          // 每行之间的间距
          mainAxisSpacing: 10,
        ),
        // 禁止滑动
        physics: const NeverScrollableScrollPhysics(),
        //类似于for循环,顺序很重要,如果提前渲染就会导致后面是dead code
        itemBuilder: (context, index) {
          if (index == keyBoards.length) {
            return _buildKey("确定", onConfirm, isConfirm: true);
          }

          final keyBoard = keyBoards[index];

          if(keyBoard == '⌫'){
            return _buildKey(keyBoard, onDelete);
          }

          return _buildKey(keyBoard, ()=>onKeyTap(keyBoard));
        },
      ),
    );
  }
  //封装装一个「按键」的样式与点击逻辑
  // 避免在 GridView.builder 中重复写大量冗长代码。

  //label显示在按键上的文字
  Widget _buildKey(String label, VoidCallback onPressed,
      {bool isConfirm = false}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isConfirm ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isConfirm ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
