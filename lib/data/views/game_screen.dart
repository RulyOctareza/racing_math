import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';
import 'package:racing_math/data/widgets/game_header.dart';
import 'package:racing_math/data/widgets/number_pad.dart';
import 'package:racing_math/data/widgets/progress_bar.dart';
import 'package:racing_math/data/widgets/question_display.dart';
import 'package:racing_math/data/widgets/race_track_widget.dart';
import 'package:racing_math/data/widgets/timer_progress.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar untuk level
            ProgressBar(),

            // Header dengan informasi game
            GameHeader(),

            // Area untuk game canvas (placeholder sementara)
            RaceTrack(),

            // Display pertanyaan dan input jawaban
            QuestionDisplay(),

            // Number pad untuk input
            NumberPad(),

            // Timer progress di bagian bawah
            TimerProgress(),
          ],
        ),
      ),
    );
  }
}
