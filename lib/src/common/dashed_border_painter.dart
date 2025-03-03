import 'dart:math';

import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color dashColor;
  final double dashLength;
  final double dashSpace;

  DashedBorderPainter({
    this.strokeWidth = 1.0,
    this.dashColor = Colors.black,
    this.dashLength = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dashColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // 绘制上边框
    _drawDashedLine(canvas, paint, 
      Offset(0, 0), 
      Offset(size.width, 0)
    );

    // 绘制右边框
    _drawDashedLine(canvas, paint, 
      Offset(size.width, 0), 
      Offset(size.width, size.height)
    );

    // 绘制下边框
    _drawDashedLine(canvas, paint, 
      Offset(size.width, size.height), 
      Offset(0, size.height)
    );

    // 绘制左边框
    _drawDashedLine(canvas, paint, 
      Offset(0, size.height), 
      Offset(0, 0)
    );
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    // 计算线段总长度
    final path = Path()..moveTo(start.dx, start.dy);
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);
    
    // 计算虚线段数量
    final count = (distance / (dashLength + dashSpace)).floor();
    
    // 计算每段虚线的向量
    final stepX = dx / count;
    final stepY = dy / count;

    // 绘制虚线
    var currentX = start.dx;
    var currentY = start.dy;
    
    for (var i = 0; i < count; i++) {
      path.moveTo(currentX, currentY);
      
      currentX += stepX * dashLength / (dashLength + dashSpace);
      currentY += stepY * dashLength / (dashLength + dashSpace);
      
      path.lineTo(currentX, currentY);
      
      currentX += stepX * dashSpace / (dashLength + dashSpace);
      currentY += stepY * dashSpace / (dashLength + dashSpace);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
