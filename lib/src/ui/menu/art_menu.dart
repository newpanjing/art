import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtMenu extends StatelessWidget {
  final ArtMenuEntry menuEntry;
  final Widget child;

  const ArtMenu({super.key, required this.menuEntry, required this.child});

  showMenu(BuildContext context, TapDownDetails details) {

    showContextMenu(
        context: context,
        position: details.globalPosition,
        menuEntry: menuEntry);
  }

  @override
/* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */
  /// Builds the menu widget.
  ///
  /// This widget is a [GestureDetector] which listens for secondary taps (i.e.
  /// right-clicks or long-presses on mobile devices) and shows the menu at the
  /// tap position when one occurs. The child provided to the [ArtMenu] constructor
  /// is used as the child of the [GestureDetector].
  ///
  /// The menu is displayed using the [showContextMenu] function, so it will be
  /// positioned relative to the global position of the tap.
  ///
  /// The menu is built lazily, so it will only be created when the menu is
  /// actually shown.
  ///
/* <<<<<<<<<<  8da5018f-1cb9-4020-a99d-793c17d5733f  >>>>>>>>>>> */
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        showMenu(context, details);
      },
      child: child,
    );
  }
}
