// lib/features/game/controllers/race_track_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class RaceTrackController extends GetxController {
  // Posisi mobil (0.0 - 1.0)
  final RxDouble playerPosition = 0.0.obs;
  final RxDouble computerPosition = 0.0.obs;

  // Lap counter
  final RxInt playerLaps = 0.obs;
  final RxInt computerLaps = 0.obs;
  // Questions per lap counter
  final RxInt answeredQuestions = 0.obs;

  // Kecepatan dasar (dalam unit per frame)
  static const double baseSpeed =
      0.001; // Faktor pengali untuk menyesuaikan kecepatan

  // Kecepatan aktual
  final RxDouble currentPlayerSpeed =
      (0.8 * baseSpeed).obs; // Default normal speed
  final double computerSpeed = 1 * baseSpeed; // Konstan

  final RxBool isGameOver = false.obs;
  Timer? _gameTimer;
  Timer? _speedResetTimer;

  @override
  void onInit() {
    super.onInit();
    startRace();
  }

  void startNextLevel() {
    resetGameState();
    // Tambah kesulitan di level berikutnya
    // Misalnya: computer speed bisa ditingkatkan
  }

  void startRace() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      // Update computer position
      computerPosition.value += computerSpeed;
      if (computerPosition.value >= 1.0) {
        computerPosition.value = 0.0;
        computerLaps.value++;

        // Check if computer wins
        if (computerLaps.value >= 3) {
          isGameOver(false); // false = player lost
        }
      }

      // Update player position
      playerPosition.value += currentPlayerSpeed.value;
      if (playerPosition.value >= 1.0) {
        playerPosition.value = 0.0;
        playerLaps.value++;

        // Check if player completed all questions and laps
        if (playerLaps.value >= 3 && answeredQuestions.value >= 9) {
          isGameOver(true); // true = player won
        }
      }
    });
  }

  void gameOver(bool playerWon) {
    isGameOver.value = true;
    _gameTimer?.cancel();
    _speedResetTimer?.cancel();

    if (playerWon) {
      Get.dialog(
        AlertDialog(
          title: const Text('Selamat!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Anda menyelesaikan level ini!'),
              Text('Total Pertanyaan: ${answeredQuestions.value}'),
              Text('Lap Selesai: ${playerLaps.value}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                startNextLevel();
              },
              child: const Text('Level Selanjutnya'),
            ),
          ],
        ),
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Game Over'),
          content: const Text('Computer menang! Coba lagi?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                resetGame();
              },
              child: const Text('Main Lagi'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Keluar'),
            ),
          ],
        ),
      );
    }
  }

  // Dipanggil ketika jawaban benar
  void boostSpeed() {
    _speedResetTimer?.cancel();
    currentPlayerSpeed.value = 1.2 * baseSpeed;

    _speedResetTimer = Timer(const Duration(seconds: 2), () {
      setNormalSpeed();
    });
  }

  // Dipanggil ketika timer habis/tidak menjawab
  void setSlowSpeed() {
    _speedResetTimer?.cancel();
    currentPlayerSpeed.value = 0.6 * baseSpeed;
  }

  // Kembali ke kecepatan normal
  void setNormalSpeed() {
    currentPlayerSpeed.value = 0.8 * baseSpeed;
  }

  // Reset untuk level baru
  void resetForNewLevel() {
    playerPosition.value = 0.0;
    computerPosition.value = 0.0;
    setNormalSpeed();
  }

  void handleCorrectAnswer() {
    answeredQuestions.value++;
    boostSpeed();
  }

  void resetGame() {
    resetGameState();
    startRace();
  }

  void resetGameState() {
    playerPosition.value = 0.0;
    computerPosition.value = 0.0;
    playerLaps.value = 0;
    computerLaps.value = 0;
    answeredQuestions.value = 0;
    isGameOver.value = false;
    setNormalSpeed();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _speedResetTimer?.cancel();
    super.onClose();
  }
}
