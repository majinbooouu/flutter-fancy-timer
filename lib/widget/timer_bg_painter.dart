import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = const Color.fromRGBO(195, 195, 195, 1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);
  }

  @override
  bool shouldRepaint(TimerBackgroundPainter oldDelegate) => false;
}
