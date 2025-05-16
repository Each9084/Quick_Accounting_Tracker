import 'package:flutter/material.dart';

class NoteInputBar extends StatelessWidget {
  final TextEditingController controller;

  const NoteInputBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "请在此添加备注",
          border: UnderlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        ),
      ),
    );
  }
}
