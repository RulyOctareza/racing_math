import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/old/controller/game_controller.dart';

class AnswerSection extends GetView<GameController> {
  const AnswerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          // Answer container
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Obx(
                      () => Text(
                        controller.answer.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.checkAnswer,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                  )
                ],
              ),
            ),
          ),

          // Question container with animation
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeIn,
              left: controller.isAnimating.value
                  ? MediaQuery.of(context).size.width
                  : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: controller.isAnimating.value ? 0 : 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        '${controller.num1.value} + ${controller.num2.value}',
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
