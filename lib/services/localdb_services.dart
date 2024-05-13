import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:podcast_app/models/download.dart';
import 'package:uuid/uuid.dart';

class LocalDbService {
  Future<void> initializeLocalDb() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DownloadAdapter());
    await Hive.openBox<Download>('Downloads');
    await Hive.openBox<String>('ProfilePhotos');
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

  Future<String> getMyProfilePhoto() async {
    Box<String> profilePhotoBox = Hive.box<String>("ProfilePhotos");
    List<String> photoList = profilePhotoBox.values.toList();
    print("photolistlength" + photoList[0]);
    String profilePhoto = photoList.isNotEmpty ? photoList[0] : '';
    print("profilfotografıpath" + profilePhoto);
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

  Future<List<Download>> getDownloads() async {
    List<Download> downloadsList = [];
    Box<Download> downloadsBox = Hive.box<Download>("Downloads");
    downloadsList = downloadsBox.values.toList();
    return downloadsList;
  }
}
