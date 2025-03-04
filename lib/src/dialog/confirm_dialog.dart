import 'package:art/src/extension/context_extension.dart';
import 'package:flutter/material.dart';

showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required Function() onConfirm,
  String cancelText = "Cancel",
  String confirmText = "OK",
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              context.back(false);
            },
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () {
              onConfirm();
              context.back(true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
