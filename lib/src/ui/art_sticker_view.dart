import 'dart:math' as math;

import 'package:art/art.dart';
import 'package:art/src/common/dashed_border_painter.dart';
import 'package:art/src/common/resize_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtStickerView extends StatefulWidget {
  final Widget child;
  final Size size;
  final double rotation;
  final Offset position;
  final bool selected;
  final Function(Size, Size)? onSizeChanged;
  final Function(Offset, Offset)? onPositionChanged;
  final Function(double)? onRotationChanged;
  final Function()? onDoubleTap;
  final Function()? onEnd;
  final VoidCallback? onSelected;
  final VoidCallback? onDelete;
  final double scale;
  final ArtStickerController? controller;
  final Color primaryColor;

  const ArtStickerView(
      {super.key,
      required this.child,
      required this.size,
      this.controller,
      this.rotation = 0,
      this.position = Offset.zero,
      this.selected = false,
      this.onSizeChanged,
      this.onPositionChanged,
      this.onRotationChanged,
      this.onSelected,
      this.onDelete,
      this.scale = 1,
      this.onEnd,
      this.primaryColor = Colors.blue,
      this.onDoubleTap});

  @override
  State<ArtStickerView> createState() => _ArtStickerViewState();
}

class _ArtStickerViewState extends State<ArtStickerView> {
  Offset? _dragStart;
  Offset? _positionStart;
  double? _rotationStart;
  Size? _sizeStart;

  // 根据缩放和尺寸计算边框宽度
  double get _borderWidth {
    // 基础宽度
    const baseWidth = 3.0;
    // 最小和最大宽度
    const minWidth = 3.0;
    const maxWidth = 10.0;

    // 只考虑缩放因素
    final scaleAdjustedWidth = baseWidth / widget.scale;

    // 限制在合理范围内
    return math.min(maxWidth, math.max(minWidth, scaleAdjustedWidth));
  }

  final _offset = Offset(20.00, 40.0);

  Offset get offset {
    var val = _offset / widget.scale;
    if (widget.scale < 1) {
      val = val / widget.scale;
    } else {
      val = val * widget.scale;
    }
    //最大不超过_offset的2倍
    val = Offset(
        math.min(val.dx, _offset.dx * 2), math.min(val.dy, _offset.dy * 2));
    return val;
  }

  var isDown = false;
  var isHover = ValueNotifier(false);

