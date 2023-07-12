import 'package:flutter/material.dart';
import 'package:jintimer/screens/home_screen.dart';

void main() {
  runApp(const JinTimer());
}

class JinTimer extends StatelessWidget {
  const JinTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'jintimer',
      home: MyHomeScreen(),
    );
  }
}
