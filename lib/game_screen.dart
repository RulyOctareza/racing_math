import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Inisialisasi langsung saat deklarasi
  late final AnimationController _timerController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _timerController,
    curve: Curves.linear,
  );

  List progress = [0.2, 0.4, 0.6, 0.8, 1];
  bool _isAnimating = false;

  List<String> numberPad = [
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

  int num1 = 0;
  int num2 = 0;
  String answer = '';

  int currentLap = 3; // Jumlah lap saat ini
  int questionsPerLap = 5; // Jumlah pertanyaan per lap
  int answeredQuestions = 0; // Jumlah pertanyaan yang telah dijawab
  int currentLevelIndex = 0; // Indeks level saat ini

  @override
  void initState() {
    super.initState();

    // Tambahkan listener untuk timer
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          Fluttertoast.showToast(
            msg: 'Waktu habis!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          generateQuestion(); // Generate pertanyaan baru
        });
      }
    });

    // Generate pertanyaan pertama dan mulai timer
    generateQuestion();
  }

  //mendapatkan durasi untuk setiap level
  int getLevelDuration(int levelIndex) {
    return 20 - (levelIndex * 3);
  }

  void generateQuestion() {
    setState(() {
      _isAnimating = true;
      num1 = Random().nextInt(10);
      num2 = Random().nextInt(10);
      answer = '';
    });

    // Reset dan mulai timer baru
    _timerController.reset();
    _timerController.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimating = false;
      });
    });
  }

  void checkAnswer() {
    int correctAnswer = num1 + num2;
    int userAnswer = int.tryParse(answer) ?? 0;

    if (answer.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Harap masukkan jawaban',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (userAnswer == correctAnswer) {
      Fluttertoast.showToast(
        msg: 'Jawaban benar!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      generateQuestion();
    } else {
      Fluttertoast.showToast(
        msg: 'Jawaban salah!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
      generateQuestion();
    }
  }

  void showNextLevelDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Level Selesai !'),
            content:
                const Text('Apakah anda Ingin lanjut ke Level selanjutnya ?'),
            actions: [
              TextButton(
                child: const Text('Tidak'),
                onPressed: () {},
              ),
              TextButton(
                child: const Text('Ya'),
                onPressed: () {},
              ),
            ],
          );
        });
  }

  void startNextLevel() {
    setState(() {
      currentLap = 3;
      currentLevelIndex++;
      answeredQuestions = 0;
      _timerController.duration =
          Duration(seconds: getLevelDuration(currentLevelIndex));
    });
    generateQuestion();
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Selesai'),
            content: const Text('Apakah anda ingin bermain kembali ?'),
            actions: [
              TextButton(onPressed: () {}, child: Text('Tidak')),
              TextButton(onPressed: () {}, child: Text('Ya'))
            ],
          );
        });
  }

  void resetGame() {
    setState(() {
      currentLevelIndex = 0; // for reset level
      currentLap = 3; // Reset lap to 3
      answeredQuestions = 0; // Reset the question
      _timerController.duration =
          Duration(seconds: getLevelDuration(currentLevelIndex));
    });
    generateQuestion(); //generate pertanyaan baru untuk permainan baru
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    //timer answer

    Widget buildBottomTimer() {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            child: LinearProgressIndicator(
              value: 1.0 - _animation.value,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 10,
            ),
          );
        },
      );
    }

    //widget numpad
    Widget buildNumberpad() {
      return Flexible(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // buat grid 3x4 untuk numpad
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: numberPad.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (numberPad[index] == 'DEL') {
                        setState(() {
                          if (answer.isNotEmpty) {
                            answer = answer.substring(0, answer.length - 1);
                          }
                        });
                      } else {
                        setState(() {
                          // Batasi panjang input maksimal 3 digit
                          if (answer.length < 3) {
                            answer += numberPad[index];
                          }
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2F41),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: numberPad[index] == 'DEL'
                            ? const Icon(
                                Icons.backspace_outlined,
                                color: Colors.white,
                                size: 24,
                              )
                            : Text(
                                numberPad[index],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    // widget answer
    Widget buildAnswerSection() {
      return SizedBox(
        height: 60,
        child: Stack(
          children: [
            // Container answer tetap di posisi
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.4,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.black45),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        answer,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: checkAnswer,
                      icon: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Container soal dengan animasi
            AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeIn,
              left: _isAnimating ? MediaQuery.of(context).size.width : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _isAnimating ? 0 : 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      '$num1 + $num2',
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // container to display progress indicator
              Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * progress[0],
                      decoration: const BoxDecoration(
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ],
                ),
              ),

              // container for upper of screen
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                height: 60,
                color: Colors.grey[600],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Row Icon use the Flexible to prohibit overflow in any device

                    //LEFT  & RESTART BUTTON
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_arrow_up,
                          size: 28,
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        onPressed: () {
                          generateQuestion();
                        },
                        icon: const Icon(
                          Icons.autorenew_rounded,
                          size: 22,
                        ),
                        color: Colors.white,
                      ),
                    ),

                    // TIME
                    const Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        '00:00',
                        style: TextStyle(fontSize: 35),
                      ),
                    ),

                    //LAPS
                    const Column(
                      children: [
                        Flexible(child: Text('0')),
                        Flexible(child: Text('Laps')),
                      ],
                    ),

                    //BUTTON RIGHT
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_arrow_right,
                          size: 28,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // CONTAINER FOR CANVAS SCREEN RACING
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(color: Colors.pink),
              ),

              // Row for answer and validation of answer
              buildAnswerSection(),

              // number pad
              Stack(
                children: [
                  buildNumberpad(),
                ],
              ),

              //timer
              buildBottomTimer(),
            ],
          ),
        ),
      ),
    );
  }
}
