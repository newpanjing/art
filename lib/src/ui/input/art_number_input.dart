import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtNumberInput extends StatefulWidget {
  final int value;
  final Function(int)? onChanged;
  final double step;
  final int min;
  final int max;
  final String label;
  final String message;
  final bool showButtons;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool autofocus;

  const ArtNumberInput(
      {super.key,
      this.min = 0,
      this.max = 65536,
      this.value = 1,
      this.step = 1,
      this.label = "",
      this.showButtons = true,
      this.message = "按住鼠标←→滑动调节",
      this.onChanged,
      this.backgroundColor,
      this.autofocus = false,
      this.borderColor});

  @override
  State<ArtNumberInput> createState() => _ArtNumberInputState();
}

class _ArtNumberInputState extends State<ArtNumberInput> {
  // 记录拖动起始位置和值
  double? _dragStartX;
  double? _dragStartValue;
  bool _isDragging = false;
  late TextEditingController _controller;
  var focusNode = FocusNode();
  var isHover = false;
  var isFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toStringAsFixed(0));
    focusNode.addListener(() {
      setState(() {
        isFocus = focusNode.hasFocus;
      });
      if (!focusNode.hasFocus) {
        callback();
      }
    });
  }

  callback({int step = 0}) {
    num newValue =
        double.tryParse(_controller.text.replaceAll("\r|\t|\n", "")) ?? 1.0;
    if (newValue < widget.min && newValue > widget.max) {
      newValue = widget.min;
    }
    if (step != 0) {
      newValue += step;
    }
    newValue = newValue.clamp(widget.min, widget.max);
    widget.onChanged?.call(newValue.toInt());
  }

  @override
  void didUpdateWidget(ArtNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isDragging) {
      _controller.text = widget.value.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dragStartX == null || _dragStartValue == null) return;

    final delta = details.globalPosition.dx - _dragStartX!;
    final newValue = _dragStartValue! + delta * widget.step;

    var constrainedValue = newValue.clamp(widget.min, widget.max);

    setState(() {
      _controller.text = constrainedValue.toStringAsFixed(0);
    });

    widget.onChanged?.call(newValue.toInt());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var bg = widget.backgroundColor ?? theme.scaffoldBackgroundColor;
    if (isHover) {
      bg = bg.withOpacity(0.8);
    }
    var borderColor = widget.borderColor ?? Colors.transparent;
    if (isFocus) {
      borderColor = theme.primaryColor;
    }
    return MouseRegion(
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
      child: Container(
        constraints: BoxConstraints(
            maxWidth: 92, minWidth: 92, maxHeight: 30, minHeight: 30),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: _buildInput(),
      ),
    );
  }

  Widget _buildDragArea(Widget child) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onPanStart: (details) {
          _dragStartX = details.globalPosition.dx;
          _dragStartValue =
              double.tryParse(_controller.text.replaceAll("\r|\t|\n", "")) ??
                  1.0;
          _isDragging = true;
        },
        onPanUpdate: _handleDragUpdate,
        onPanEnd: (details) {
          _isDragging = false;
        },
        child: child,
      ),
    );
  }

  Widget _buildInput() {
    return Row(
      children: [
        TextField(
          autofocus: widget.autofocus,
          focusNode: focusNode,
          controller: _controller,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          onSubmitted: (value) {
            callback();
          },
        ).fill(),
        if (widget.label.isNotEmpty)
          _buildDragArea(
            SizedBox(
              width: 10,
              child: Text(
                widget.label,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ).tooltip(widget.message),
          ),
        //添加一个上下调节的按钮
        if (widget.showButtons && isHover)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                color: Colors.grey[400],
                size: 14,
              ).onTap(() {
                callback(step: 1);
              }),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[400],
                size: 14,
              ).onTap(() {
                callback(step: -1);
              }),
            ],
          ).width(20),
        if (widget.showButtons && !isHover)
          SizedBox(
            width: 20,
          )
      ],
    );
  }
}
