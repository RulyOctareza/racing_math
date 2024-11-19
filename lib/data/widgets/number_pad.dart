import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';

class NumberPad extends GetView<GameController> {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.numberPad.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => controller.handleNumberPadInput(
                controller.numberPad[index],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2F41),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: controller.numberPad[index] == 'DEL'
                      ? const Icon(
                          Icons.backspace_outlined,
                          color: Colors.white,
                          size: 24,
                        )
                      : Text(
                          controller.numberPad[index],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
