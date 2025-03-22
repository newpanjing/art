import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtSelect<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T)? labelBuilder;
  final Widget Function(T)? itemBuilder;
  final Function(T?) onChanged;
  final String? placeholder;
  final double? width;
  final double height;

  const ArtSelect({
    super.key,
    this.value,
    required this.items,
    this.labelBuilder,
    this.itemBuilder,
    required this.onChanged,
    this.placeholder,
    this.width,
    this.height = 30,
  });

  @override
  State<ArtSelect<T>> createState() => _ArtSelectState<T>();
}

class _ArtSelectState<T> extends State<ArtSelect<T>> {
  bool _isHovered = false;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _showOverlay() {
    _hideOverlay();

    setState(() => _isOpen = true);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    //判断是否为深色模式
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hideOverlay,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      alignment: Alignment.topCenter,
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: isDarkMode? Color(0xff202020) : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return _SelectItem<T>(
                          item: item,
                          isSelected: widget.value == item,
                          height: widget.height,
                          itemBuilder: widget.itemBuilder,
                          labelBuilder: widget.labelBuilder,
                          onSelected: () {
                            widget.onChanged(item);
                            _hideOverlay();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Color get primaryColor => Theme.of(context).primaryColor;

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  @override
  Widget build(BuildContext context) {
    //判断是否为深色模式

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: _showOverlay,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isHovered ? primaryColor : (isDarkMode?Colors.grey[800]!:Colors.grey[300]!),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value != null
                        ? (widget.labelBuilder?.call(widget.value!) ??
                            widget.value.toString())
                        : (widget.placeholder ?? 'Please select'),
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.value != null
                          ? (isDarkMode?Colors.white:Colors.black87)
                          : (isDarkMode?Colors.white:Colors.black38),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: Duration(milliseconds: 100),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectItem<T> extends StatefulWidget {
  final T item;
  final bool isSelected;
  final double height;
  final Widget Function(T)? itemBuilder;
  final String Function(T)? labelBuilder;
  final VoidCallback onSelected;

  const _SelectItem({
    required this.item,
    required this.isSelected,
    required this.height,
    this.itemBuilder,
    this.labelBuilder,
    required this.onSelected,
  });

  @override
  State<_SelectItem<T>> createState() => _SelectItemState<T>();
}

class _SelectItemState<T> extends State<_SelectItem<T>> {
  bool _isHovered = false;

  Color get primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    //判断是否为深色模式
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onSelected,
        child: AnimatedContainer(
          duration: 100.ms,
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _isHovered ? (isDarkMode?primaryColor:Colors.grey[100]) : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: widget.itemBuilder?.call(widget.item) ??
                    Text(
                      widget.labelBuilder?.call(widget.item) ??
                          widget.item.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode?Colors.white:Colors.black87,
                      ),
                    ),
              ),
              if (widget.isSelected)
                Icon(Icons.check, size: 16, color: primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
