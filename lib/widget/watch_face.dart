import 'package:flutter/material.dart';
import 'dart:math';

class WatchFace extends StatelessWidget {
  final int totalSeconds;
  final bool isDarkMode;
  const WatchFace({
    super.key,
    required this.totalSeconds,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(width: 6),
      ),
      child: Stack(
        children: [
          CustomPaint(
            painter: TimerBackgroundPainter(Colors.white),
            size: const Size(300.0, 300.0),
          ),
          CustomPaint(
            painter: TimeArcPainter(totalSeconds, isDarkMode),
            size: const Size(300.0, 300.0),
          ),
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 20,
              child: IconButton(
                onPressed: () {},
                color: Colors.white,
                icon: const Icon(Icons.play_arrow_rounded),
              ),
            ),
          ),
          CustomPaint(
            painter: TimerHandPainter(isDarkMode),
            size: const Size(300.0, 300.0),
          ),
        ],
      ),
    );
  }
}

class TimeArcPainter extends CustomPainter {
  final int totalSeconds;
  final bool isDarkMode;

  TimeArcPainter(
    this.totalSeconds,
    this.isDarkMode,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Rect myRect = const Offset(0.0, 0.0) & const Size(248, 248);
    final Paint paint = Paint()
      ..color = isDarkMode
          ? Colors.red.shade900.withOpacity(0.95)
          : Colors.redAccent.shade400.withOpacity(0.95)
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
    const centerX = 124.0;
    const centerY = 124.0;
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(centerX, centerY), radius, backgroundPaint);
  }

  @override
  bool shouldRepaint(TimerBackgroundPainter oldDelegate) => false;
}

class TimerHandPainter extends CustomPainter {
  final Animation<int>? animation;
  final bool isDarkMode;

  TimerHandPainter(this.isDarkMode, {this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final hourHandPaint = Paint()
      ..color = isDarkMode ? Colors.grey.shade400 : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final minuteHandPaint = Paint()
      ..color = isDarkMode ? Colors.grey.shade400 : Colors.black
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
