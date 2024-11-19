import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';

class ProgressBar extends GetView<GameController> {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.blue[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Container(
                height: 20,
                width: MediaQuery.of(context).size.width *
                    controller.gameState
                        .progressSteps[controller.gameState.currentLevel.value],
                decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
                ),
              )),
        ],
      ),
    );
  }
}
