import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/models/download.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/listening_podcast.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/services/localdb_services.dart';
import 'package:podcast_app/services/podcast_services.dart';
import 'package:podcast_app/services/user_services.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

//PODCAST SİLME KODUNDA COUNTU GÜNCELLE

class PodcastController extends GetxController {
  PodcastService _podcastService = PodcastService();
  LocalDbService _localDbService = LocalDbService();
  UserService _userService = UserService();
  int podcastCount = 0;
  Rx<bool> isRecorded = false.obs;
  Rx<bool> isPaused = false.obs;
  Rx<bool> startPage = true.obs;
  Rx<bool> isButtonActive = false.obs;
  Rx<bool> isDownloadedPodcast = false.obs;
  Rx<bool> isDownloadingPodcast = false.obs;
  Rx<bool> addNewEpisode = false.obs;
  Rx<bool> isActiveDownloadListen = false.obs;
  Rx<bool> deleteDownloadBool = false.obs;
  Rx<bool> isDown = false.obs;
  Rx<bool> podcastsPage = false.obs;
  Rx<bool> listClear = false.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> emptyPodcast = false.obs;
  Rx<bool> isFinished = false.obs;
  Rx<bool> firstLoadAllpodcast = false.obs;
  Rx<String> currentPodcastFilePath = "".obs;
  Rx<String> podcastName = "".obs;
  Rx<String> downloadFilePath = "".obs;
  Rx<String> downloadPhotoPath = "".obs;
  RxMap<String, bool> selectedCategories = <String, bool>{}.obs;
  Rx<String> podcastAbout = "".obs;
  Rx<String> episodeName = "".obs;
  Rx<String> episodeAbout = "".obs;
  Rx<String> podcastRating = "".obs;
  RxList<ListeningPodcast> continuePodcastList = <ListeningPodcast>[].obs;
  RxList<Episode> podcastEpisodeList = <Episode>[].obs;
  RxList<Podcast> myPodcasts = <Podcast>[].obs;
  RxList<Podcast> favouriteList = <Podcast>[].obs;
  RxList<Podcast> profilePodcastList = <Podcast>[].obs;
  RxList<Podcast> allPodcasts = <Podcast>[].obs;
  RxList<Podcast> followPodcastList = <Podcast>[].obs;
  RxList<String> followPodcastIdList = <String>[].obs;
  RxList<Podcast> searchPodcastList = <Podcast>[].obs;
  RxList<ListeningPodcast> downloadsList = <ListeningPodcast>[].obs;
  Rx<File> podcastImageFile = File("").obs;
  Rx<File> podcastEpisodeImageFile = File("").obs;
  DocumentSnapshot? lastDocument;
  Duration recordTime = Duration.zero;
  String recordTimeString = "";
  StreamSubscription? podcastStreamSubscription;
  StreamSubscription? allPodcastStreamSubscription;
  StreamSubscription? podcastViewStreamSubscription;

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
    if (confirm) {
      podcastCount += 1;
    }
    return confirm;
  }

  Future<bool> addNewEpisodee(String podcastId, String episodeName,
      String episodeAbout, String podcastName) async {
    String? episodeImagePath = await _podcastService.uploadPodcastImage(
        podcastName, podcastEpisodeImageFile.value);
    String? episodePath = await _podcastService.uploadPodcastFile(
        podcastName, File(currentPodcastFilePath.value));
    bool confirm = await _podcastService.addNewEpisode(podcastId, episodeName,
        episodeAbout, episodePath, episodeImagePath, podcastName);
    return confirm;
  }

  Future<void> getContinueListeningPodcast(String userId) async {
    List<ListeningPodcast>? _continuePodcasts = [];
    _continuePodcasts =
        await _podcastService.getContinueListeningPodcast(userId);
    continuePodcastList.clear();
    continuePodcastList.addAll(_continuePodcasts!);
  }

  Future<void> setContinueListeningPodcast(
      String userId, ListeningPodcast listeningPodcast) async {
    await _podcastService.setContinueListeningPodcast(userId, listeningPodcast);
  }

  Future<void> deleteContinueListeningPodcast(
      String userId, String listeningPodcastId) async {
    await _podcastService.deleteContinueListeningPodcast(
        userId, listeningPodcastId);
  }

  Future<void> getPodcastEpisodes(String podcastId) async {
    List<Episode> episodesToAdd =
        await _podcastService.getPodcastEpisodes(podcastId);
    podcastEpisodeList.clear();
    podcastEpisodeList.addAll(episodesToAdd);
    print(podcastEpisodeList.length);
  }

  Future<List<Podcast>> getMyPodcasts(String userId) async {
    myPodcasts.value = await _podcastService.getMyPodcasts(userId);
    return myPodcasts;
  }

  Future<void> getProfilePodcasts(String userId) async {
    profilePodcastList.value = await _podcastService.getProfilePodcasts(userId);
  }

  Future<bool> downloadPodcastFile(
      var fileUrl, var photoUrl, String episodeId) async {
    final response = await http.get(Uri.parse(fileUrl));
    final responsePhoto = await http.get(Uri.parse(photoUrl));

    if (response.statusCode == 200 && responsePhoto.statusCode == 200) {
      final bytes = response.bodyBytes;
      final photoBytes = responsePhoto.bodyBytes;
      final directory = await getDownloadsDirectory();
      final filePath =
          '${directory!.path}/${episodeId}.mp3'; // Kaydedilecek dosyanın yolunu belirle
      final photoPath = '${directory!.path}/${episodeId}.jpeg';
      File file = File(filePath.trim());
      await file.writeAsBytes(bytes); // Dosyayı cihaza kaydet
      file = File(photoPath.trim());
      await file.writeAsBytes(photoBytes);
      downloadFilePath.value = filePath;
      downloadPhotoPath.value = photoPath;
      print("Dosya Başarıyla indirildi");
      return true;
    } else {
      return false;
    }
  }

  Future<void> addPodcastFavourite(String userId, String podcastId) async {
    await _podcastService.addPodcastFavourite(userId, podcastId);
  }

  Future<void> removePodcastFavourite(String userId, String podcastId) async {
    await _podcastService.removePodcastFavourite(userId, podcastId);
  }

  Future<void> getFavouritePodcasts(String userId) async {
    favouriteList.value = await _podcastService.getFavouritePodcasts(userId);
  }

  Future<void> downloadPodcastLocalDb(ListeningPodcast listeningPodcast) async {
    await _localDbService.saveDownloadPodcast(listeningPodcast);
  }

  Future<void> getDownloadsPodcast() async {
    downloadsList.value = await _localDbService.getDownloads();
  }

  Future<bool> deleteDownload(
      String downloadPodcastId, String filePath, String photoPath) async {
    bool confirm = await _localDbService.deleteDownload(
        downloadPodcastId, filePath, photoPath);
    return confirm;
  }

  Future<void> checkFileExistence(String filePath) async {
    File file = File(filePath);
    bool fileExists = await file.exists();

    if (fileExists) {
      isDownloadedPodcast.value = true;
      print('Dosya mevcut.');
    } else {
      isDownloadedPodcast.value = false;
      print('Dosya mevcut değil.');
    }
  }

  Future<void> checkPodcastDownloaded(String episodeId) async {
    Directory? directory = await getDownloadsDirectory();
    await checkFileExistence('${directory!.path}/${episodeId}.mp3');
  }

  Future<void> getAllPodcasts(String filter, {String? categoryName}) async {
    try {
      await getAllPodcastsCount();
      if (listClear.value) {
        allPodcasts.clear();
      }
      if ((isLoading.value == false) && (podcastCount > allPodcasts.length)) {
        isLoading.value = true;

        Map<String, dynamic>? result = await _podcastService
            .getAllPodcasts(lastDocument, filter, categoryName: categoryName);

        await Future.delayed(Duration(seconds: 1));

        if (result != null) {
          allPodcasts.addAll(result["list"]);

          lastDocument = result["lastDocument"];
        }

        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }

    // if (result?["emptyPodcast"] != null) {
    //   emptyPodcast.value = result?["emptyPodcast"];
    // }
  }

  Future<ListeningPodcast?> getPodcastById(
      String podcastId, String episodeId, String userId) async {
    await checkPodcastDownloaded(episodeId);
    if (isActiveDownloadListen.value) {
      if (isDownloadedPodcast.value) {
        ListeningPodcast? listeningPodcast =
            _localDbService.getEpisodeById(episodeId);
        return listeningPodcast;
      }
    } else {
      ListeningPodcast? listeningPodcastFromUser = await _podcastService
          .getEpisodeByIdFromListenPodcasts(podcastId, episodeId, userId);

      if (listeningPodcastFromUser == null) {
        ListeningPodcast listeningPodcast =
            await _podcastService.getEpisodeById(podcastId, episodeId, userId);
        return listeningPodcast;
      } else {
        return listeningPodcastFromUser;
      }
    }
  }

  int? getEpisodeDuration(String episodeId) {
    return _localDbService.getEpisodeDuration(episodeId);
  }

  void setEpisodeDuration(String episodeId, int duration) {
    _localDbService.setEpisodeDuration(episodeId, duration);
  }

  Future<void> getFollowPodcasts(String userId) async {
    Map<String, dynamic>? followPodcastMap =
        await _userService.getFollowPodcasts(userId);
    if (followPodcastMap != null) {
      followPodcastList.value = followPodcastMap["followPodcastList"];
      followPodcastIdList.value = followPodcastMap["podcastIdList"];
    } else {
      followPodcastList.value = [];
      followPodcastIdList.value = [];
    }
  }

  Future<void> getAllPodcastsCount() async {
    podcastCount = await _podcastService.getAllPodcastsCount();
  }

  Future<void> setPodcastRating(
      String podcastId, double podcastRating, String userId,
      {double? previousRating}) async {
    await _podcastService.setPodcastRating(podcastId, podcastRating, userId);
    String podcastFinalRating = await calculatePodcastRating(podcastId);
    print("PODCAST FİNAL RATİNG2" + podcastFinalRating.toString());
    await _podcastService.writePodcastRating(podcastId, podcastFinalRating);

    await _userService.setUserRating(userId, podcastId, podcastRating);
  }

  Future<String> calculatePodcastRating(String podcastId) async {
    Map<String, double>? podcastRating;
    double totalRating = 0;
    String finalRating;
    podcastRating = await _podcastService.calculatePodcastRating(podcastId);
    if (podcastRating != null && podcastRating.isNotEmpty) {
      for (var rating in podcastRating.values) {
        totalRating += rating;
      }
      finalRating = (totalRating / podcastRating.values.length).toString();
      return finalRating;
    } else {
      return "";
    }
  }

  Future<void> setPodcastView(String podcastId, int podcastView) async {
    await _podcastService.setPodcastView(podcastId, podcastView);
  }

  void listenPodcastRatings(String podcastId) {
    podcastStreamSubscription =
        _podcastService.listenPodcastRatings(podcastId).listen((event) {
      if (event.docs.isNotEmpty) {
        var updateRating = event.docs.first.data();
        String newRating = updateRating["podcastrating"];
        podcastRating.value = newRating;
      }
    });
  }

  void listenAllPodcastRatings() {
    allPodcastStreamSubscription =
        _podcastService.listenAllPodcastRatings().listen((event) {
      if (event.docs.isNotEmpty) {
        var updateRating = event.docs.first.data();
        String podcastId = updateRating["podcastid"];
        allPodcasts.forEach((podcast) {
          if (podcast.id == podcastId) {
            String newRating = updateRating["podcastrating"];
            print("new Rating" + newRating);
            podcast.rating = newRating;
            print("PODCAST RATİNG" + podcast.rating.toString());
          }
        });
      }
    });
  }

  void listenAllPodcastView() {
    podcastViewStreamSubscription =
        _podcastService.listenAllPodcastView().listen((event) {
      if (event.docs.isNotEmpty) {
        var updateView = event.docs.first.data();
        String podcastId = updateView["podcastid"];
        allPodcasts.forEach((podcast) {
          if (podcast.id == podcastId) {
            int newView = updateView["podcastview"];
            print("new Rating" + newView.toString());
            podcast.viewCount = newView;
            print("PODCAST RATİNG" + podcast.viewCount.toString());
          }
        });
      }
    });
  }

  void cancelListenPodcast() {
    podcastStreamSubscription!.cancel();
  }

  void cancelListenAllPodcast() {
    allPodcastStreamSubscription!.cancel();
  }

  void cancelListenView() {
    podcastViewStreamSubscription!.cancel();
  }

  Future<void> getAllPodcastsSearch() async {
    searchPodcastList.value = await _podcastService.getAllPodcastsSearch();
  }
}
