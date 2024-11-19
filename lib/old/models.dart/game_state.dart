import 'package:get/get.dart';

class GameState {
  // Observable state variables
  final RxInt currentLevel = 0.obs;
  final RxInt currentLap = 3.obs;
  final RxInt answeredQuestions = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxBool isAnimating = false.obs;

  // Game configuration
  static const int initialLaps = 3;
  static const int questionsPerLap = 5;
  static const int baseDuration = 20; // Base duration for timer in seconds
  static const int durationDecrement =
      3; // How much to decrease timer per level

  // Progress tracking
  final List<double> progressSteps = [0.2, 0.4, 0.6, 0.8, 1.0];

  // Calculate timer duration for current level
  int getTimerDuration() {
    return baseDuration - (currentLevel.value * durationDecrement);
  }

  // Reset game state
  void reset() {
    currentLevel.value = 0;
    currentLap.value = initialLaps;
    answeredQuestions.value = 0;
    isPlaying.value = false;
    progress.value = 0.0;
    isAnimating.value = false;
  }
}
