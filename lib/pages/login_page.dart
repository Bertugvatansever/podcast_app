import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 85.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: Text(
                "Email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.sp,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor().textFieldColor),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      hintText: "Your Email Adress",
                      hintStyle: TextStyle(
                          color: AppColor().textFieldTextcolor,
                          fontSize: 18.sp)),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: Text(
                "Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.sp,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor().textFieldColor),
                child: TextField(
                  controller: _passwordController,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      hintText: "Your Password ",
                      hintStyle: TextStyle(
                          color: AppColor().textFieldTextcolor,
                          fontSize: 18.sp)),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {
                _userController.signIn(
                    _emailController.text, _passwordController.text);
              },
              child:
                  Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(150.w, 50.h),
                  backgroundColor: AppColor().primaryColor,
                  foregroundColor: Colors.white),
            )),
            SizedBox(
              height: 200.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0.w),
                  child: SizedBox(
                    width: 180.w,
                    height: 60.h,
                    child: Text(
                      "Don't have the account ?",
                      style: TextStyle(
                          color: AppColor().primaryColor, fontSize: 19.sp),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0.w),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => RegisterPage());
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100.w, 50.h),
                        backgroundColor: AppColor().primaryColor,
                        foregroundColor: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
