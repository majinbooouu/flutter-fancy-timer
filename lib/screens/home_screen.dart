import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jintimer/widget/timer_bg_painter.dart';
import 'package:jintimer/widget/timer_hand_painter.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  int _remainingTime = 3600; // Initial time in seconds (1 hour)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingTime),
    );
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_remainingTime < 1) {
          timer.cancel();
        } else {
          _remainingTime--;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300.0,
          height: 300.0,
          child: Stack(
            children: [
              CustomPaint(
                painter: TimerBackgroundPainter(),
                size: const Size(300.0, 300.0),
              ),
              CustomPaint(
                painter: TimerHandPainter(
                  animation: StepTween(
                    begin: 0,
                    end: _remainingTime,
                  ).animate(_controller),
                ),
                size: const Size(300.0, 300.0),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _showTimePickerDialog(context);
                },
                child: const Text('Set Timer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showTimePickerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int selectedTime = _remainingTime;

      return AlertDialog(
        title: const Text('Set Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select the timer duration:'),
            const SizedBox(height: 16.0),
            FlutterTimerPicker(
              duration: Duration(seconds: selectedTime),
              onChange: (int value) {
                selectedTime = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _remainingTime = selectedTime;
                _controller.duration = Duration(seconds: _remainingTime);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Set'),
          ),
        ],
      );
    },
  );
}

class FlutterTimerPicker extends StatelessWidget {
  final Duration duration;
  final ValueChanged<int> onChange;

  const FlutterTimerPicker(
      {super.key, required this.duration, required this.onChange});

  @override
  Widget build(BuildContext context) {
    int selectedTime = duration.inSeconds;

    return SizedBox(
      height: 200.0,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        initialTimerDuration: duration,
        onTimerDurationChanged: (Duration changedDuration) {
          selectedTime = changedDuration.inSeconds;
        },
      ),
    );
  }
}
