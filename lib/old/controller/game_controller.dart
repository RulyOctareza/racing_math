// File: controllers/game_controller.dart

import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GameController extends GetxController with GetTickerProviderStateMixin {
  // Observable variables
  RxInt currentLap = 3.obs;
  RxInt currentLevelIndex = 0.obs;
  RxInt answeredQuestions = 0.obs;
  final RxInt questionsPerLap = 5.obs;
  final RxString answer = ''.obs;
  final RxBool isAnimating = false.obs;

  // Game variables
  final RxInt num1 = 0.obs;
  final RxInt num2 = 0.obs;

  // Progress list
  final List<double> progress = [0.2, 0.4, 0.6, 0.8, 1.0];

  // Number pad
  final List<String> numberPad = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    'DEL'
  ];

  // Timer controller
  late AnimationController timerController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    initializeTimerController();
    generateQuestion();
  }

  // Initialize timer controller
  void initializeTimerController() {
    timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: getLevelDuration(currentLevelIndex.value)),
    );

    animation = CurvedAnimation(
      parent: timerController,
      curve: Curves.linear,
    );

    timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.snackbar(
          'Waktu Habis!',
          'Silakan coba lagi',
          snackPosition: SnackPosition.BOTTOM,
        );
        generateQuestion();
      }
    });
  }

  // Get level duration
  int getLevelDuration(int levelIndex) {
    return 20 - (levelIndex * 3);
  }

  // Generate new question
  void generateQuestion() {
    isAnimating.value = true;
    num1.value = Random().nextInt(10);
    num2.value = Random().nextInt(10);
    answer.value = '';

    timerController.reset();
    timerController.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimating.value = false;
    });
  }

  // Handle number pad input
  void handleNumberPadInput(String value) {
    if (value == 'DEL') {
      if (answer.value.isNotEmpty) {
        answer.value = answer.value.substring(0, answer.value.length - 1);
      }
    } else {
      if (answer.value.length < 3) {
        answer.value += value;
      }
    }
  }

  // Check answer
  void checkAnswer() {
    int correctAnswer = num1.value + num2.value;
    int userAnswer = int.tryParse(answer.value) ?? -1;

    if (answer.value.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Harap masukkan jawaban',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (userAnswer == correctAnswer) {
      Get.snackbar(
        'Benar!',
        'Jawaban kamu benar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      answeredQuestions++;

      if (answeredQuestions.value == questionsPerLap.value) {
        currentLap--;
        answeredQuestions.value = 0;

        if (currentLap.value == 0) {
          timerController.stop();
          showNextLevelDialog();
          return;
        }
      }

      generateQuestion();
    } else {
      Get.snackbar(
        'Salah!',
        'Jawaban kamu salah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Show next level dialog
  void showNextLevelDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Level Selesai!'),
        content: const Text('Apakah anda ingin lanjut ke Level selanjutnya?'),
        actions: [
          TextButton(
            child: const Text('Tidak'),
            onPressed: () {
              Get.back();
              showGameOverDialog();
            },
          ),
          TextButton(
            child: const Text('Ya'),
            onPressed: () {
              Get.back();
              startNextLevel();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Start next level
  void startNextLevel() {
    currentLap.value = 3;
    currentLevelIndex++;
    answeredQuestions.value = 0;

    // Update timer duration for new level
    timerController.duration =
        Duration(seconds: getLevelDuration(currentLevelIndex.value));

    generateQuestion();
  }

  // Show game over dialog
  void showGameOverDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Game Selesai'),
        content: const Text('Apakah anda ingin bermain kembali?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Kembali ke menu utama
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              resetGame();
            },
            child: const Text('Ya'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Reset game
  void resetGame() {
    currentLevelIndex.value = 0;
    currentLap.value = 3;
    answeredQuestions.value = 0;
    timerController.duration =
        Duration(seconds: getLevelDuration(currentLevelIndex.value));
    generateQuestion();
  }

  @override
  void onClose() {
    timerController.dispose();
    super.onClose();
  }
}
