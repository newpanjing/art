
import 'package:flutter/material.dart';

class ArtMenuItemBasic {}

class ArtMenuItemSeparator extends ArtMenuItemBasic {
  final double? height;
  final Color? color;

  ArtMenuItemSeparator({
    this.height = 1,
    this.color,
  });
}

class ArtMenuItem extends ArtMenuItemBasic {
  final Widget child;
  final VoidCallback? onTap;
  final Widget? icon;
  final List<ArtMenuItemBasic> children;

  ArtMenuItem({
    required this.child,
    this.onTap,
    this.icon,
    this.children = const [],
  });
}

class ArtMenuEntry {
  final List<ArtMenuItemBasic> children;
  final Function(ArtMenuItem item)? onMenuItemTap;
  final EdgeInsetsGeometry? padding;
  //透明度
  final double opacity;

  ArtMenuEntry({
    required this.children,
    this.onMenuItemTap,
    this.opacity = 1,
    this.padding,
  });
}
