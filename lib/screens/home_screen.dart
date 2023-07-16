import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jintimer/widget/watch_face.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  static const initialTime = 300;
  String _timerString = '05:00';
  int totalSeconds = initialTime;
  int setSeconds = initialTime;
  bool isRunning = false;
  bool longPressed = false;
  bool fistRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(
        () {
          isRunning = false;
          totalSeconds = setSeconds;
          _timerString = format(totalSeconds);
        },
      );
      timer.cancel();
    } else {
      setState(
        () {
          totalSeconds = totalSeconds - 1;
          _timerString = format(totalSeconds);
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
    isRunning = true;
  }

  void onPausePressed() {
    isRunning ? timer.cancel() : ();
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
      totalSeconds = setSeconds;
      _timerString = format(setSeconds);
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    var tranDuration = duration.toString().split('.').first.substring(2, 7);
    return tranDuration;
  }

//
  Future<void> _showTimerPicker(BuildContext context) async {
    // Duration selectedDuration = Duration.zero;
    Duration selectedDuration = Duration(seconds: totalSeconds);

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300.0,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.ms,
            initialTimerDuration: selectedDuration,
            onTimerDurationChanged: (Duration duration) {
              setState(() {
                HapticFeedback.selectionClick();
                selectedDuration = duration;
                _timerString = _formatDuration(selectedDuration);
                totalSeconds = duration.inSeconds;
                setSeconds = duration.inSeconds;
              });
            },
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

//

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
                        },
                        child: IconButton(
                          onPressed:
                              isRunning ? onPausePressed : onStartPressed,
                          color: Colors.white,
                          icon: Icon(isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              // onPressed: () => _showTimerPicker(context),
              onPressed: () {
                onPausePressed();
                _showTimerPicker(context);
              },
              child: Text(
                _timerString,
                style: const TextStyle(
                  fontSize: 72.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
