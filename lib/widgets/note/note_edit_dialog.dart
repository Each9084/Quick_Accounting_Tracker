import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showNoteEditDialog({
  required BuildContext context,
  required String initialText,
}) async {
  final tempController = TextEditingController(text: initialText);

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.teal.shade600,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题和相机按钮
              Row(
                children: [
                  Text(StringsMain.get("add_note"),
                      style: TextStyle(fontSize: 18,color: Colors.deepOrange.shade100)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            StringsMain.get("ocr_not_implemented"),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(CupertinoIcons.camera_viewfinder),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 输入框区域（高度固定或最大高度）
              SizedBox(
                height: 120,
                child: TextField(
                  controller: tempController,
                  maxLines: null,
                  expands: true,
                  autofocus: true,
                  decoration:  InputDecoration(
                    hintText: StringsMain.get("enter_notes"),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child:  Text(StringsMain.get("cancel")),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(tempController.text),
                    child:  Text(StringsMain.get("save")),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
