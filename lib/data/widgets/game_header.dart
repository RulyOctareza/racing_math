// lib/features/game/views/widgets/game_header.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';

class GameHeader extends GetView<GameController> {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: 60,
      color: Colors.grey[600],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Button
          Flexible(
            child: IconButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 28,
              ),
              color: Colors.white,
            ),
          ),

          // Reset Button
          Flexible(
            child: IconButton(
              onPressed: controller.resetGame,
              icon: const Icon(
                Icons.autorenew_rounded,
                size: 22,
              ),
              color: Colors.white,
            ),
          ),

          // Timer Display
          Flexible(
            fit: FlexFit.tight,
            child: Obx(() => Text(
                  controller.gameTime.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),

          // Lap Counter
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    '${controller.gameState.currentLap}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const Text(
                'Laps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}