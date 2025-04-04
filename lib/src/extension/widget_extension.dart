import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension WidgetExtension on Widget {
  Widget padding(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  // 水平间距
  Widget paddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  // 垂直间距
  Widget paddingVertical(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  // 居中
  Widget center() {
    return Center(
      child: this,
    );
  }

  //提示
  Widget tooltip(String message) {
    return Builder(builder: (context) {
      var isDark = Theme.of(context).brightness == Brightness.dark;
      return Tooltip(
        decoration: BoxDecoration(
          color: isDark ? Color(0xff242424) : Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        message: message,
        child: this,
      );
    });
  }

  Widget size({double? all, double? width, double? height}) {
    if (all != null) {
      return SizedBox(
        width: all,
        height: all,
        child: this,
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget alignment(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  Widget paddingOnly({
    double? all,
    double? padding,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      return Padding(
        padding: EdgeInsets.all(all),
        child: this,
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: left ?? padding ?? all ?? 0,
        right: right ?? padding ?? all ?? 0,
        top: top ?? padding ?? all ?? 0,
        bottom: bottom ?? padding ?? all ?? 0,
      ),
      child: this,
    );
  }

  //填充
  Widget fill() {
    return Expanded(
      child: this,
    );
  }

  Widget onTap(Function() onTap, {bool inkWell = true}) {
    if (inkWell) {
      return InkWell(
        onTap: () {
          //提供触感反馈
          HapticFeedback.lightImpact();
          onTap.call();
        },
        child: this,
      );
    }
    return GestureDetector(
      onTap: () {
        //提供触感反馈
        HapticFeedback.lightImpact();
        onTap.call();
      },
      child: this,
    );
  }

  //旋转角度
  Widget rotate(double angle) {
    return Transform.rotate(
      angle: angle,
      child: this,
    );
  }

  //透明度
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  Widget scale(double scale) {
    return Transform.scale(
      scale: scale,
      child: this,
    );
  }

  //灰度组件
  Widget gray({bool enable = true}) {
    //colorFilter: enable ? const ColorFilter.matrix(<double>[])
    if (!enable) {
      return this;
    }
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: this,
    );
  }

  Widget blur({double blurRadius = 10}) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurRadius,
          sigmaY: blurRadius,
        ),
        child: this,
      ),
    );
  }

  Widget clipRRect({double radius = 20}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: this,
    );
  }

  //背景
  Widget background({
    EdgeInsetsGeometry? padding,
    Border? border,
    Color color = Colors.green,
    double radius = 0,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius == 0 ? null : BorderRadius.circular(radius),
        border: border,
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: this,
    );
  }

  Widget width(double? width) {
    if (width == null) {
      return this;
    }
    return SizedBox(
      width: width,
      child: this,
    );
  }

  Widget height(double? height) {
    if (height == null) {
      return this;
    }
    return SizedBox(
      height: height,
      child: this,
    );
  }

  Widget icon(
    Widget icon, {
    double spacing = 5.0,
  }) {
    return Row(
      spacing: spacing,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        this,
      ],
    );
  }
}
