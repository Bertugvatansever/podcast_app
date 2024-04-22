import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/services/podcast_services.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

class PodcastController extends GetxController {
  PodcastService _podcastService = PodcastService();
  Rx<bool> isRecorded = false.obs;
  Rx<bool> isPaused = false.obs;
  Rx<bool> startPage = true.obs;
  Rx<bool> isButtonActive = false.obs;
  Rx<bool> isDownloadedPodcast = false.obs;
  Rx<String> currentPodcastFilePath = "".obs;
  Rx<String> podcastName = "".obs;
  RxMap<String, bool> selectedCategories = <String, bool>{}.obs;
  Rx<String> podcastAbout = "".obs;
  Rx<String> episodeName = "".obs;
  Rx<String> episodeAbout = "".obs;
  RxList<Podcast> continuePodcastList = <Podcast>[].obs;
  RxList<Episode> continuePodcastEpisodeList = <Episode>[].obs;

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

  Future<bool> uploadPodcast(String podcastName, String podcastAbout,
      User podcastOwner, String episodeName, String episodeAbout) async {
    String? imagePath = await _podcastService.uploadPodcastImage(
        podcastName, podcastImageFile.value);
    print(imagePath);
    String? episodeImagePath = await _podcastService.uploadPodcastImage(
        podcastName, podcastEpisodeImageFile.value);
    String? episodePath = await _podcastService.uploadPodcastFile(
        podcastName, File(currentPodcastFilePath.value));
    print(episodePath);
    bool confirm = await _podcastService.uploadPodcast(
        podcastName,
        podcastAbout,
        imagePath,
        selectedCategories,
        podcastOwner,
        episodePath,
        episodeImagePath,
        episodeName,
        episodeAbout);
    return confirm;
  }

  Future<void> getContinueListeningPodcast() async {
    List<Podcast>? _continuePodcasts = [];
    _continuePodcasts = await _podcastService.getContinueListeningPodcast();
    continuePodcastList.addAll(_continuePodcasts!);
  }

  Future<void> getContinueListeningPodcastEpisodes(String podcastId) async {
    continuePodcastEpisodeList.clear();
    List<Episode> episodesToAdd =
        await _podcastService.getContinueListeningPodcastEpisodes(podcastId);
    continuePodcastEpisodeList.addAll(episodesToAdd);
    print(continuePodcastEpisodeList.length);
  }

  Future<bool> downloadPodcastFile(var url, String fileName) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getDownloadsDirectory();
      final filePath =
          '${directory!.path}/${fileName}.mp3'; // Kaydedilecek dosyanın yolunu belirle

      print(filePath);
      File file = File(filePath.trim());
      await file.writeAsBytes(bytes); // Dosyayı cihaza kaydet
      print("Dosya Başarıyla indirildi");
      return true;
    } else {
      return false;
    }
  }
}
