import 'package:get/get.dart';
import 'package:racing_math/old/controller/game_controller.dart';
import 'package:racing_math/old/controller/stopwatch/stopwatch_service.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StopwatchController());
    Get.put(GameController());
  }
}
