import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/listening_podcast.dart';
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
        'podcastepisodes': episodeName,
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
        'episodeabout': episodeAbout,
        'podcastid': podcastId
      });

      return true;
    } catch (e) {
      print("hata:" + e.toString());
      return false;
    }
  }

  Future<List<ListeningPodcast>?> getContinueListeningPodcast(
      String userId) async {
    List<ListeningPodcast> listeningPodcasts = [];
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot =
        await userReference.doc(userId).collection("listenPodcasts").get();

    querySnapshot.docs.forEach((doc) {
      ListeningPodcast listeningPodcast =
          ListeningPodcast.fromJson(doc.data() as Map<String, dynamic>);

      listeningPodcasts.add(listeningPodcast);
    });
    print("LİSTENİNG PODCASTS" + listeningPodcasts.length.toString());
    return listeningPodcasts;
  }

  Future<void> setContinueListeningPodcast(
      String userId, ListeningPodcast listeningPodcast) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    await collectionReference
        .doc(userId)
        .collection("listenPodcasts")
        .doc(listeningPodcast.podcastEpisodeId)
        .set(listeningPodcast.toJson());
  }

  Future<void> deleteContinueListeningPodcast(
      String userId, String listeningPodcastId) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    await collectionReference
        .doc(userId)
        .collection("listenPodcasts")
        .doc(listeningPodcastId)
        .delete();
  }

  Future<List<Episode>> getPodcastEpisodes(String podcastId) async {
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

  Future<List<Podcast>> getMyPodcasts(String userId) async {
    List<Podcast> myPodcasts = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("podcasts");
    QuerySnapshot querySnapshot = await collectionReference
        // içerideki map e erişmek için nokta kullanıyoruz.
        .where("podcastuser.id", isEqualTo: userId)
        .get();
    querySnapshot.docs.forEach((element) {
      Podcast podcast =
          Podcast.fromJson(element.data() as Map<String, dynamic>);
      myPodcasts.add(podcast);
    });
    return myPodcasts;
  }

  Future<List<Podcast>> getProfilePodcasts(String userId) async {
    List<Podcast> profilePodcasts = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("podcasts");
    QuerySnapshot querySnapshot = await collectionReference
        // içerideki map e erişmek için nokta kullanıyoruz.
        .where("podcastuser.id", isEqualTo: userId)
        .get();
    querySnapshot.docs.forEach((element) {
      Podcast podcast =
          Podcast.fromJson(element.data() as Map<String, dynamic>);
      profilePodcasts.add(podcast);
    });
    return profilePodcasts;
  }

  Future<bool> addNewEpisode(
      String podcastId,
      String episodeName,
      String episodeAbout,
      String? episodePath,
      String? imagePath,
      String podcastName) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("podcasts");
      collectionReference.doc(podcastId).update({
        "podcastepisodes": FieldValue.arrayUnion([episodeName])
      });
      String episodeId =
          collectionReference.doc(podcastId).collection('episodes').doc().id;
      collectionReference
          .doc(podcastId)
          .collection("episodes")
          .doc(episodeId)
          .set({
        'episodeabout': episodeAbout,
        'episodecreatedtime': DateTime.now().millisecondsSinceEpoch,
        'episodefile': episodePath,
        'episodeid': episodeId,
        'episodeimage': imagePath,
        'episodename': episodeName,
        'podcastname': podcastName,
        'podcastid': podcastId
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> addPodcastFavourite(String userId, String podcastId) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");

    collectionReference.doc(userId).update({
      // FieldValue.arrayUnion firebasedeki listeye yeni eleman ekler.
      'favourites': FieldValue.arrayUnion([podcastId])
    });
  }

  Future<void> removePodcastFavourite(String userId, String podcastId) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");

    collectionReference.doc(userId).update({
      // FieldValue.arrayRemove eleman siler
      'favourites': FieldValue.arrayRemove([podcastId])
    });
  }

  Future<List<Podcast>> getFavouritePodcasts(String userId) async {
    List<String> userFavouriteList = [];
    List<Podcast> podcastFavouriteList = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(userId).get();
    User user = User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    user.favourite!.forEach(
      (element) {
        userFavouriteList.add(element.toString());
      },
    );
    if (userFavouriteList.isNotEmpty) {
      CollectionReference podcastReference =
          FirebaseFirestore.instance.collection("podcasts");
      QuerySnapshot querySnapshot = await podcastReference
          .where("podcastid", whereIn: userFavouriteList)
          .get();
      querySnapshot.docs.forEach((element) {
        Podcast podcast =
            Podcast.fromJson(element.data() as Map<String, dynamic>);
        podcastFavouriteList.add(podcast);
      });
      print(podcastFavouriteList.length);
      return podcastFavouriteList;
    } else {
      return podcastFavouriteList;
    }
  }

  Future<Map<String, int>> getAllPodcastsCount() async {
    Map<String, int> countsMap = {};
    CollectionReference countReference =
        FirebaseFirestore.instance.collection("counts");
    QuerySnapshot querySnapshot = await countReference.limit(1).get();
    countsMap["allPodcastsCount"] = (querySnapshot.docs.first.data()
        as Map<String, dynamic>)["allPodcastsCount"];
    countsMap["Teknoloji"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Teknoloji"];
    countsMap["Spor"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Spor"];
    countsMap["Sağlık"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Sağlık"];
    countsMap["Eğitim"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Eğitim"];
    countsMap["Moda"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Moda"];
    countsMap["Gastronomi"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Gastronomi"];
    countsMap["Sanat"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Sanat"];
    countsMap["Seyahat"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Seyahat"];
    countsMap["Müzik"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Müzik"];
    countsMap["Sinema"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Sinema"];
    countsMap["Tarih"] =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)["Tarih"];

    return countsMap;
  }

  Future<Map<String, dynamic>?> getAllPodcasts(
      DocumentSnapshot? lastDocument, String filter,
      {String? categoryName}) async {
    List<Podcast> allPodcasts = [];
    QuerySnapshot querySnapshot;
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");

    if (lastDocument == null) {
      if (categoryName != null && categoryName.isNotEmpty) {
        querySnapshot = await podcastReference
            .orderBy(filter, descending: true)
            .limit(2)
            .where("podcastcategory", arrayContains: categoryName)
            .get();
      } else {
        querySnapshot = await podcastReference
            .orderBy(filter, descending: true)
            .limit(2)
            .get();
      }
    } else {
      if (categoryName != null && categoryName.isNotEmpty) {
        querySnapshot = await podcastReference
            .orderBy(filter, descending: true)
            .startAfterDocument(lastDocument)
            .limit(2)
            .where("podcastcategory", arrayContains: categoryName)
            .get();
      } else {
        querySnapshot = await podcastReference
            .orderBy(filter, descending: true)
            .startAfterDocument(lastDocument)
            .limit(2)
            .get();
      }
    }

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;

      querySnapshot.docs.forEach((element) {
        Podcast podcast =
            Podcast.fromJson(element.data() as Map<String, dynamic>);
        allPodcasts.add(podcast);
      });

      return {
        "lastDocument": lastDocument,
        "list": allPodcasts,
      };
    } else {
      return null;
    }
  }

  Future<ListeningPodcast> getEpisodeById(
      String podcastId, String episodeId, String userId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("podcasts")
        .doc(podcastId)
        .collection("episodes")
        .doc(episodeId)
        .get();

    Episode episode =
        Episode.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    ListeningPodcast listeningPodcast = ListeningPodcast(
      podcastId: episode.podcastId,
      podcastEpisodeId: episode.episodeId,
      uri: episode.file,
      podcastName: episode.podcastName,
      podcastOwner: episode.name,
      podcastEpisodePhoto: episode.episodeImage,
      podcastEpisodeAbout: episode.episodeAbout,
      podcastEpisodeName: episode.name,
    );
    return listeningPodcast;
  }

  Future<ListeningPodcast?> getEpisodeByIdFromListenPodcasts(
      String podcastId, String episodeId, String userId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("listenPodcasts")
        .doc(podcastId)
        .get();

    if (documentSnapshot.data() != null) {
      ListeningPodcast listeningPodcast = ListeningPodcast.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);

      return listeningPodcast;
    } else {
      return null;
    }
  }

  Future<void> setPodcastRating(
    String podcastId,
    double podcastRating,
    String userId,
  ) async {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");

    await podcastReference.doc(podcastId).set({
      "rating": {userId: podcastRating},
    }, SetOptions(merge: true));
  }

  Future<void> writePodcastRating(
      String podcastId, String podcastFinalRating) async {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    await podcastReference.doc(podcastId).update({
      "podcastrating": podcastFinalRating,
      "podcastChangedTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<Map<String, double>?>? calculatePodcastRating(String podcastId) async {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    DocumentSnapshot documentSnapshot =
        await podcastReference.doc(podcastId).get();
    var data = documentSnapshot.data() as Map<String, dynamic>;
    if (data.containsKey("rating")) {
      var ratingData = data["rating"] as Map<String, dynamic>;
      Map<String, double>? podcastRatings =
          ratingData.map((key, value) => MapEntry(key, value.toDouble()));

      return podcastRatings;
    }

    return null;
  }

  Future<void> setPodcastView(String podcastId, int podcastView) async {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    await podcastReference.doc(podcastId).update({
      "podcastview": podcastView + 1,
      "podcastChangedTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenPodcastRatings(
      String podcastId) {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    Stream<QuerySnapshot<Map<String, dynamic>>> podcastStream =
        FirebaseFirestore.instance
            .collection("podcasts")
            .where("podcastid", isEqualTo: podcastId)
            .snapshots();
    return podcastStream;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenAllPodcastRatings() {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    Stream<QuerySnapshot<Map<String, dynamic>>> podcastStream =
        FirebaseFirestore.instance
            .collection("podcasts")
            .orderBy("podcastChangedTime", descending: true)
            .limit(1)
            .snapshots();
    return podcastStream;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenAllPodcastView() {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    Stream<QuerySnapshot<Map<String, dynamic>>> podcastStream =
        FirebaseFirestore.instance
            .collection("podcasts")
            .orderBy("podcastChangedTime", descending: true)
            .limit(1)
            .snapshots();
    return podcastStream;
  }

  Future<List<Podcast>> getAllPodcastsSearch() async {
    List<Podcast> searchAllPodcast = [];
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    QuerySnapshot querySnapshot = await podcastReference.get();
    querySnapshot.docs.forEach((searchPodcast) {
      Podcast podcast =
          Podcast.fromJson(searchPodcast.data() as Map<String, dynamic>);
      searchAllPodcast.add(podcast);
    });
    return searchAllPodcast;
  }
}
