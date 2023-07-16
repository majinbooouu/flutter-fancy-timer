import 'package:flutter/material.dart';
import 'package:jintimer/screens/home_screen.dart';

void main() {
  runApp(const JinTimer());
}

class JinTimer extends StatelessWidget {
  const JinTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFE7626C),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color(0xFFF4EDDB),
      ),
      title: 'jintimer',
      home: const MyHomeScreen(),
    );
  }
}
