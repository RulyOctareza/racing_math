import 'package:get/get.dart';
import 'package:racing_math/data/controllers/game_controller.dart';
import 'package:racing_math/data/controllers/race_controller.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameController());
    Get.put(RaceTrackController());
  }
}
