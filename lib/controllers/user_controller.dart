import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
      favourite: [""]).obs;
  Rx<int> currentIndex = 0.obs;
  Rx<bool> isProfileEdit = false.obs;
  Rx<bool> isProfilePhoto = false.obs;
  Rx<bool> isProfilePhotoChange = false.obs;
  Rx<File> profilePhotoFile = File("").obs;

  @override
  void onInit() async {
    super.onInit();
    getcurrentUser();
    await getMyProfilePhotoLocalDb();
    if (profilePhotoFile.value != "") {
      isProfilePhoto.value = true;
    } else {}
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
    String localProfilePhoto = await _localDbService.getMyProfilePhoto();
    profilePhotoFile.value = File(localProfilePhoto);
    print(profilePhotoFile.value.path);
  }

  Future<void> changeNameSurname(String newName, String newSurName,
      String userId, bool nameChanged, bool surnameChanged) async {
    await _userService.changeNameSurname(
        newName, newSurName, userId, nameChanged, surnameChanged);
  }
}
