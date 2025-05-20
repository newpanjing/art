import 'package:flutter/material.dart';

class ArtMouseDecorator extends StatefulWidget {
  final Widget child;
  final Color? hoverColor;
  final Color? pressedColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final Duration duration;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final String? tooltip;

  const ArtMouseDecorator({
    super.key,
    required this.child,
    this.hoverColor,
    this.pressedColor,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.duration = const Duration(milliseconds: 200),
    this.padding,
    this.constraints,
    this.tooltip,
  });

  @override
  State<ArtMouseDecorator> createState() => _ArtMouseDecoratorState();
}

class _ArtMouseDecoratorState extends State<ArtMouseDecorator> {
  bool _isHovered = false;
  bool _isPressed = false;

  Color get _targetColor {
    if (_isPressed) {
      return widget.pressedColor ?? Colors.grey.withOpacity(0.2);
    }
    if (_isHovered) {
      return widget.hoverColor ?? Colors.grey.withOpacity(0.1);
    }
    return widget.backgroundColor ?? Colors.transparent;
  }

  Widget _buildChild() {
    Widget result = AnimatedContainer(
      duration: widget.duration,
      padding: widget.padding,
      constraints: widget.constraints,
      decoration: BoxDecoration(
        color: _targetColor,
        borderRadius: widget.borderRadius,
        border: widget.border,
      ),
      child: widget.child,
    );

    if (widget.tooltip != null) {
      result = Tooltip(
        message: widget.tooltip!,
        child: result,
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: _buildChild(),
      ),
    );
  }
}
