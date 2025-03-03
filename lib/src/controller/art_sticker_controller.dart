import 'dart:ui';

class ArtStickerController {
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final void Function(Offset delta,Offset position)? onDragUpdate;
  final void Function(Size size)? onResizeStart;
  final void Function(double rotation)? onRotationStart;

  //具名参数
  ArtStickerController({
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.onResizeStart,
    this.onRotationStart,
  });
}
