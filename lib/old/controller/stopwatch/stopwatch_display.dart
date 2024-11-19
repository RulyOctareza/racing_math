// File: widgets/stopwatch_display.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/old/controller/stopwatch/stopwatch_service.dart';

class StopwatchDisplay extends GetView<StopwatchController> {
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;

  const StopwatchDisplay({
    super.key,
    this.fontSize = 35,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        controller.elapsedTime,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
