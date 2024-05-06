import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  bool isVisibility = false;
  bool emailText = false;
  bool passwordText = false;
  bool passwordEmptyText = false;
  bool confirmText = false;
  bool nameText = false;
  bool surnameText = false;

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
              height: 25.h,
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
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        emailText = false;
                      }
                    },
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        hintText: "Your Email Adress",
                        hintStyle: TextStyle(
                            color: AppColor.textFieldTextcolor,
                            fontSize: 18.sp)),
                  ),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            emailText
                ? Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 5.h),
                    child: Text(
                      "This field cannot be left blank",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
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
                child: Row(
                  children: [
                    SizedBox(
                      width: 290.w,
                      child: TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            passwordEmptyText = false;
                          }
                        },
                        obscureText: isVisibility ? false : true,
                        style: TextStyle(color: AppColor.white),
                        controller: _passwordController,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.w),
                            hintText: "Your Password ",
                            hintStyle: TextStyle(
                                color: AppColor.textFieldTextcolor,
                                fontSize: 18.sp)),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isVisibility = !isVisibility;
                          });
                        },
                        icon: Icon(
                          size: 25.sp,
                          isVisibility
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColor.primaryColor,
                        ))
                  ],
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            passwordText
                ? Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 5.h),
                    child: Text(
                      "Passwords do not match",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            passwordEmptyText
                ? Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 5.h),
                    child: Text(
                      "This field cannot be left blank",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 25.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: Text(
                "Confirm Your Password",
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
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        confirmText = false;
                      }
                    },
                    obscureText: isVisibility ? false : true,
                    style: TextStyle(color: AppColor.white),
                    controller: _confirmPasswordController,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        hintText: "Confirm Your Password ",
                        hintStyle: TextStyle(
                            color: AppColor.textFieldTextcolor,
                            fontSize: 18.sp)),
                  ),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            confirmText
                ? Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 5.h),
                    child: Text(
                      "This field cannot be left blank",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 25.h,
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
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        nameText = false;
                      }
                    },
                    style: TextStyle(color: AppColor.white),
                    controller: _nameController,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        hintText: "Your Name",
                        hintStyle: TextStyle(
                            color: AppColor.textFieldTextcolor,
                            fontSize: 18.sp)),
                  ),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            nameText
                ? Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 5.h),
                    child: Text(
                      "This field cannot be left blank",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 25.h,
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
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        surnameText = false;
                      }
                    },
                    style: TextStyle(color: AppColor.white),
                    controller: _surnameController,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        hintText: "Your Surname",
                        hintStyle: TextStyle(
                            color: AppColor.textFieldTextcolor,
                            fontSize: 18.sp)),
                  ),
                ),
                width: 340.w,
                height: 50.h,
              ),
            ),
            surnameText
                ? Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 5.h),
                    child: Text(
                      "This field cannot be left blank",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 25.h,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: Center(
                  child: ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty &&
                      _confirmPasswordController.text.isNotEmpty &&
                      _nameController.text.isNotEmpty &&
                      _surnameController.text.isNotEmpty) {
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      bool confirm = await _userController.saveRegisterUser(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _surnameController.text);
                      confirm
                          ? setState(() {
                              emailText = false;
                              passwordText = false;
                              passwordEmptyText = false;
                              confirmText = false;
                              nameText = false;
                              surnameText = false;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      backgroundColor: AppColor.primaryColor,
                                      showCloseIcon: true,
                                      content: Center(
                                        child: Text("Başarıyla Kayıt olundu"),
                                      )));
                              Get.to(() => HomePage());
                            })
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              showCloseIcon: true,
                              content: Center(
                                child:
                                    Text("Kayıt olurken bir hata gerçekleşti"),
                              )));
                    } else {
                      setState(() {
                        passwordText = true;
                      });
                    }
                  } else {
                    if (_emailController.text.isEmpty) {
                      setState(() {
                        emailText = true;
                      });
                    }
                    if (_passwordController.text.isEmpty) {
                      setState(() {
                        passwordEmptyText = true;
                      });
                    }
                    if (_confirmPasswordController.text.isEmpty) {
                      setState(() {
                        confirmText = true;
                      });
                    }
                    if (_nameController.text.isEmpty) {
                      setState(() {
                        nameText = true;
                      });
                    }
                    if (_surnameController.text.isEmpty) {
                      setState(() {
                        surnameText = true;
                      });
                    }
                  }
                },
                child: Text("Register",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(150.w, 50.h),
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
