import 'package:accounting_tracker/widgets/note/note_edit_dialog.dart';
import 'package:flutter/material.dart';

import '../../l10n/Strings.dart';

class NoteInputBar extends StatefulWidget {
  final TextEditingController controller;

  const NoteInputBar({
    super.key,
    required this.controller,
  });

  @override
  State<NoteInputBar> createState() => _NoteInputBarState();
}

class _NoteInputBarState extends State<NoteInputBar> {
  @override
  void initState() {
    super.initState();
    // 监听 controller 的内容变化
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // 主动刷新 UI
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: OutlinedButton(
        onPressed: () async {
          final result = await showNoteEditDialog(
            context: context,
            initialText: widget.controller.text,
          );
          if (result != null) {
            widget.controller.text = result;
          }
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          side: const BorderSide(color: Colors.blueGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text.isEmpty ? StringsMain.get("click_to_add_note") : text,
          style: TextStyle(
            color: text.isEmpty ? Colors.blueGrey : Colors.black87,
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
