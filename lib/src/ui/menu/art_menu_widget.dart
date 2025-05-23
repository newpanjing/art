import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtMenuDisplayWidget extends StatefulWidget {
  final ArtMenuEntry menuEntry;
  final Offset position;
  final VoidCallback onRemove;

  const ArtMenuDisplayWidget(
      {super.key,
      required this.menuEntry,
      required this.position,
      required this.onRemove});

  @override
  State<ArtMenuDisplayWidget> createState() => _ArtMenuDisplayWidgetState();
}

class _ArtMenuDisplayWidgetState extends State<ArtMenuDisplayWidget> {
  Offset _position = Offset.zero;
  List<ArtMenuItemBasic> _children = [];

  onShowSubMenu(pos, sub) {
    _position = pos;
    _children = sub;
    setState(() {});
  }

  Widget _buildMenu({
    required ArtMenuEntry menuEntry,
    required Offset position,
    bool showSub = true,
  }) {
    return AnimatedPositioned(
      left: position.dx,
      top: position.dy,
      duration: 100.ms,
      child: TweenAnimationBuilder<double>(
        duration: 100.ms,
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            alignment: Alignment.topLeft,
            child: Opacity(opacity: value, child: child),
          );
        },
        child: ArtMenuInnerWidget(
          onRemove: widget.onRemove,
          menuEntry: menuEntry,
          onShowSubMenu: (pos, sub) {
            if (showSub) {
              onShowSubMenu(pos, sub);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => widget.onRemove(),
            onSecondaryTapDown: (details) => widget.onRemove(),
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        _buildMenu(
          menuEntry: widget.menuEntry,
          position: widget.position,
        ),
        if (_position != Offset.zero)
          _buildMenu(
              showSub: false,
              position: _position,
              menuEntry: ArtMenuEntry(
                  children: _children,
                  onMenuItemTap: widget.menuEntry.onMenuItemTap,
                  opacity: widget.menuEntry.opacity)),
      ],
    );
  }
}
