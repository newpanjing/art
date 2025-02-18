import 'dart:ui';

class ArtStickerController {
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final void Function(Offset delta,Offset position)? onDragUpdate;

  //具名参数
  ArtStickerController({
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
  });
}
