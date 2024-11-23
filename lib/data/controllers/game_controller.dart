import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/race_controller.dart';
import 'package:racing_math/data/models/game_state.dart';

class GameController extends GetxController with GetTickerProviderStateMixin {
  // Game State
  final gameState = GameState();
  final Rx<Question> currentQuestion = Question(number1: 0, number2: 0).obs;
  final RxString userAnswer = ''.obs;

  // final RaceTrackController raceTrackController =
  //     Get.find<RaceTrackController>();

  // Timer State
  final RxString gameTime = '00:00'.obs;
  final RxDouble progressValue = 0.0.obs;
  final RxBool isTimerRunning = false.obs;

  Timer? gameTimer;
  final stopwatch = Stopwatch();

  // Animation controllers
  late final AnimationController timerController;
  late final Animation<double> timerAnimation;

  // Numpad configuration
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

  @override
  void onInit() {
    super.onInit();
    _initializeTimerAnimation();
    startGame();
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

    // Update progress value for UI
    timerController.addListener(() {
      progressValue.value = timerController.value;
    });

    timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        handleTimeUp();
      }
    });
  }

  void startGameTimer() {
    if (!isTimerRunning.value) {
      isTimerRunning.value = true;
      stopwatch.start();

      // Optimized timer dengan interval 100ms
      gameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (stopwatch.isRunning) {
          _updateGameTime();
        }
      });
    }
  }

  void _updateGameTime() {
    int milliseconds = stopwatch.elapsedMilliseconds;
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;

    // Update hanya jika nilai berubah
    String newTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    if (gameTime.value != newTime) {
      gameTime.value = newTime;
    }
  }

  void pauseGameTimer() {
    isTimerRunning.value = false;
    stopwatch.stop();
    gameTimer?.cancel();
    timerController.stop();
  }

  void resumeGameTimer() {
    isTimerRunning.value = true;
    stopwatch.start();
    timerController.forward();
    startGameTimer();
  }

  void resetGameTimer() {
    stopwatch.reset();
    timerController.reset();
    gameTime.value = '00:00';
    progressValue.value = 0.0;
    generateNewQuestion();
  }

  @override
  void onClose() {
    gameTimer?.cancel();
    stopwatch.stop();
    timerController.dispose();
    super.onClose();
  }

  // Game Logic Methods
  void startGame() {
    // _initializeTimerAnimation();
    gameState.isPlaying.value = true;
    startGameTimer();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    gameState.isAnimating.value = true;
    currentQuestion.value = Question.generateRandom();
    userAnswer.value = '';

    timerController.reset();
    timerController.forward();

    // Mengurangi delay animasi
    Future.delayed(const Duration(milliseconds: 500), () {
      gameState.isAnimating.value = false;
    });
  }

  void handleNumberPadInput(String value) {
    if (!isTimerRunning.value) return; // Prevent input when timer is paused

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
    if (!isTimerRunning.value) return;

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
    final raceTrackController = Get.find<RaceTrackController>();
    raceTrackController.boostSpeed();

    // Calculate score based on remaining time
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
      duration: const Duration(seconds: 1),
    );
    generateNewQuestion();
  }

  void handleTimeUp() {
    // raceTrackController.setSlowSpeed();

    // Get.snackbar(
    //   'Waktu Habis!',
    //   'Silakan coba lagi',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 1),
    // );
    generateNewQuestion();
  }

  void showNextLevelDialog() {
    pauseGameTimer();
    Get.dialog(
      AlertDialog(
        title: const Text('Level Selesai!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: ${gameState.score.value}'),
            const SizedBox(height: 5),
            Text('Waktu: ${gameTime.value}'),
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
            child: const Text('Level Berikutnya'),
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
    pauseGameTimer();
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

    // raceTrackController.resetForNewLevel();

    timerController.duration = Duration(seconds: gameState.getTimerDuration());
    resumeGameTimer();
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
