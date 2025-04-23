import 'package:art/art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:popover/popover.dart';

class ArtColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final Size size;
  final Size iconSize;
  final DecorationImage? decorationImage;

  const ArtColorPicker(
      {super.key,
      required this.initialColor,
      required this.onColorChanged,
      this.size = const Size(300, 300),
      this.iconSize = const Size(25, 25),
      this.decorationImage});

  @override
  State<ArtColorPicker> createState() => _ArtColorPickerState();
}

class _ArtColorPickerState extends State<ArtColorPicker> {
  @override
  void initState() {
    super.initState();
  }

  bool get isDarkMode =>
      MediaQuery.of(context).platformBrightness == Brightness.dark;

  _showColorPicker() async {
    showPopover(
      barrierColor: Colors.transparent,
      transitionDuration: 50.ms,
      backgroundColor: isDarkMode?Colors.grey.shade900:Colors.grey.shade100,
      context: context,
      onPop: () {},
      bodyBuilder: (context) {
        return Container(
          padding: 10.padding,
          width: widget.size.width,
          height: widget.size.height,
          child: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: widget.initialColor,
              onColorChanged: (color) {
                widget.onColorChanged(color);
              },
              portraitOnly: true,
              enableAlpha: true,
              hexInputBar: true,
              pickerAreaHeightPercent: 0.4,
              displayThumbColor: false,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //一个30x30的card
    return Container(
      padding: 1.padding,
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode?Colors.grey.shade800:Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Container(
            width: widget.iconSize.width,
            height: widget.iconSize.height,
            decoration: BoxDecoration(
              image: widget.decorationImage,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          AnimatedContainer(
            duration: 100.ms,
            width: widget.iconSize.width,
            height: widget.iconSize.height,
            decoration: BoxDecoration(
              color: widget.initialColor,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
    ).onTap(_showColorPicker);
  }
}
