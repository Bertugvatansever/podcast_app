import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/models/user.dart';

class UserService {
  Future<bool> saveRegisterUser(
      String? id, String email, String name, String surName) async {
    if (id != null) {
      CollectionReference userReference =
          FirebaseFirestore.instance.collection("users");
      await userReference.doc(id).set({
        "id": id,
        "email": email,
        "name": name,
        "surname": surName,
        "photo": "",
        "createdtime": DateTime.now().millisecondsSinceEpoch
      });
      return true;
    } else {
      print("Kayıtta hata var ");
      return false;
    }
  }

  Future<User> getcurrentUser(String id) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    // DocumentSnapshot bir adet belge çağırırken kullanılır.
    DocumentSnapshot documentSnapshot = await usersRef.doc(id).get();
    User user = User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return user;
  }

  Future<User> getPodcastOwnerUser(String id) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    // DocumentSnapshot bir adet belge çağırırken kullanılır.
    DocumentSnapshot documentSnapshot = await usersRef.doc(id).get();
    User user = User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return user;
  }

  Future<String?> uploadProfilePhoto(String userName, File profilePhoto) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('Profile_Photos')
          .child('${userName}${DateTime.now().millisecondsSinceEpoch}.jpeg');
      // dosyanın tipini de özel olarak belirttik.
      await ref.putFile(
          profilePhoto, SettableMetadata(contentType: 'png/jpeg'));
      final profilePhotoUrl = ref.getDownloadURL();
      return profilePhotoUrl;
    } catch (e) {
      print("hata:" + e.toString());
    }
  }

  Future<void> saveProfilePhoto(
      String userId, String userName, File profilePhoto) async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    String? photoUrl = await uploadProfilePhoto(userName, profilePhoto);
    await userReference.doc(userId).update({"photo": photoUrl});
  }

  Future<void> changeNameSurname(String newName, String newSurName,
      String userId, bool nameChanged, bool surnameChanged) async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    if (nameChanged) {
      await userReference.doc(userId).update({"name": newName});
    }
    if (surnameChanged) {
      await userReference.doc(userId).update({"surname": newSurName});
    }
  }

  Future<String?> getMyProfilePhotoFb(String userId) async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    DocumentSnapshot documentSnapshot = await userReference.doc(userId).get();
    User _tempUser =
        User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    try {
      // Dosyayı indir
      var response = await http.get(Uri.parse(_tempUser.photo!));
      // İndirme başarılı mı kontrol et
      if (response.statusCode == 200) {
        var tempDir = await getDownloadsDirectory();
        String savePath = '${tempDir!.path}/downloaded_image.jpg';
        File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        print('Dosya indirildi: $savePath');
        return savePath;
      } else {
        print('Dosya indirilemedi, hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      print('Dosya indirilemedi: $e');
    }
  }

  Future<void> follow(String userId, String followId, bool isPodcast) async {
    CollectionReference userReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("follow");
    await userReference
        .doc(followId)
        .set({"followid": followId, "ispodcast": isPodcast});

    if (isPodcast == false) {
      CollectionReference userReference = FirebaseFirestore.instance
          .collection("users")
          .doc(followId)
          .collection("followers");
      userReference.doc(userId).set({"followersid": userId});
    }
  }

  Future<void> unFollow(String userId, String followId, bool isPodcast) async {
    CollectionReference userReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("follow");

    await userReference.doc(followId).delete();

    if (isPodcast == false) {
      CollectionReference userReference = FirebaseFirestore.instance
          .collection("users")
          .doc(followId)
          .collection("followers");
      await userReference.doc(userId).delete();
    }
  }

  Future<Map<String, String>> calculateFollowCount(
    String userId,
  ) async {
    Map<String, String> followMap;
    // Takip sayısı hesaplama
    CollectionReference userReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("follow");
    QuerySnapshot querySnapshot = await userReference.get();
    // olmazsa querySnapshot.size kullan
    String followCount = querySnapshot.size.toString();
    userReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("followers");
    querySnapshot = await userReference.get();
    String followersCount = querySnapshot.size.toString();

    followMap = {"follow": followCount, "followers": followersCount};
    return followMap;
  }

  Future<String> calculatePodcastCount(String userId) async {
    CollectionReference podcastReference =
        FirebaseFirestore.instance.collection("podcasts");
    QuerySnapshot querySnapshot = await podcastReference
        // içerideki map e erişmek için nokta kullanıyoruz.
        .where("podcastuser.id", isEqualTo: userId)
        .get();
    String podcastCount = querySnapshot.size.toString();
    return podcastCount;
  }

  Future<Map<String, dynamic>?>? getFollowPodcasts(String userId) async {
    List<String> podcastIdList = [];
    List<Podcast> followPodcastList = [];
    Map<String, dynamic>? followPodcastMap;
    CollectionReference userReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("follow");
    QuerySnapshot querySnapshot =
        await userReference.where("ispodcast", isEqualTo: true).get();
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((element) {
        var data = element.data() as Map<String, dynamic>;
        podcastIdList.add(data["followid"]);
      });

      CollectionReference podcastReference =
          FirebaseFirestore.instance.collection("podcasts");
      querySnapshot = await podcastReference
          .where("podcastid", whereIn: podcastIdList)
          .get();
      querySnapshot.docs.forEach((element) {
        Podcast podcast =
            Podcast.fromJson(element.data() as Map<String, dynamic>);
        followPodcastList.add(podcast);
      });

      followPodcastMap = {
        "podcastIdList": podcastIdList,
        "followPodcastList": followPodcastList
      };

      return followPodcastMap;
    } else {
      return null;
    }
  }

  Future<void> setUserRating(
      String userId, String podcastId, double rating) async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    userReference.doc(userId).set({
      "myRatings": {podcastId: rating}
    }, SetOptions(merge: true));
  }

  Future<Map<String, double>?>? getUserRatingList(String userId) async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    DocumentSnapshot documentSnapshot = await userReference.doc(userId).get();
    User user = User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return user.myRatings;
  }
}
