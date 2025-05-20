import 'package:art/art.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class ArtDropdownButton extends StatefulWidget {
  final WidgetBuilder builder;
  final PopoverDirection direction;
  final Widget child;

  const ArtDropdownButton(
      {super.key,
      required this.builder,
      this.direction=PopoverDirection.bottom,
      required this.child});

  @override
  State<ArtDropdownButton> createState() => _ArtDropdownButtonState();
}

class _ArtDropdownButtonState extends State<ArtDropdownButton> {
  ThemeData get theme => Theme.of(context);

  var isHover = false;
  var isPressed = false;

  bool get isDark => theme.brightness == Brightness.dark;

  _showPopover() {
    setState(() {
      isPressed = true;
    });
    showPopover(
        barrierColor: Colors.transparent,
        backgroundColor: isDark ? Color(0xff202020) : Colors.white,
        transitionDuration: 100.ms,
        transition: PopoverTransition.other,
        context: context,
        bodyBuilder: widget.builder,
        onPop: () {
          setState(() {
            isPressed = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var hoverColor = theme.hoverColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isPressed || isHover ? hoverColor : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: widget.child,
              ),
            ),
            Icon(
              CupertinoIcons.chevron_down,
              color: theme.textTheme.bodyMedium?.color,
              size: 16,
            )
          ],
        ),
      ).onTap(_showPopover),
    );
  }
}
