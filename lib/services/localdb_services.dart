import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:podcast_app/models/download.dart';
import 'package:podcast_app/models/listening_podcast.dart';
import 'package:uuid/uuid.dart';

class LocalDbService {
  Future<void> initializeLocalDb() async {
    await Hive.initFlutter();
    await Hive.openBox('Downloads');
    await Hive.openBox<String>('ProfilePhotos');
    await Hive.openBox('ContinueDurations');
  }

  Future<void> saveDownloadPodcast(ListeningPodcast listeningPodcast) async {
    Box downloadsBox = Hive.box("Downloads");

    await downloadsBox.put(
        listeningPodcast.podcastEpisodeId, listeningPodcast.toJson());
  }

  Future<String?> getMyProfilePhoto(String userId) async {
    Box<String> profilePhotoBox = Hive.box<String>("ProfilePhotos");

    String? profilePhoto = profilePhotoBox.get(userId);
    return profilePhoto;
  }

  Future<void> saveProfilePhotoLocalDb(String path, String userId) async {
    Box<String> profilePhotoBox = Hive.box<String>("ProfilePhotos");

    await profilePhotoBox.put(userId, path);
  }

  Future<bool> deleteDownload(
      String id, String filePath, String photoPath) async {
    try {
      final file = File(filePath);
      final photoFile = File(photoPath);
      if (await file.exists()) {
        await file.delete();
        print('Dosya silindi: $filePath');
      } else {
        print('Dosya mevcut değil: $filePath');
      }

      if (await photoFile.exists()) {
        await photoFile.delete();
        print('Fotoğraf silindi: $photoPath');
      } else {
        print('Fotoğraf mevcut değil: $photoPath');
      }
      await Hive.box("Downloads").delete(id); // Veritabanından silme
      return true;
    } catch (e) {
      print('Dosya silinirken bir hata oluştu: $e');
      return false;
    }
  }

  Future<List<ListeningPodcast>> getDownloads() async {
    List<ListeningPodcast> downloadsList = [];
    Box downloadsBox = Hive.box("Downloads");

    for (var e in downloadsBox.values) {
      try {
        if (e is Map) {
          // Ensure the map has String keys and dynamic values
          Map<String, dynamic> jsonMap = Map<String, dynamic>.from(e);

          ListeningPodcast listeningPodcast =
              ListeningPodcast.fromJson(jsonMap);
          downloadsList.add(listeningPodcast);
        } else {
          print("Unexpected data type: ${e.runtimeType}");
        }
      } catch (error) {
        print("Error parsing download: $error");
      }
      print(downloadsList[0].podcastEpisodePhoto);
      print(downloadsList[0].uri);
    }

    return downloadsList;
  }

  ListeningPodcast? getEpisodeById(String episodeId) {
    Box downloadsBox = Hive.box("Downloads");
    var result = downloadsBox.get(episodeId);
    if (result != null) {
      final resultMap = Map<String, dynamic>.from(result as Map);

      ListeningPodcast listeningPodcast = ListeningPodcast.fromJson(resultMap);
      print("NAMEEEEEEEEEEE" + listeningPodcast.podcastEpisodeName.toString());
      print(listeningPodcast.podcastEpisodeAbout);
      print(listeningPodcast.podcastId);
      print(listeningPodcast.podcastEpisodePhoto);
      print(listeningPodcast.podcastEpisodeName);
      print(listeningPodcast.podcastEpisodeName);
      print(listeningPodcast.podcastEpisodeName);

      return listeningPodcast;
    }
  }

  int? getEpisodeDuration(String episodeId) {
    Box durationBox = Hive.box("ContinueDurations");

    int? duration = durationBox.get(episodeId);

    return duration;
  }

  void setEpisodeDuration(String episodeId, int duration) {
    Box durationBox = Hive.box("ContinueDurations");

    durationBox.put(episodeId, duration);
  }

  void deleteEpisodeDuration(String episodeId) {
    Box durationBox = Hive.box("ContinueDurations");
    durationBox.delete(episodeId);
  }
}
