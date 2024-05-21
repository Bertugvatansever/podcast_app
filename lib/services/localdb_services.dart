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
  }

  Future<void> saveDownloadPodcast(ListeningPodcast listeningPodcast) async {
    Box downloadsBox = Hive.box("Downloads");

    await downloadsBox.put(
        listeningPodcast.podcastEpisodeId, listeningPodcast.toJson());
  }

  Future<String?> getMyProfilePhoto() async {
    Box<String> profilePhotoBox = Hive.box<String>("ProfilePhotos");
    String id = "userId";
    String? profilePhoto = profilePhotoBox.get(id);
    return profilePhoto;
  }

  Future<void> saveProfilePhotoLocalDb(String path) async {
    Box<String> profilePhotoBox = Hive.box<String>("ProfilePhotos");
    String id = "userId";
    await profilePhotoBox.put(id, path);
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
      await Hive.box<Download>("Downloads").delete(id); // Veritabanından silme
      return true;
    } catch (e) {
      print('Dosya silinirken bir hata oluştu: $e');
      return false;
    }
  }

  Future<List<ListeningPodcast>> getDownloads() async {
    List<ListeningPodcast> downloadsList = [];
    Box downloadsBox = Hive.box("Downloads");

    downloadsBox.values.forEach((e) {
      ListeningPodcast listeningPodcast =
          ListeningPodcast.fromJson(e as Map<String, dynamic>);
      downloadsList.add(listeningPodcast);
    });

    return downloadsList;
  }

  ListeningPodcast getPodcastById(String episodeId) {
    Box downloadsBox = Hive.box("Downloads");
    var result = downloadsBox.get(episodeId);
    ListeningPodcast listeningPodcast =
        ListeningPodcast.fromJson(result as Map<String, dynamic>);
    return listeningPodcast;
  }
}
