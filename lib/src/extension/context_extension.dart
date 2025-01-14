import 'package:art/src/dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  confirm({
    required String title,
    required String content,
    required Function() onConfirm,
  }) async {
    return showConfirmDialog(
        context: this, title: title, content: content, onConfirm: onConfirm);
  }

  alert(String msg) {
    showDialog(
        context: this,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("确定"))
            ],
          );
        });
  }

  back(dynamic result) {
    Navigator.of(this).pop(result);
  }
}

extension StateExtension<T extends StatefulWidget> on State<T> {
  alert(String msg) {
    context.alert(msg);
  }
}
