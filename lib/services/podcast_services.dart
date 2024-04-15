import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:podcast_app/models/user.dart';

class PodcastService {
  Future<String?> uploadPodcastFile(
      String podcastName, File podcastFile) async {
    try {
      //replaceall boşlukları kaldırır.
      final ref = FirebaseStorage.instance.ref().child('podcast_sounds').child(
          '$podcastName${DateTime.now().millisecondsSinceEpoch}.mp3'.trim());
      // dosyanın tipini de özel olarak belirttik.
      await ref.putFile(
          podcastFile, SettableMetadata(contentType: 'audio/mp3'));
      final podcastFileUrl = ref.getDownloadURL();
      return podcastFileUrl;
    } catch (e) {}
  }

  Future<String?> uploadPodcastImage(
      String podcastName, File podcastFile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('podcast_images')
          .child('$podcastName${DateTime.now().millisecondsSinceEpoch}.jpeg');
      // dosyanın tipini de özel olarak belirttik.
      await ref.putFile(podcastFile, SettableMetadata(contentType: 'png/jpeg'));
      final podcastImageUrl = ref.getDownloadURL();
      return podcastImageUrl;
    } catch (e) {
      print("hata:" + e.toString());
    }
  }

  Future<bool> uploadPodcast(
      String podcastName,
      String podcastAbout,
      String? imagePath,
      Map<String, bool> categoriesMap,
      User podcastOwner,
      String? episodePath,
      String episodeName) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('podcasts');
      String podcastId = collectionReference.doc().id;
      await collectionReference.doc(podcastId).set({
        'podcastname': podcastName,
        'podcastcategory': categoriesMap.keys,
        'podcastabout': podcastAbout,
        'podcastimage': imagePath,
        'podcastid': podcastId,
        'podcastuser': {
          'userid': podcastOwner.id,
          'username': podcastOwner.name,
          'usersurname': podcastOwner.surName,
        },
        'podcastcreatedtime': DateTime.now()
      });
      String episodeId =
          collectionReference.doc(podcastId).collection('episodes').doc().id;
      await collectionReference
          .doc(podcastId)
          .collection('episodes')
          .doc(episodeId)
          .set({
        'episodecreatedtime': DateTime.now(),
        'episodefile': episodePath,
        'episodeid': episodeId,
        'episodename': episodeName,
        'podcastname': podcastName
      });
      return true;
    } catch (e) {
      print("hata:" + e.toString());
      return false;
    }
  }
}
