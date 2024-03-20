import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/pages/login_page.dart';
import 'package:podcast_app/pages/root_page.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_userController.currentUser.value.id != null &&
          _userController.currentUser.value.id != "") {
        return RootPage();
      } else {
        return LoginPage();
      }
    });
  }
}
