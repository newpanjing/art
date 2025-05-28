import 'package:art/src/dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  confirm({
    required String title,
    required String content,
    required Function() onConfirm,
    String cancelText = "Cancel",
    String confirmText = "OK",
  }) async {
    return showConfirmDialog(
        cancelText: cancelText,
        confirmText: confirmText,
        context: this, title: title, content: content, onConfirm: onConfirm);
  }

  alert(String msg,{
    String title = "Message",
    String ok = "OK",
  }) {
    showDialog(
        context: this,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(ok))
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
