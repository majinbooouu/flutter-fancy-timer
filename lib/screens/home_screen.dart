import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jintimer/widget/watch_face.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

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
  final player = AudioPlayer();
  bool isDarkMode = false;
  Timer? _inactivityTimer; // Timer variable to track user inactivity

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(
        () {
          isRunning = false;
          totalSeconds = setSeconds;
          _timerString = format(totalSeconds);
          _playBellSound();
          Vibration.vibrate();
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
    player.stop();
    _resetInactivityTimer();
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
    player.stop();
    _resetInactivityTimer();
    isRunning ? timer.cancel() : ();
    setState(
      () {
        isRunning = false;
      },
    );
  }

  void onRefreshPressed() {
    timer.cancel();
    _resetInactivityTimer();
    setState(() {
      isRunning = false;
      longPressed = false;
      totalSeconds = setSeconds;
      _timerString = format(setSeconds);
    });
  }

  void _playBellSound() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(
      AssetSource('sounds/beep.wav'),
    );
  }

  // Function to reset the inactivity timer
  void _resetInactivityTimer() {
    _inactivityTimer?.cancel(); // Cancel the previous timer, if any
    _startInactivityTimer();
    isDarkMode = false; // Start a new timer
    print('turn off dark mode');
  }

  // Function to start the inactivity timer
  void _startInactivityTimer() {
    _inactivityTimer = Timer(const Duration(seconds: 10), () {
      // This function will be called after 10 seconds of inactivity
      // Put your desired function call or logic here to inform the user
      isDarkMode = true;
      print('turn on dark mode');
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _resetInactivityTimer();
          player.stop();
        });
      },
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          color: isDarkMode ? Colors.black : Colors.white,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.amber,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 6),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: TimerBackgroundPainter(
                            isDarkMode ? Colors.black : Colors.white),
                        size: const Size(300.0, 300.0),
                      ),
                      CustomPaint(
                        painter: TimeArcPainter(totalSeconds, isDarkMode),
                        size: const Size(300.0, 300.0),
                      ),
                      CustomPaint(
                        painter: TimerHandPainter(isDarkMode),
                        size: const Size(300.0, 300.0),
                      ),
                      Center(
                        child: GestureDetector(
                          onLongPress: () {
                            longPressed = true;
                            onRefreshPressed();
                          },
                          child: IconButton(
                            enableFeedback: true,
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  isDarkMode
                                      ? Colors.grey.shade400
                                      : Colors.black),
                            ),
                            splashRadius: 20,
                            splashColor: Colors.white,
                            onPressed:
                                isRunning ? onPausePressed : onStartPressed,
                            color: isDarkMode ? Colors.black : Colors.white,
                            icon: Icon(isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  // onPressed: () => _showTimerPicker(context),
                  onPressed: () {
                    player.stop();
                    onPausePressed();
                    _showTimerPicker(context);
                  },
                  child: Text(
                    _timerString,
                    style: TextStyle(
                      fontSize: 50.0,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
