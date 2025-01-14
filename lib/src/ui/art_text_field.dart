import 'package:flutter/material.dart';

class ArtTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextStyle? style;
  final int maxLines;
  final TextAlign textAlign;
  const ArtTextField({
    super.key,
    this.maxLines = 1,
    this.focusNode,
    this.controller,
    this.hintText,
    this.onChanged,
    this.style,
    this.onSubmitted,
    this.textAlign=TextAlign.start,
  });

  @override
  State<ArtTextField> createState() => _ArtTextFieldState();
}

class _ArtTextFieldState extends State<ArtTextField> {

  late FocusNode _focusNode;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
   init();
  }

  init(){
    _controller = widget.controller?? TextEditingController();
    _focusNode = widget.focusNode?? FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onSubmitted?.call(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  //widget数据更新
  @override
  void didUpdateWidget(covariant ArtTextField oldWidget) {
    if (oldWidget.controller != widget.controller) {
      _controller = widget.controller?? TextEditingController(text: _controller.text);
    }
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: widget.style,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Enter...',
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        //默认也有边框
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}