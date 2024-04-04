import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/user_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 45.h,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0.w),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
                    color: AppColor.textFieldColor),
                child: TextField(
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
                    color: AppColor.textFieldColor),
                child: TextField(
                  controller: _passwordController,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      hintText: "Your Password ",
                      hintStyle: TextStyle(
                          color: AppColor.textFieldTextcolor, fontSize: 18.sp)),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: Text(
                "Name",
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
                    color: AppColor.textFieldColor),
                child: TextField(
                  controller: _nameController,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      hintText: "Your Name",
                      hintStyle: TextStyle(
                          color: AppColor.textFieldTextcolor, fontSize: 18.sp)),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: Text(
                "Surname",
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
                    color: AppColor.textFieldColor),
                child: TextField(
                  controller: _surnameController,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      hintText: "Your Surname",
                      hintStyle: TextStyle(
                          color: AppColor.textFieldTextcolor, fontSize: 18.sp)),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            SizedBox(
              height: 25.h,
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {
                _userController.saveRegisterUser(
                    _emailController.text,
                    _passwordController.text,
                    _nameController.text,
                    _surnameController.text);
              },
              child: Text("Register",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(150.w, 50.h),
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}
