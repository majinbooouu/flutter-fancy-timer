import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jintimer/widget/watch_face.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  static const twentyFiveMinutes = 500;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  bool longPressed = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(
        () {
          isRunning = false;
          totalSeconds = twentyFiveMinutes;
        },
      );
      timer.cancel();
    } else {
      setState(
        () {
          totalSeconds = totalSeconds - 1;
        },
      );
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(
      () {
        isRunning = true;
      },
    );
  }

  void onPausePressed() {
    timer.cancel();
    setState(
      () {
        isRunning = false;
      },
    );
  }

  void onRefreshPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      longPressed = false;
      totalSeconds = twentyFiveMinutes;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    var tranDuration = duration.toString().split('.').first.substring(2, 7);
    return tranDuration;
  }

  IconData? iconn(bool isRunning, bool longPressed) {
    IconData a = Icons.play_circle_outline_outlined;
    if (longPressed) {
      a = Icons.play_circle_outline_outlined;
    } else {
      if (isRunning) {
        a = Icons.pause_circle_outline_outlined;
      }
    }
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(width: 6),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: TimerBackgroundPainter(Colors.white),
                    size: const Size(300.0, 300.0),
                  ),
                  CustomPaint(
                    painter: TimeArcPainter(totalSeconds),
                    size: const Size(300.0, 300.0),
                  ),
                  CustomPaint(
                    painter: TimerHandPainter(),
                    size: const Size(300.0, 300.0),
                  ),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 20,
                      child: GestureDetector(
                        onLongPress: () {
                          longPressed = true;
                          onRefreshPressed();
                          print('long');
                        },
                        child: IconButton(
                          onPressed:
                              isRunning ? onPausePressed : onStartPressed,
                          color: Colors.white,
                          icon: Icon(isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded),
                          style: const ButtonStyle(
                              iconColor:
                                  MaterialStatePropertyAll(Colors.amber)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Container(
            //   decoration: const BoxDecoration(color: Colors.amber),
            //   child: Text(
            //     format(totalSeconds),
            //     style:
            //         const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
