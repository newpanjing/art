import 'package:flutter/widgets.dart';

extension NumberExtension on num {

  Duration get ms => Duration(milliseconds: toInt());

  Duration get s => Duration(seconds: toInt());

  Duration get m => Duration(minutes: toInt());

  Duration get h => Duration(hours: toInt());

  Duration get d => Duration(days: toInt());

  Duration get week => Duration(days: toInt() * 7);

  Duration get months => Duration(days: toInt() * 30);

  Duration get years => Duration(days: toInt() * 365);

  //间距
  EdgeInsetsGeometry get padding => EdgeInsets.all(toDouble());

  EdgeInsetsGeometry get paddingLeft => EdgeInsets.only(left: toDouble());

  EdgeInsetsGeometry get paddingRight => EdgeInsets.only(right: toDouble());

  EdgeInsetsGeometry get paddingTop => EdgeInsets.only(top: toDouble());

  EdgeInsetsGeometry get paddingBottom => EdgeInsets.only(bottom: toDouble());

  EdgeInsetsGeometry get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsetsGeometry get paddingVertical =>
      EdgeInsets.symmetric(vertical: toDouble());

  //填充
  Widget get widthBox => SizedBox(width: toDouble());
  Widget get heightBox => SizedBox(height: toDouble());

  @Deprecated('Use width instead of hPadding')
  Widget get hPadding => SizedBox(height: toDouble());
  @Deprecated('Use width instead of vPadding')
  Widget get vPadding => SizedBox(width: toDouble());
}
