import 'dart:ui';

extension SizeAddition on Size {
  Size addition(Size other) {
    return Size(width + other.width, height + other.height);
  }
  Size subtraction(Size other){
    return Size(width - other.width, height - other.height);
  }
}