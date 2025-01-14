import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtNumberInput extends StatefulWidget {
  final int value;
  final Function(int)? onChanged;
  final double step;
  final int min;
  final int max;
  final String label;

  const ArtNumberInput(
      {super.key,
      this.min = 0,
      this.max = 65536,
      this.value = 1,
      this.step = 1,
      this.label = "",
      this.onChanged});

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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toStringAsFixed(0));
    focusNode.addListener(() {
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
    return Container(
      constraints: BoxConstraints(
          maxWidth: 92, minWidth: 92, maxHeight: 30, minHeight: 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          TextField(
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
          ).width(50),
          //添加一个上下调节的按钮
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
          ),
          GestureDetector(
            onHorizontalDragStart: (details) {
              _isDragging = true;
              _dragStartX = details.globalPosition.dx;
              _dragStartValue = widget.value.toDouble();
            },
            onHorizontalDragUpdate: (details) => _handleDragUpdate(details),
            onHorizontalDragEnd: (_) {
              _isDragging = false;
              _dragStartX = null;
              _dragStartValue = null;
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                  color: _isDragging ? Colors.grey[100] : null,
                ),
                child: Tooltip(
                  message: "按住鼠标←→滑动调节",
                  child: widget.label.isEmpty
                      ? Icon(Icons.compare_arrows_sharp,
                              size: 13, color: Colors.grey[600])
                          .center()
                          .width(25)
                      : Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ).center().width(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
