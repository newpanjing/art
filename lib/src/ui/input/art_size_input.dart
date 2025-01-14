import 'package:art/art.dart';
import 'package:flutter/material.dart';

class ArtSizeInput extends StatefulWidget {
  final Size value;
  final Function(Size) onChanged;
  final double? min;
  final double? max;
  final double step;
  final String leftLabel;
  final String rightLabel;

  const ArtSizeInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 10000,
    this.step = 1,
    this.leftLabel = 'W',
    this.rightLabel = 'H',
  });

  @override
  State<ArtSizeInput> createState() => _ArtSizeInputState();
}

class _ArtSizeInputState extends State<ArtSizeInput> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        ArtNumberInput(
          value: widget.value.width.toInt(),
          label: widget.leftLabel,
          onChanged: (value) {
            widget.onChanged(Size(value.toDouble(), widget.value.height));
          },
        ),
        ArtNumberInput(
          value: widget.value.height.toInt(),
          label: widget.rightLabel,
          onChanged: (value) {
            widget.onChanged(Size(widget.value.width, value.toDouble()));
          },
        ),
      ],
    );
  }
}