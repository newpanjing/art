import 'package:flutter/cupertino.dart';

class ArtMouseBuilder extends StatefulWidget {
  //builder
  final Widget Function(
    BuildContext context,
    bool hover
  ) builder;

  const ArtMouseBuilder({super.key, required this.builder});

  @override
  State<ArtMouseBuilder> createState() => _ArtMouseBuilderState();
}

class _ArtMouseBuilderState extends State<ArtMouseBuilder> {
  var hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hover = false;
        });
      },
      child: widget.builder(
        context,
        hover,
      ),
    );
  }
}
