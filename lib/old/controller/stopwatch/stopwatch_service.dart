// File: controllers/stopwatch_controller.dart

import 'dart:async';
import 'package:get/get.dart';

class StopwatchController extends GetxController {
  // Observable variables
  final _elapsedTime = '00:00'.obs;
  final _isGameRunning = false.obs;

  // Private variables
  late Stopwatch _gameStopwatch;
  Timer? _stopwatchTimer;

  // Getters
  String get elapsedTime => _elapsedTime.value;
  bool get isGameRunning => _isGameRunning.value;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  // Initialize stopwatch
  void initialize() {
    _gameStopwatch = Stopwatch();
    _elapsedTime.value = '00:00';
    _isGameRunning.value = false;
  }

  // Format elapsed time
  String _formatElapsedTime(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  // Start stopwatch
  void startStopwatch() {
    if (!_isGameRunning.value) {
      _isGameRunning.value = true;
      _gameStopwatch.start();

      _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedTime.value =
            _formatElapsedTime(_gameStopwatch.elapsedMilliseconds);
      });
    }
  }

  // Stop stopwatch
  void stopStopwatch() {
    _isGameRunning.value = false;
    _gameStopwatch.stop();
    _stopwatchTimer?.cancel();
    _stopwatchTimer = null;
  }

  // Reset stopwatch
  void resetStopwatch() {
    _isGameRunning.value = false;
    _elapsedTime.value = '00:00';
    _stopwatchTimer?.cancel();
    _stopwatchTimer = null;

    if (_gameStopwatch.isRunning) {
      _gameStopwatch.stop();
    }
    _gameStopwatch.reset();
  }

  // Get current elapsed time
  String getCurrentTime() {
    return _elapsedTime.value;
  }

  @override
  void onClose() {
    _stopwatchTimer?.cancel();
    _gameStopwatch.stop();
    _isGameRunning.value = false;
    super.onClose();
  }
}
