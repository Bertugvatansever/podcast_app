import 'package:get/get.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/services/auth_services.dart';
import 'package:podcast_app/services/user_services.dart';

class UserController extends GetxController {
  AuthService _authService = AuthService();
  UserService _userService = UserService();
  Rx<User> currentUser =
      User(id: "", name: "", surName: "", photo: "", email: "", createdTime: 1)
          .obs;

  @override
  void onInit() {
    super.onInit();
    getcurrentUser();
  }

  Future<bool> saveRegisterUser(
      String email, String password, String name, String surName) async {
    String? id = await _authService.signUp(email, password);
    bool confirm =
        await _userService.saveRegisterUser(id, email, name, surName);
    return confirm;
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
}
