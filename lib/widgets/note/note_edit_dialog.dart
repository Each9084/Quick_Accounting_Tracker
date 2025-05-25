import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showNoteEditDialog({
  required BuildContext context,
  required String initialText,
}) async {
  final tempController = TextEditingController(text: initialText);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return MediaQuery.removeViewInsets(
        removeBottom: true,// 移除底部键盘影响
        context: context,
        child: AlertDialog(
          title: Row(
            children: [
              Text("添加备注"),
              Spacer(),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("OCR 功能尚未实现")),
                  );
                },
                icon: Icon(CupertinoIcons.camera_viewfinder),
              ),
            ],
          ),
          content: TextField(
            controller: tempController,
            autofocus: true,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "请输入备注内容",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text("取消"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(tempController.text),
              child: Text("保存"),
            ),
          ],
        ),
      );
    },
  );
}
