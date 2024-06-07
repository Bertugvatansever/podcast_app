import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/services/auth_services.dart';
import 'package:podcast_app/services/localdb_services.dart';
import 'package:podcast_app/services/user_services.dart';

class UserController extends GetxController {
  AuthService _authService = AuthService();
  UserService _userService = UserService();
  LocalDbService _localDbService = LocalDbService();
  Rx<User> currentUser = User(
      id: "",
      name: "",
      surName: "",
      photo: "",
      email: "",
      createdTime: 1,
      favourite: [""],
      myRatings: {}).obs;
  Rx<int> currentIndex = 0.obs;
  Rx<bool> isProfileEdit = false.obs;
  Rx<bool> isProfilePhoto = false.obs;
  Rx<bool> isProfilePhotoChange = false.obs;
  Rx<File> profilePhotoFile = File("").obs;
  RxList<double> ratingList = <double>[].obs;
  RxList<Podcast> followPodcastList = <Podcast>[].obs;
  RxList<User> followUserList = <User>[].obs;
  RxList<User> followersUserList = <User>[].obs;

  Map<String, String>? followMap;
  @override
  void onInit() async {
    super.onInit();
    await getcurrentUser();
    await getMyProfilePhotoLocalDb();
    print(profilePhotoFile.value);
    if (profilePhotoFile.value.path != "") {
      // Fotoğraf dbde varsa bile cihazda olup olmadığını kontrol ediyorum.
      File file = File(profilePhotoFile.value.path);
      bool exists = await file.exists();
      if (exists) {
        print("Fotoğraf Mevcut");
      } else {
        await checkNewDevice();
      }
    } else {
      await checkNewDevice();
    }
  }

  Future<bool> saveRegisterUser(
      String email, String password, String name, String surName) async {
    try {
      String? id = await _authService.signUp(email, password);
      bool confirm =
          await _userService.saveRegisterUser(id, email, name, surName);
      return confirm;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> signIn(String email, String password) async {
    String? userId = await _authService.signIn(email, password);
    if (userId != null) {
      currentUser.value = await _userService.getcurrentUser(userId);
    }
  }

  Future<bool> resetPassword(String email) async {
    bool confirm = await _authService.resetPassword(email);
    return confirm;
  }

  Future<void> getcurrentUser() async {
    String? id = _authService.getcurrentUserId();
    if (id != null) {
      currentUser.value = await _userService.getcurrentUser(id);
      print(currentUser.value.id);
    }
  }

  Future<User> getPodcastOwnerUser(String id) async {
    User podcastOwnerUser = await _userService.getPodcastOwnerUser(id);
    return podcastOwnerUser;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> selectProfilePhoto() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(pickedFile!.path.toString());
    if (pickedFile != null) {
      try {
        profilePhotoFile.value = File(pickedFile.path);
        isProfilePhoto.value = true;
        isProfilePhotoChange.value = true;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<String?> saveProfilePhoto(
      String userId, String userName, File profilePhoto) async {
    await _userService.saveProfilePhoto(userId, userName, profilePhoto);
  }

  Future<void> saveProfilePhotoLocalDb(
      File profilePhotoFile, String userName) async {
    Directory? directory = await getDownloadsDirectory();
    String path = directory!.path + "/" + "profile_photo.png";
    print(path);
    File file = File(path);

    await file.writeAsBytes(profilePhotoFile.readAsBytesSync());
    await _localDbService.saveProfilePhotoLocalDb(path);
  }

  Future<void> getMyProfilePhotoLocalDb() async {
    String? localProfilePhoto = await _localDbService.getMyProfilePhoto();
    if (localProfilePhoto != null) {
      profilePhotoFile.value = File(localProfilePhoto);
      isProfilePhoto.value = true;
    }

    print(profilePhotoFile.value.path);
  }

  Future<void> changeNameSurname(String newName, String newSurName,
      String userId, bool nameChanged, bool surnameChanged) async {
    await _userService.changeNameSurname(
        newName, newSurName, userId, nameChanged, surnameChanged);
  }

  Future<void> checkNewDevice() async {
    try {
      print("currentUser ${currentUser.value.id}");
      String? _path =
          await _userService.getMyProfilePhotoFb(currentUser.value.id!);
      if (_path!.isNotEmpty) {
        await _localDbService.saveProfilePhotoLocalDb(_path);
        isProfilePhoto.value = true;
        profilePhotoFile.value = File(_path);
      } else {
        isProfilePhoto.value = false;
      }
    } catch (e) {
      print("Kullanıcının profil fotoğrafı yok : ${e.toString()}");
    }
  }

  Future<void> follow(String userId, String followId, bool isPodcast) async {
    await _userService.follow(userId, followId, isPodcast);
  }

  Future<void> unFollow(String userId, String followId, bool isPodcast) async {
    await _userService.unFollow(userId, followId, isPodcast);
  }

  Future<Map<String, String>> calculateFollowCount(String userId) async {
    Map<String, String> followMap;
    followMap = await _userService.calculateFollowCount(
      userId,
    );
    return followMap;
  }

  Future<String> calculatePodcastCount(String userId) async {
    String podcastCount = await _userService.calculatePodcastCount(userId);
    return podcastCount;
  }

  Future<void> getUserRatingList(String userId) async {
    currentUser.value.myRatings = await _userService.getUserRatingList(userId);
  }

  void deleteEpisodeDuration(String episodeId) {
    _localDbService.deleteEpisodeDuration(episodeId);
  }

  Future<void> getFollow(String userId) async {
    Map<String, dynamic> followMap = await _userService.getFollow(userId);
    followUserList.value = followMap["userList"];
    followPodcastList.value = followMap["podcastList"];
  }

  Future<void> getFollowers(String userId) async {
    followersUserList.value = (await _userService.getFollowers(userId)) ?? [];
  }
}
