import 'dart:math';

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

  bool checkAnswer(String userAnswer) {
    final parsedAnswer = int.tryParse(userAnswer);
    return parsedAnswer != null && parsedAnswer == correctAnswer;
  }

  static Question generateRandom() {
    final random = Random();
    return Question(
      number1: random.nextInt(10),
      number2: random.nextInt(10),
    );
  }
}
