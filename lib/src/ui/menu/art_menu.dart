import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtMenu extends StatelessWidget {
  final ArtMenuEntry menuEntry;
  final Widget child;
  final ArtTrigger trigger;

  const ArtMenu(
      {super.key,
      required this.menuEntry,
      required this.child,
      this.trigger=ArtTrigger.secondaryTap});

  showMenu(BuildContext context,Offset position) {
    showContextMenu(
        context: context,
        position: position,
        menuEntry: menuEntry);
  }

  @override
  Widget build(BuildContext context) {
    if (trigger == ArtTrigger.tap) {
      return GestureDetector(
        onTapDown: (details) {
          //
          showMenu(context, details.globalPosition);
        },
        child: child,
      );
    }

    return GestureDetector(
      onSecondaryTapDown: (details) {
        showMenu(context, details.globalPosition);
      },
      child: child,
    );
  }
}
