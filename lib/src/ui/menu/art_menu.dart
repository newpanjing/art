import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtMenu extends StatelessWidget {
  final ArtMenuEntry menuEntry;

  const ArtMenu({super.key, required this.menuEntry});

  showMenu(BuildContext context, TapDownDetails details) {
    showContextMenu(
        context: context,
        position: details.localPosition,
        menuEntry: menuEntry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onSecondaryTapDown: (details) {
      showMenu(context, details);
    });
  }
}
