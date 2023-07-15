import 'package:flutter/material.dart';
import 'dart:math';

class WatchFace extends StatefulWidget {
  final int totalSeconds;
  const WatchFace({
    super.key,
    required this.totalSeconds,
  });

  @override
  State<WatchFace> createState() => _WatchFaceState();
}

class _WatchFaceState extends State<WatchFace> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Stack(
            children: [
              CustomPaint(
                painter: TimerBackgroundPainter(Colors.white),
                size: const Size(300.0, 300.0),
              ),
              CustomPaint(
                painter: TimeArcPainter(widget.totalSeconds),
                size: const Size(300.0, 300.0),
              ),
              CustomPaint(
                painter: TimerHandPainter(),
                size: const Size(300.0, 300.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeArcPainter extends CustomPainter {
  final int totalSeconds;

  TimeArcPainter(this.totalSeconds);
  @override
  void paint(Canvas canvas, Size size) {
    Rect myRect = const Offset(0.0, 0.0) & const Size(300, 300);
    final Paint paint = Paint()
      ..color = Colors.red.withOpacity(0.95)
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0;
    canvas.drawArc(
        myRect, pi * 3 / 2, 2 * pi * totalSeconds / 3600, true, paint);
  }

  @override
  bool shouldRepaint(TimeArcPainter oldDelegate) => false;
}

class TimerBackgroundPainter extends CustomPainter {
  final Color bgColor;

  TimerBackgroundPainter(this.bgColor);
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);
  }

  @override
  bool shouldRepaint(TimerBackgroundPainter oldDelegate) => false;
}

class TimerHandPainter extends CustomPainter {
  final Animation<int>? animation;

  TimerHandPainter({this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final hourHandPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final minuteHandPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const hourHandCount = 12;
    const minuteHandCount = 60; // Updated to 60

    const hourHandAngle = 2 * pi / hourHandCount;

    for (int i = 0; i < hourHandCount; i++) {
      final handAngle = hourHandAngle * i - pi / 2;
      final x1 = centerX + (radius - 40) * cos(handAngle);
      final y1 = centerY + (radius - 40) * sin(handAngle);
      final x2 = centerX + radius * cos(handAngle);
      final y2 = centerY + radius * sin(handAngle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), hourHandPaint);

      for (int j = 0; j < minuteHandCount; j++) {
        final minuteHandAngle = 2 * pi * j / minuteHandCount;
        final x3 = centerX + (radius - 10) * cos(minuteHandAngle);
        final y3 = centerY + (radius - 10) * sin(minuteHandAngle);
        final x4 = centerX + radius * cos(minuteHandAngle);
        final y4 = centerY + radius * sin(minuteHandAngle);

        canvas.drawLine(Offset(x3, y3), Offset(x4, y4), minuteHandPaint);
      }
    }
  }

  @override
  bool shouldRepaint(TimerHandPainter oldDelegate) => true;
}
