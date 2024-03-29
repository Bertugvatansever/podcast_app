import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PodcastController extends GetxController {
  Rx<bool> isRecorded = false.obs;
  Rx<bool> isPaused = false.obs;
  Rx<String> currentPodcastFilePath = "".obs;
  final AudioPlayer audioPlayer = AudioPlayer(); // Create a player
}
