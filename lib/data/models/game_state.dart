// lib/data/models/game_state.dart

import 'dart:math';

import 'package:get/get.dart';

class GameState {
  // Game state
  final RxInt currentLevel = 0.obs;
  final RxInt currentLap = 3.obs;
  final RxInt answeredQuestions = 0.obs;
  final RxInt score = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isAnimating = false.obs;

  // Constants
  static const int maxLevel = 3; // Game selesai setelah 3 level
  static const int questionsPerLap = 5;
  static const int initialLaps = 3;
  static const int baseTimerDuration = 20;
  static const int timerDecrementPerLevel = 3;

  // Progress tracking
  final List<double> progressSteps = [0.2, 0.4, 0.6, 0.8, 1.0];

  // Method untuk mendapatkan durasi timer berdasarkan level
  int getTimerDuration() {
    return baseTimerDuration - (currentLevel.value * timerDecrementPerLevel);
  }

  // Method untuk cek apakah game selesai
  bool isGameComplete() {
    return currentLevel.value >= maxLevel;
  }

  // Method untuk calculate score
  void updateScore(int timeRemaining) {
    // Score dihitung berdasarkan kecepatan menjawab
    // Semakin cepat menjawab, semakin tinggi score
    score.value += (timeRemaining * 10);
  }

  // Reset game state
  void reset() {
    currentLevel.value = 0;
    currentLap.value = initialLaps;
    answeredQuestions.value = 0;
    score.value = 0;
    isPlaying.value = false;
    isAnimating.value = false;
  }
}

// lib/data/models/question.dart

class Question {
  final int number1;
  final int number2;
  final int correctAnswer;

  Question({
    required this.number1,
    required this.number2,
  }) : correctAnswer = number1 + number2;

  @override
  String toString() => '$number1 + $number2';

  static Question generateRandom() {
    final random = Random();
    return Question(
      number1: random.nextInt(10),
      number2: random.nextInt(10),
    );
  }
}
