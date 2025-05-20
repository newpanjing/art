import 'package:flutter/material.dart';

enum CollapseDirection { left, right }

class CollapsibleContainer extends StatefulWidget {
  final bool collapse;
  final CollapseDirection direction;
  final Widget child;
  final double width;
  final Duration duration;
  final VoidCallback? onCollapsed;
  final VoidCallback? onExpanded;

  const CollapsibleContainer({
    super.key,
    required this.collapse,
    required this.direction,
    required this.child,
    required this.width,
    this.duration = const Duration(milliseconds: 200),
    this.onCollapsed,
    this.onExpanded,
  });

  @override
  State<CollapsibleContainer> createState() => _CollapsibleContainerState();
}

class _CollapsibleContainerState extends State<CollapsibleContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isVisible = false);
          widget.onCollapsed?.call();
        } else if (status == AnimationStatus.dismissed) {
          widget.onExpanded?.call();
        }
      });

    if (widget.collapse) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CollapsibleContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.collapse != oldWidget.collapse) {
      if (widget.collapse) {
        _controller.forward();
      } else {
        setState(() => _isVisible = true);
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible && widget.collapse) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: widget.direction == CollapseDirection.left
                ? Alignment.centerRight
                : Alignment.centerLeft,
            widthFactor: _animation.value,
            child: SizedBox(width: widget.width, child: widget.child),
          ),
        );
      },
    );
  }
}
