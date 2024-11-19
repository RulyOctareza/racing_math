// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racing_math/data/bindings/game_bindings.dart';
import 'package:racing_math/data/views/game_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Racing Math Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: GameBinding(),
      home: const GameScreen(),
      getPages: [
        GetPage(
          name: '/game',
          page: () => const GameScreen(),
          binding: GameBinding(),
        ),
      ],
    );
  }
}
