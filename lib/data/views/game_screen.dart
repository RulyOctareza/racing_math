import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';
import 'package:racing_math/data/widgets/game_header.dart';
import 'package:racing_math/data/widgets/number_pad.dart';
import 'package:racing_math/data/widgets/progress_bar.dart';
import 'package:racing_math/data/widgets/question_display.dart';
import 'package:racing_math/data/widgets/timer_progress.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar untuk level
            const ProgressBar(),

            // Header dengan informasi game
            const GameHeader(),

            // Area untuk game canvas (placeholder sementara)
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              color: Colors.grey[800],
              // TODO: Implement game canvas
            ),

            // Display pertanyaan dan input jawaban
            const QuestionDisplay(),

            // Number pad untuk input
            const NumberPad(),

            // Timer progress di bagian bawah
            const TimerProgress(),
          ],
        ),
      ),
    );
  }
}
