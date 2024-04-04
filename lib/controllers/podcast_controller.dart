import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class PodcastController extends GetxController {
  Rx<bool> isRecorded = false.obs;
  Rx<bool> isPaused = false.obs;
  Rx<bool> startPage = true.obs;
  Rx<bool> isButtonActive = false.obs;
  Rx<String> currentPodcastFilePath = "".obs;
  Rx<String> podcastName = "".obs;
  RxMap<String, bool> selectedCategories = <String, bool>{}.obs;
  Rx<String> podcastAbout = "".obs;
  Rx<String> episodeName = "".obs;
  Rx<String> episodeAbout = "".obs;
  Rx<File> podcastImageFile = File("").obs;
  Rx<File> podcastEpisodeImageFile = File("").obs;
  Duration recordTime = Duration.zero;
  String recordTimeString = "";
  late Timer timer;
  final AudioPlayer audioPlayer = AudioPlayer();
  final record = AudioRecorder();

  Future<void> selectPodcastPhoto() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(pickedFile!.path.toString());
    if (pickedFile != null) {
      try {
        podcastImageFile.value = File(pickedFile.path);
        print(podcastImageFile.value);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> selectEpisodePhoto() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(pickedFile!.path.toString());
    if (pickedFile != null) {
      try {
        podcastEpisodeImageFile.value = File(pickedFile.path);
        print(podcastImageFile.value);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> startPodcastRecord() async {
    if (await record.hasPermission()) {
      Directory? directory = await getExternalStorageDirectory();
      String path = directory!.path;

      String soundFilePath =
          '$path/${DateTime.now().millisecondsSinceEpoch}.m4a';
      print(soundFilePath);
      // Start recording to file
      await record.start(const RecordConfig(), path: soundFilePath);

      currentPodcastFilePath.value = soundFilePath;
      isRecorded.value = !isRecorded.value;
    }
  }

  Future<void> pauseCheckRecord() async {
    isPaused.value = !isPaused.value;
    if ((await record.isPaused())) {
      await record.resume();
    } else {
      await record.pause();
    }
  }

  Future<void> stopPodcastRecord() async {
    String? soundFilePath = await record.stop();
    print(soundFilePath);
    timer.cancel();
    recordTime = Duration.zero;
    recordTimeString = "";

    isRecorded.value = !isRecorded.value;

    audioPlayer.setFilePath(soundFilePath!);

    Get.back();
  }

  Future<void> deletePodcastRecord() async {
    await record.dispose();
    isRecorded.value = false;
    currentPodcastFilePath.value = "";
    Get.back();
  }

  // dosya seçimi için filepicker kullandık
  Future<void> selectPodcastFile() async {
    try {
      // seçilen dosyalarla ilgili işlemler için fonksiyonun içine giriyoruz.
      var result = await FilePicker.platform.pickFiles(type: FileType.audio);

      if (result != null) {
        currentPodcastFilePath.value = (result.files.single.path!).toString();
        print(currentPodcastFilePath.value.toString());
        audioPlayer.setFilePath(currentPodcastFilePath.value);
      } else {}
    } catch (e) {}
  }
}
