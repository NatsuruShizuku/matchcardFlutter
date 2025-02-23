import 'dart:async';

import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int seconds;

  const TimerDisplay({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Text(
      'เวลาที่ใช้: $seconds วินาที',
      style: const TextStyle(fontSize: 18),
    );
  }
}

class TimerController {
  final ValueNotifier<int> seconds = ValueNotifier(0);
  late Timer _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value++;
    });
  }

  void stopTimer() {
    _timer.cancel();
  }
}