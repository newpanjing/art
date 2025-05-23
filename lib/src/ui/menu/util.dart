import 'package:art/art.dart';
import 'package:art/src/ui/menu/art_menu_widget.dart';
import 'package:flutter/material.dart';

void showContextMenu(
    {required BuildContext context,
    required Offset position,
    required ArtMenuEntry menuEntry}) {
  final OverlayState overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => ArtMenuDisplayWidget(
      menuEntry: menuEntry,
      position: position,
      onRemove: () {
        entry.remove();
      },
    ),
  );

  overlay.insert(entry);
}
