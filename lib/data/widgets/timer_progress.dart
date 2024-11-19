import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';

class TimerProgress extends GetView<GameController> {
  const TimerProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.timerAnimation,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height: 10,
          child: LinearProgressIndicator(
            value: 1.0 - controller.timerAnimation.value,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        );
      },
    );
  }
}
