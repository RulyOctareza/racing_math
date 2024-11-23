// lib/features/game/views/widgets/race_track.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/race_controller.dart';
import 'package:racing_math/data/views/race_track.dart';

class RaceTrack extends GetView<RaceTrackController> {
  const RaceTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      color: Colors.black,
      child: Obx(
        () => CustomPaint(
          painter: RaceTrackPainter(
            playerPosition: controller.playerPosition.value,
            computerPosition: controller.computerPosition.value,
            questionsAnswered: controller.answeredQuestions.value,
          ),
          child: Container(),
        ),
      ),
    );
  }
}
