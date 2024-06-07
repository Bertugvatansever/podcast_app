import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/user_controller.dart';

class SaveAccountPage extends StatefulWidget {
  const SaveAccountPage({super.key});

  @override
  State<SaveAccountPage> createState() => _SaveAccountPageState();
}

class _SaveAccountPageState extends State<SaveAccountPage> {
  TextEditingController _emailController = TextEditingController();
  UserController _userController = Get.find();
  bool confirm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Enter your email and reset your ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Center(
            child: Text(
              "password with the code we sent you.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.w),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.textFieldColor),
              child: Align(
                alignment: Alignment.center,
                child: TextField(
                  cursorColor: AppColor.primaryColor.withOpacity(0.5),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      hintText: "Your Email Adress",
                      hintStyle: TextStyle(
                          color: AppColor.textFieldTextcolor, fontSize: 18.sp)),
                ),
              ),
              width: 340.w,
              height: 50.h,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Center(
              child: ElevatedButton(
            onPressed: () async {
              confirm =
                  await _userController.resetPassword(_emailController.text);
              if (confirm) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColor.primaryColor,
                    showCloseIcon: true,
                    content: Center(
                      child: Text("Mesaj başarıyla gönderildi"),
                    )));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    showCloseIcon: true,
                    content: Center(
                      child: Text("Mesaj gönderilirken bir hata oldu"),
                    )));
              }
            },
            child: Text("Send Code",
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(150.w, 43.h),
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white),
          )),
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Go back",
                style: TextStyle(color: AppColor.primaryColor, fontSize: 18.sp),
              ),
              style: ButtonStyle(splashFactory: NoSplash.splashFactory),
            ),
          )
        ],
      ),
    );
  }
}
