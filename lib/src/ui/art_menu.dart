import 'package:art/art.dart';
import 'package:art/src/ui/art_mouse_builder.dart';
import 'package:flutter/material.dart';

class ArtMenuItemBasic {}

class ArtMenuItemSeparator extends ArtMenuItemBasic {
  final double? height;
  final Color? color;

  ArtMenuItemSeparator({
    this.height = 1,
    this.color,
  });
}

class ArtMenuItem extends ArtMenuItemBasic {
  final Widget child;
  final VoidCallback? onTap;
  final Widget? icon;
  final List<ArtMenuItemBasic> children;

  ArtMenuItem({
    required this.child,
    this.onTap,
    this.icon,
    this.children = const [],
  });
}

class ArtMenu extends StatefulWidget {
  final List<ArtMenuItemBasic> children;
  final Function(ArtMenuItem item)? onMenuItemTap;

  //透明度
  final double opacity;

  const ArtMenu({
    super.key,
    required this.children,
    this.onMenuItemTap,
    this.opacity = 1,
  });

  @override
  State<ArtMenu> createState() => _ArtMenuState();
}

class _ArtMenuState extends State<ArtMenu> {
  List<Widget> _buildMenus() {
    var children = widget.children;
    if (children.isNotEmpty) {
      List<Widget> menus = [];
      for (var i = 0; i < children.length; i++) {
        var child = children[i];
        if (child is ArtMenuItem) {
          menus.add(_buildMenuItem(item: child));
        } else {
          var separator = child as ArtMenuItemSeparator;
          menus.add(Divider(
            height: separator.height,
            color: separator.color,
          ));
        }
      }
      return menus;
    }
    return [];
  }

  Widget _buildMenuItem({
    required ArtMenuItem item,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 2,
        ),
        child: GestureDetector(
          onTap: () {
            // 先移除菜单
            entry.remove();
            // 再触发回调
            widget.onMenuItemTap?.call(item);
            item.onTap?.call();
          },
          child: ArtMouseBuilder(builder: (context, hover) {
            Widget node = DefaultTextStyle(
                style: TextStyle(fontSize: 14, color: Color(0xff19191A)),
                child: item.child);
            if (item.icon != null || item.children.isEmpty) {
              node = Row(
                spacing: 10,
                children: [
                  if (item.icon != null) item.icon!,
                  node,
                  if (item.children.isNotEmpty)
                    Icon(Icons.chevron_right,
                        size: 14, color: Color(0xff19191A)),
                ],
              );
            }
            //
            return Container(
              decoration: BoxDecoration(
                color: hover ? Color(0xffF3F3F4) : null,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: node,
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: widget.opacity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildMenus(),
            ),
          ),
        ),
      ),
    );
  }
}

late OverlayEntry entry;

void showContextMenu(
    {required BuildContext context,
    required Offset position,
    required ArtMenu menu}) {
  final OverlayState overlay = Overlay.of(context);

  entry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => entry.remove(),
            onSecondaryTapDown: (details) => entry.remove(),
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy,
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
            child: menu,
          ),
        ),
      ],
    ),
  );

  overlay.insert(entry);
}
