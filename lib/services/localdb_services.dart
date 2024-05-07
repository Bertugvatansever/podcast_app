import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:podcast_app/models/download.dart';
import 'package:uuid/uuid.dart';

class LocalDbService {
  Future<void> initializeLocalDb() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DownloadAdapter());
    await Hive.openBox<Download>('Downloads');
  }

  Future<void> saveDownloadPodcast(
      String location,
      String podcastName,
      String podcastOwner,
      String podcastEpisodePhoto,
      String podcastEpisodeAbout,
      String podcastEpisodeName) async {
    Download downloads = Download(
        location: location,
        podcastName: podcastName,
        podcastOwner: podcastOwner,
        podcastEpisodePhoto: podcastEpisodePhoto,
        podcastEpisodeAbout: podcastEpisodeAbout,
        podcastEpisodeName: podcastEpisodeName);
    Box<Download> downloadsBox = Hive.box<Download>("Downloads");
    String id = Uuid().v4();
    downloads.id = id;
    await downloadsBox.put(id, downloads);
  }

  Future<void> deleteDownload(
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
    } catch (e) {
      print('Dosya silinirken bir hata oluştu: $e');
    }
  }

  Future<List<Download>> getDownloads() async {
    List<Download> downloadsList = [];
    Box<Download> downloadsBox = Hive.box<Download>("Downloads");
    downloadsList = downloadsBox.values.toList();
    return downloadsList;
  }
}