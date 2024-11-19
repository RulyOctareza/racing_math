import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';

class QuestionDisplay extends GetView<GameController> {
  const QuestionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          // Answer Container
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 0.4,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black45,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => Text(
                          controller.userAnswer.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  IconButton(
                    onPressed: controller.checkAnswer,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Question Container with Animation
          Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeIn,
                left: controller.gameState.isAnimating.value
                    ? MediaQuery.of(context).size.width
                    : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: controller.gameState.isAnimating.value ? 0 : 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Obx(() => Text(
                            controller.currentQuestion.value.toString(),
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
