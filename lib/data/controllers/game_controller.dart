// lib/features/game/controllers/game_controller.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/models/game_state.dart';

class GameController extends GetxController with GetTickerProviderStateMixin {
  // State
  final gameState = GameState();
  final Rx<Question> currentQuestion = Question(number1: 0, number2: 0).obs;
  final RxString userAnswer = ''.obs;

  // Animation controllers
  late final AnimationController timerController;
  late final Animation<double> timerAnimation;

  // Numpad
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

  // Timer variables
  final RxString gameTime = '00:00'.obs;
  Timer? gameTimer;
  final stopwatch = Stopwatch();

  @override
  void onInit() {
    super.onInit();
    _initializeTimerAnimation();
    startGame();
  }

  void startGame() {
    gameState.isPlaying.value = true;
    startGameTimer();
    generateNewQuestion();
  }

  void startGameTimer() {
    stopwatch.start();
    gameTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      updateGameTime();
    });
  }

  void updateGameTime() {
    int milliseconds = stopwatch.elapsedMilliseconds;
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;

    gameTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void pauseGameTimer() {
    stopwatch.stop();
    gameTimer?.cancel();
  }

  void resetGameTimer() {
    generateNewQuestion();
  }

  @override
  void onClose() {
    gameTimer?.cancel();
    stopwatch.stop();
    timerController.dispose();
    super.onClose();
  }

  void _initializeTimerAnimation() {
    timerController = AnimationController(
      vsync: this,
       duration: Duration(seconds: gameState.getTimerDuration()),
    );

    timerAnimation = CurvedAnimation(
      parent: timerController,
      curve: Curves.linear,
    );
    

    timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        handleTimeUp();
      }
    });
  }

  void generateNewQuestion() {
    gameState.isAnimating.value = true;
    currentQuestion.value = Question.generateRandom();
    userAnswer.value = '';

    timerController.reset();
    timerController.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      gameState.isAnimating.value = false;
    });
  }

  void handleNumberPadInput(String value) {
    if (value == 'DEL') {
      if (userAnswer.value.isNotEmpty) {
        userAnswer.value =
            userAnswer.value.substring(0, userAnswer.value.length - 1);
      }
    } else if (userAnswer.value.length < 3) {
      userAnswer.value += value;
    }
  }

  void checkAnswer() {
    if (userAnswer.value.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Harap masukkan jawaban',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    int? answer = int.tryParse(userAnswer.value);
    if (answer == currentQuestion.value.correctAnswer) {
      handleCorrectAnswer();
    } else {
      handleWrongAnswer();
    }
  }

  void handleCorrectAnswer() {
    // Update score berdasarkan sisa waktu
    int timeRemaining =
        (timerController.duration!.inSeconds * (1 - timerController.value))
            .round();
    gameState.updateScore(timeRemaining);

    gameState.answeredQuestions.value++;

    if (gameState.answeredQuestions.value == GameState.questionsPerLap) {
      gameState.currentLap.value--;
      gameState.answeredQuestions.value = 0;

      if (gameState.currentLap.value == 0) {
        if (gameState.isGameComplete()) {
          showGameCompleteDialog();
          return;
        }
        showNextLevelDialog();
        return;
      }
    }

    generateNewQuestion();
  }

  void handleWrongAnswer() {
    Get.snackbar(
      'Salah!',
      'Jawaban kamu salah',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    generateNewQuestion();
  }

  void handleTimeUp() {
    Get.snackbar(
      'Waktu Habis!',
      'Silakan coba lagi',
      snackPosition: SnackPosition.BOTTOM,
    );
    generateNewQuestion();
  }

  void showNextLevelDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Level Selesai!'),
        content: const Text('Lanjut ke level berikutnya?'),
        actions: [
          TextButton(
            child: const Text('Tidak'),
            onPressed: () {
              Get.back();
              showGameCompleteDialog();
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

  void showGameCompleteDialog() {
    pauseGameTimer(); // Pause the timer when game is complete
    Get.dialog(
      AlertDialog(
        title: const Text('Game Selesai!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selamat! Kamu telah menyelesaikan game!'),
            const SizedBox(height: 10),
            Obx(() => Text('Score: ${gameState.score.value}')),
            const SizedBox(height: 5),
            Obx(() => Text('Waktu: ${gameTime.value}')),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Menu Utama'),
            onPressed: () {
              Get.back();
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Main Lagi'),
            onPressed: () {
              Get.back();
              resetGame();
              resetGameTimer();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void startNextLevel() {
    gameState.currentLevel.value++;
    gameState.currentLap.value = GameState.initialLaps;
    gameState.answeredQuestions.value = 0;

    // Update timer duration untuk level baru
    timerController.duration = Duration(seconds: gameState.getTimerDuration());

    generateNewQuestion();
  }

  void resetGame() {
    gameState.reset();
    resetGameTimer();
    startGameTimer();
    timerController.duration = Duration(seconds: gameState.getTimerDuration());
    startGame();
  }
}
