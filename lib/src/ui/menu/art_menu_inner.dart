import 'package:art/art.dart';
import 'package:art/src/ui/art_mouse_builder.dart';
import 'package:art/src/ui/menu/model.dart';
import 'package:flutter/material.dart';

class ArtMenuInnerWidget extends StatefulWidget {
  final ArtMenuEntry menuEntry;
  final VoidCallback onRemove;
  final Function(Offset position, List<ArtMenuItemBasic> children)
      onShowSubMenu;

  const ArtMenuInnerWidget({
    super.key,
    required this.menuEntry,
    required this.onRemove,
    required this.onShowSubMenu,
  });

  @override
  State<ArtMenuInnerWidget> createState() => _ArtMenuInnerWidgetState();
}

class _ArtMenuInnerWidgetState extends State<ArtMenuInnerWidget> {
  ArtMenuEntry get menuEntry => widget.menuEntry;

  List<Widget> _buildMenus() {
    var children = widget.menuEntry.children;
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
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                // 先移除菜单
                widget.onRemove();
                // 再触发回调
                var rect= context.findRenderObject()?.paintBounds;
                widget.menuEntry.onMenuItemTap?.call(item);
                item.onTap?.call();
                item.onTapRect?.call(rect?? Rect.zero);
              },
              child: ArtMouseBuilder(builder: (context, hover) {
                Widget node = DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Color(0xffE2E2E2) : Color(0xff19191A)),
                    child: item.child);
                if (item.icon != null || item.children.isNotEmpty) {
                  node = Row(
                    spacing: 10,
                    children: [
                      if (item.icon != null)
                        IconTheme(
                            data: IconThemeData(
                                size: 14,
                                color:
                                    isDark ? Color(0xffE2E2E2) : Color(0xff19191A)),
                            child: item.icon!),
                      node,
                      Spacer(),
                      if (item.children.isNotEmpty)
                        Icon(Icons.chevron_right,
                            size: 14,
                            color: isDark ? Color(0xffA2A4A8) : Color(0xff19191A)),
                    ],
                  );
                }
                return Builder(builder: (context) {
                  return MouseRegion(
                    onEnter: (e) async {
                      if (item.children.isEmpty) {
                        widget.onShowSubMenu(Offset.zero, []);
                        return;
                      }
                      //获取当前item在屏幕中的位置
                      var box = context.findRenderObject() as RenderBox;
                      var offset = box.localToGlobal(Offset.zero);
                      //计算宽度
                      var width = box.size.width;
                      var x = offset.dx + width + 10;
                      var y = offset.dy;
                      widget.onShowSubMenu(Offset(x, y), item.children);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: hover
                            ? (isDark ? Color(0xff3b3b3b) : Color(0xffF3F3F4))
                            : null,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding:menuEntry.padding ?? EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      child: node,
                    ),
                  );
                });
              }),
            );
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: menuEntry.opacity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? Color(0xff303030) : Colors.white,
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
