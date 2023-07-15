import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jintimer/widget/watch_face.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  static const twentyFiveMinutes = 3600;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
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
      totalSeconds = twentyFiveMinutes;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    var tranDuration = duration.toString().split('.').first.substring(2, 7);
    return tranDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(width: 5)),
              child: Column(
                children: [
                  WatchFace(
                    totalSeconds: totalSeconds,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    format(totalSeconds),
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 120,
                        color: Colors.black,
                        onPressed: isRunning ? onPausePressed : onStartPressed,
                        icon: Icon(isRunning
                            ? Icons.pause_circle_outline_outlined
                            : Icons.play_circle_outline_outlined),
                      ),
                      IconButton(
                        iconSize: 40,
                        color: Colors.black,
                        onPressed: onRefreshPressed,
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
