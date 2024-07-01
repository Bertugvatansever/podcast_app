import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
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
        if (_userController.isLoadingLogin.value) {
          return Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            color: AppColor.backgroundColor,
            // LOGO GELİCEK CENTERA
            child: Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
          );
        } else {
          return LoginPage();
        }
      }
    });
  }
}
