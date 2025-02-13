import 'package:flutter/material.dart';

class ArtPopupMenuItem {
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDivider;
  final bool enabled;
  final Widget? child;

  ArtPopupMenuItem({
    this.text,
    this.icon,
    this.onTap,
    this.isDivider = false,
    this.enabled = true,
    this.child,
  }) : assert(
          (text != null || isDivider || child != null),
          'Must provide either text, isDivider or child',
        );
}

class ArtPopupMenu extends StatelessWidget {
  final Widget child;
  final List<ArtPopupMenuItem> items;
  final double? width;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final Color? iconColor;

  const ArtPopupMenu({
    super.key,
    required this.child,
    required this.items,
    this.width = 180,
    this.itemHeight = 32,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
    this.borderRadius,
    this.backgroundColor,
    this.hoverColor,
    this.textStyle,
    this.iconColor,
  });

  void _showMenu(BuildContext context, TapDownDetails details) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset position =
        button.localToGlobal(details.localPosition, ancestor: overlay);

    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 背景遮罩，点击时关闭菜单
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => removeOverlay(overlayEntry),
              onSecondaryTap: () => removeOverlay(overlayEntry),
            ),
          ),
          // 菜单内容
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Material(
              color: Colors.transparent,
              child: _MenuContainer(
                items: items,
                width: width,
                itemHeight: itemHeight,
                padding: padding,
                borderRadius: borderRadius,
                backgroundColor: backgroundColor,
                hoverColor: hoverColor,
                textStyle: textStyle,
                iconColor: iconColor,
                onDismiss: () => removeOverlay(overlayEntry),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  void removeOverlay(OverlayEntry overlayEntry) {
    overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) => _showMenu(context, details),
      child: child,
    );
  }
}

class _MenuContainer extends StatelessWidget {
  final List<ArtPopupMenuItem> items;
  final double? width;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final VoidCallback onDismiss;

  const _MenuContainer({
    required this.items,
    required this.width,
    required this.itemHeight,
    required this.padding,
    required this.borderRadius,
    required this.backgroundColor,
    required this.hoverColor,
    required this.textStyle,
    required this.iconColor,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      //约束
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            if (item.isDivider) {
              return Divider(height: 1, color: Colors.grey.shade200);
            }

            if (item.child != null) {
              return item.child!;
            }

            return _MenuItem(
              text: item.text!,
              icon: item.icon,
              onTap: () {
                if (item.enabled && item.onTap != null) {
                  onDismiss();
                  item.onTap!();
                }
              },
              height: itemHeight,
              hoverColor: hoverColor,
              textStyle: textStyle,
              iconColor: iconColor,
              enabled: item.enabled,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final bool enabled;

  const _MenuItem({
    required this.text,
    this.icon,
    this.onTap,
    required this.height,
    this.hoverColor,
    this.textStyle,
    this.iconColor,
    required this.enabled,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = widget.textStyle ??
        TextStyle(
          fontSize: 13,
          color: widget.enabled ? Colors.black87 : Colors.grey.shade400,
        );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: _isHovered && widget.enabled
                ? (widget.hoverColor ?? Colors.grey.shade100)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: widget.enabled
                      ? (widget.iconColor ?? Colors.grey.shade700)
                      : Colors.grey.shade400,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  widget.text,
                  style: effectiveTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