  Widget _buildDrag({required Widget child}) {

    return Listener(

      onPointerDown: (e) {
        isDown = true;
      },
      onPointerUp: (e) {
        isDown = false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          //阻止点击事件
        },
        onDoubleTap: widget.onDoubleTap,
        onPanDown: (details) {
          widget.onSelected?.call();
        },
        onPanStart: (details) {
          // print("start:$isDown");
          if (!isDown) {
            return;
          }
          _dragStart = details.globalPosition;
          _positionStart = widget.position;
          // print("拖拽开始");
          widget.controller?.onDragStart?.call();
        },
        onPanUpdate: (details) {
          // if (!isDown) {
          //   return;
          // }
          if (_dragStart == null || _positionStart == null) return;
          final delta = details.globalPosition - _dragStart!;
          // 移动时考虑缩放
          final scaledDelta = delta / widget.scale;
          widget.onPositionChanged
              ?.call(_positionStart! + scaledDelta, scaledDelta);
          // print("拖拽中");
          widget.controller?.onDragUpdate
              ?.call(scaledDelta, _positionStart! + scaledDelta);
        },
        onPanEnd: (_) {
          widget.onEnd?.call();
          widget.controller?.onDragEnd?.call();
          // print("拖拽结束");
        },
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pos = offset;
    return Positioned(
      left: widget.position.dx - pos.dx,
      top: widget.position.dy - pos.dy,
      width: widget.size.width + pos.dx * 2,
      height: widget.size.height + pos.dy * 2,
      child: Transform.rotate(
        angle: widget.rotation * math.pi / 180,
        child: Stack(
          children: [
            Positioned(
                left: pos.dx,
                top: pos.dy,
                child: _buildDrag(child: widget.child)),
            if (widget.selected) ...[
              _buildRotate(),
              ..._buildBorderLine(),
              ..._buildResize(),
            ],
            // _buildBorder(),
            _buildHoverBorder(),
          ],
        ),
      ),
    );
  }

  Color get primaryColor {
    return widget.primaryColor;
  }

  List<Widget> _buildBorderLine() {
    var lineWidth = _borderWidth;
    var x = offset.dx;
    var y = offset.dy;

    var lines = <Widget>[
      Positioned(
        left: x,
        top: y,
        width: lineWidth,
        height: widget.size.height,
        child: Container(
          color: primaryColor,
        ),
      ),
      Positioned(
        left: x,
        top: y,
        width: widget.size.width,
        height: lineWidth,
        child: Container(
          color: primaryColor,
        ),
      ),
      Positioned(
        left: x + widget.size.width,
        top: y,
        width: lineWidth,
        height: widget.size.height,
        child: Container(
          color: primaryColor,
        ),
      ),
      Positioned(
        left: x,
        top: y + widget.size.height,
        width: widget.size.width,
        height: lineWidth,
        child: Container(
          color: primaryColor,
        ),
      ),
    ];

    return lines;
  }

  Widget _buildRotate() {
    return Positioned(
      left: (widget.size.width + offset.dx * 2) / 2 - offset.dx / 2,
      top: 0,
      child: Container(
        width: offset.dx * 1.5,
        height: offset.dx * 1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: _borderWidth),
          borderRadius: BorderRadius.circular(offset.dx),
        ),
        child: GestureDetector(
          onPanStart: (details) {
            _dragStart = details.globalPosition;
            _rotationStart = widget.rotation;
            widget.controller?.onRotationStart?.call(_rotationStart ?? 0);
          },
          onPanUpdate: (details) {
            if (_dragStart == null || _rotationStart == null) return;

            // 计算旋转中心点（相对于全局坐标）
            final box = context.findRenderObject() as RenderBox;
            final centerPoint = box.localToGlobal(
              Offset(
                widget.size.width / 2 + offset.dx,
                widget.size.height / 2 + offset.dy,
              ),
            );

            // 计算开始拖动时相对于中心的向量
            final startVector = _dragStart! - centerPoint;
            // 计算当前拖动位置相对于中心的向量
            final currentVector = details.globalPosition - centerPoint;

            // 计算两个向量之间的角度
            final angle = math.atan2(currentVector.dy, currentVector.dx) -
                math.atan2(startVector.dy, startVector.dx);

            // 转换为角度并添加到起始角度
            var newRotation = _rotationStart! + angle * 180 / math.pi;

            // 规范化角度到 0-360 范围
            newRotation = newRotation % 360;
            if (newRotation < 0) newRotation += 360;

            widget.onRotationChanged?.call(newRotation);
          },
          child: Tooltip(
            message: '旋转',
            decoration: Theme.of(context).tooltipTheme.decoration,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                CupertinoIcons.rotate_right,
                size: offset.dx * 1.7 * 0.5,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResizeIcon({
    required ResizeDirection direction,
    MouseCursor cursor = SystemMouseCursors.precise,
    required Function(Offset) onMove,
  }) {
    var w = 18.0 / widget.scale;
    //限制在最小15和最大50之间
    w = w.clamp(15, 80);

    var x = 0.0, y = 0.0;
    switch (direction) {
      case ResizeDirection.tl:
        x = offset.dx - w / 2;
        y = offset.dy - w / 2;
        break;
      case ResizeDirection.tr:
        x = widget.size.width + offset.dx - w / 2;
        y = offset.dy - w / 2;
        break;
      case ResizeDirection.bl:
        x = offset.dx - w / 2;
        y = widget.size.height + offset.dy - w / 2;
        break;
      case ResizeDirection.br:
        x = widget.size.width + offset.dx - w / 2;
        y = widget.size.height + offset.dy - w / 2;
    }

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, // 允许透明区域捕获鼠标事件
        onPanStart: (details) {
          _dragStart = details.globalPosition;
          _positionStart = widget.position;
          _rotationStart = widget.rotation;
          _sizeStart = widget.size;
          widget.controller?.onResizeStart?.call(_sizeStart ?? Size.zero);
        },
        onPanUpdate: (details) {
          if (_dragStart == null ||
              _positionStart == null ||
              _rotationStart == null ||
              _sizeStart == null) return;
          final delta = details.globalPosition - _dragStart!;
          final scaledDelta = delta / widget.scale;
          final offset = Offset(scaledDelta.dx, scaledDelta.dy);
          onMove(offset);
        },
        child: Container(
          width: w,
          height: w,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryColor, width: _borderWidth),
            borderRadius: BorderRadius.circular(w),
          ),
          child: MouseRegion(
            cursor: cursor,
            child: Tooltip(
              message:
                  '${widget.size.width.toInt()}x${widget.size.height.toInt()}',
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResize() {
    var w = 18 * widget.scale;
    var x = (w / 2);
    var y = (w - w / 2);
    return [
      // 左上角
      _buildResizeIcon(
        direction: ResizeDirection.tl,
        onMove: (offset) {
          // 计算新的位置
          final newPosition = _positionStart! + offset;
          // 计算新的尺寸
          var size = Size(
              _sizeStart!.width - offset.dx, _sizeStart!.height - offset.dy);
          if (size.width < 10 || size.height < 10) {
            return;
          }
          //计算本次的宽度和高度中间或者减少了多少
          var width = _sizeStart!.width - size.width;
          var height = _sizeStart!.height - size.height;
          var value = Size(width, height);
          widget.onPositionChanged?.call(newPosition, offset);
          widget.onSizeChanged?.call(size, value);
        },
      ),
      _buildResizeIcon(
        direction: ResizeDirection.bl,
        onMove: (offset) {
          // 计算新的位置 - 只需要更新x坐标，因为是左下角
          final pos =
              Offset(_positionStart!.dx + offset.dx, _positionStart!.dy);
          widget.onPositionChanged?.call(pos, offset);

          // 计算新的尺寸
          // x方向是减少（向右拖动增加宽度，向左拖动减少宽度）
          // y方向是增加（向下拖动增加高度，向上拖动减少高度）
          var size = Size(
            _sizeStart!.width - offset.dx, // 左侧拖动，宽度需要减去偏移量
            _sizeStart!.height + offset.dy, // 下方拖动，高度需要加上偏移量
          );

          // 限制最小尺寸
          if (size.width < 10 || size.height < 10) {
            return;
          }

          // 计算本次的宽度和高度变化量
          var width = _sizeStart!.width - size.width; // 宽度的变化量
          var height = _sizeStart!.height - size.height; // 高度的变化量
          var value = Size(width, height);

          widget.onSizeChanged?.call(size, value);
        },
      ),
      // 右上角
      _buildResizeIcon(
        direction: ResizeDirection.tr,
        onMove: (offset) {
          //右上角需要更新y
          final pos =
              Offset(_positionStart!.dx, _positionStart!.dy + offset.dy);
          widget.onPositionChanged?.call(pos, offset);
          var size = Size(
              _sizeStart!.width + offset.dx, _sizeStart!.height - offset.dy);
          //计算本次的宽度和高度中间或者减少了多少
          var width = _sizeStart!.width - size.width;
          var height = _sizeStart!.height - size.height;
          var value = Size(width, height);
          widget.onSizeChanged?.call(size, value);
        },
      ),
      _buildResizeIcon(
        direction: ResizeDirection.br,
        onMove: (offset) {
          var size = Size(
              _sizeStart!.width + offset.dx, _sizeStart!.height + offset.dy);
          // 计算本次
          var width = _sizeStart!.width - size.width;
          var height = _sizeStart!.height - size.height;
          var value = Size(width, height);
          widget.onSizeChanged?.call(size, value);
        },
      ),
    ];
  }

  Widget _buildHoverBorder() {

    return ValueListenableBuilder(valueListenable: isHover, builder: (context,value,child){
      if(!value||widget.selected){
        return SizedBox();
      }
      return Positioned(
        left: offset.dx - _borderWidth,
        top: offset.dy - _borderWidth,
        width: widget.size.width + _borderWidth * 2,
        height: widget.size.height + _borderWidth * 2,
        child: CustomPaint(
          painter: DashedBorderPainter(
              strokeWidth: _borderWidth,
              dashColor: primaryColor,
              dashLength: 10,
              dashSpace: 20),
        ),
      );
    });
  }

}
