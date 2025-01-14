import 'package:flutter/material.dart';

class ArtButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const ArtButton({super.key, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          //圆角
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        ),
        onPressed: onPressed,
        child: child);
  }
}
