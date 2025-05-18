import 'package:flutter/material.dart';

import '../l10n/strings.dart';

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
        decoration:  InputDecoration(
          hintText: Strings.get("note_hint"),
          border: UnderlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        ),
      ),
    );
  }
}
