import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/models/user.dart';

class PodcastService {
  Future<String?> uploadPodcastFile(
      String podcastName, File podcastFile) async {
    try {
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
      String? podcastImagePath,
      Map<String, bool> categoriesMap,
      User podcastOwner,
      String? episodePath,
      String? episodeImagePath,
      String episodeName,
      String episodeAbout) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('podcasts');
      String podcastId = collectionReference.doc().id;
      await collectionReference.doc(podcastId).set({
        'podcastname': podcastName,
        'podcastcategory': categoriesMap.keys,
        'podcastabout': podcastAbout,
        'podcastimage': podcastImagePath,
        'podcastid': podcastId,
        'podcastuser': {
          'id': podcastOwner.id,
          'name': podcastOwner.name,
          'surname': podcastOwner.surName,
        },
        'podcastcreatedtime': DateTime.now().millisecondsSinceEpoch
      });
      String episodeId =
          collectionReference.doc(podcastId).collection('episodes').doc().id;
      await collectionReference
          .doc(podcastId)
          .collection('episodes')
          .doc(episodeId)
          .set({
        'episodecreatedtime': DateTime.now().millisecondsSinceEpoch,
        'episodefile': episodePath,
        'episodeimage': episodeImagePath,
        'episodeid': episodeId,
        'episodename': episodeName,
        'podcastname': podcastName,
        'episodeAbout': episodeAbout
      });
      return true;
    } catch (e) {
      print("hata:" + e.toString());
      return false;
    }
  }

  Future<List<Podcast>?> getContinueListeningPodcast() async {
    List<Podcast> listeningPodcasts = [];
    // try {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("podcasts");
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs.forEach((element) {
      Podcast podcast =
          Podcast.fromJson(element.data() as Map<String, dynamic>);
      listeningPodcasts.add(podcast);
    });

    return listeningPodcasts;
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  Future<List<Episode>> getContinueListeningPodcastEpisodes(
      String podcastId) async {
    List<Episode> episodeList = [];
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("podcasts")
        .doc(podcastId)
        .collection("episodes");
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs.forEach((element) {
      Episode episode =
          Episode.fromJson(element.data() as Map<String, dynamic>);

      episodeList.add(episode);
    });
    return episodeList;
  }
}
