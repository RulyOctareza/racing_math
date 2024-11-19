// lib/features/game/services/game_service.dart

import 'package:get/get.dart';
import 'package:racing_math/old/models.dart/game_state.dart';
import 'package:racing_math/old/models.dart/questions.dart';

class GameService extends GetxService {
  final gameState = GameState();
  final Rx<Question> currentQuestion = Question(number1: 0, number2: 0).obs;

  // Generate new question
  void generateQuestion() {
    currentQuestion.value = Question.generateRandom();
    gameState.isAnimating.value = true;

    // Reset animation after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      gameState.isAnimating.value = false;
    });
  }

  // Handle answer validation
  bool validateAnswer(String answer) {
    if (answer.isEmpty) return false;
    return currentQuestion.value.checkAnswer(answer);
  }

  // Update game progress
  void updateProgress() {
    gameState.answeredQuestions.value++;

    if (gameState.answeredQuestions.value == GameState.questionsPerLap) {
      gameState.currentLap.value--;
      gameState.answeredQuestions.value = 0;

      if (gameState.currentLap.value == 0) {
        gameState.isPlaying.value = false;
        return;
      }
    }

    generateQuestion();
  }

  // Start next level
  void startNextLevel() {
    gameState.currentLevel.value++;
    gameState.currentLap.value = GameState.initialLaps;
    gameState.answeredQuestions.value = 0;
    gameState.isPlaying.value = true;
    generateQuestion();
  }

  // Reset game
  void resetGame() {
    gameState.reset();
    generateQuestion();
  }
}
