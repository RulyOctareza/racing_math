import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';
import 'package:racing_math/data/views/game_screen.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 3;
  final GameController gameController = Get.find<GameController>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        if (_count > 1) {
          setState(() {
            _count--;
          });
          _controller.reset();
          _controller.forward();
        } else {
          // Start game setelah countdown selesai
          Get.off(
            () => const GameScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          )?.then((_) {
            // Mulai game setelah transisi selesai
            gameController.startGame();
          });
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Animasi scale untuk angka countdown
            return Transform.scale(
              scale: 1.0 + (_controller.value * 0.3),
              child: Opacity(
                opacity: 1.0 - _controller.value,
                child: Text(
                  _count.toString(),
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
