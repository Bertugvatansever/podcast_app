import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/user_controller.dart';

class MyProfileEdit extends StatefulWidget {
  const MyProfileEdit({super.key});

  @override
  State<MyProfileEdit> createState() => _MyProfileEditState();
}

class _MyProfileEditState extends State<MyProfileEdit> {
  UserController _userController = Get.find();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  bool onChangedName = false;
  bool onChangedSurname = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = _userController.currentUser.value.name!;
    _surnameController.text = _userController.currentUser.value.surName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _userController.isProfileEdit.value = false;
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.white,
            )),
        backgroundColor: AppColor.backgroundColor,
        title: Text(
          "My Profile",
          style: TextStyle(color: AppColor.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(left: 73.w),
                    child: CircleAvatar(
                      backgroundColor: _userController.isProfilePhoto.value
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.primaryContainer,
                      radius: 90.w,
                      child: _userController.isProfilePhoto.value
                          // Yuvarlak kesmek için Clip Oval kullanıyoruz.
                          ? ClipOval(
                              child: Image.file(
                                width: 180.w,
                                height: 180.h,
                                _userController.profilePhotoFile.value,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                _userController.currentUser.value.name!
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(fontSize: 65.sp),
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 110.h),
                  child: Container(
                    width: 60.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColor.primaryColor),
                    child: IconButton(
                        onPressed: () async {
                          await _userController.selectProfilePhoto();
                        },
                        icon: Icon(
                          Icons.photo_camera,
                          size: 20,
                          color: AppColor.white,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 17.w),
              child: Text(
                "${_userController.currentUser.value.name} ${_userController.currentUser.value.surName}",
                style: TextStyle(
                    color: AppColor.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Name",
                style: TextStyle(color: AppColor.white, fontSize: 20.sp),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              width: 325.w,
              height: 50.h,
              decoration: BoxDecoration(
                  color: AppColor.textFieldColor,
                  border: Border.all(
                    color: AppColor.primaryColor,
                    width: 1.5.w,
                  )),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    if (_nameController.text ==
                        _userController.currentUser.value.name) {
                      onChangedName = false;
                    } else {
                      onChangedName = true;
                    }
                  });
                },
                textAlign: TextAlign.center,
                enableSuggestions: false,
                style: TextStyle(color: AppColor.white.withOpacity(0.5)),
                controller: _nameController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Surname",
                style: TextStyle(color: AppColor.white, fontSize: 20.sp),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              width: 325.w,
              height: 50.h,
              decoration: BoxDecoration(
                  color: AppColor.textFieldColor,
                  border: Border.all(
                    color: AppColor.primaryColor,
                    width: 1.5.w,
                  )),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    if (_surnameController.text ==
                        _userController.currentUser.value.surName) {
                      onChangedSurname = false;
                    } else {
                      onChangedSurname = true;
                    }
                  });
                },
                textAlign: TextAlign.center,
                enableSuggestions: false,
                style: TextStyle(color: AppColor.white.withOpacity(0.5)),
                controller: _surnameController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    disabledBackgroundColor: AppColor.textFieldColor,
                    minimumSize: Size(200.w, 45.h)),
                onPressed: onChangedName ||
                        onChangedSurname ||
                        _userController.isProfilePhotoChange.value
                    ? () {
                        if (_userController.isProfilePhotoChange.value) {
                          _userController.saveProfilePhoto(
                              _userController.currentUser.value.id!,
                              _userController.currentUser.value.name!,
                              _userController.profilePhotoFile.value);
                          _userController.saveProfilePhotoLocalDb(
                              _userController.profilePhotoFile.value,
                              _userController.currentUser.value.name!);
                          _userController.isProfilePhotoChange.value = false;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColor.primaryColor,
                              showCloseIcon: true,
                              content: Center(
                                child:
                                    Text("Profil fotoğrafınız değiştirildi !"),
                              )));
                        }
                        if (onChangedName || onChangedSurname) {
                          _userController.changeNameSurname(
                              _nameController.text,
                              _surnameController.text,
                              _userController.currentUser.value.id!,
                              onChangedName,
                              onChangedSurname);
                          setState(() {
                            onChangedName = false;
                            onChangedSurname = false;
                            _userController.isProfilePhotoChange.value = false;
                          });
                          _userController.currentUser.value.name =
                              _nameController.text;
                          _userController.currentUser.value.surName =
                              _surnameController.text;

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColor.primaryColor,
                              showCloseIcon: true,
                              content: Center(
                                child: Text("Değişiklikler Kaydedildi ! "),
                              )));
                        }
                      }
                    : null,
                child: Text(
                  "Confirm Changes",
                  style: TextStyle(
                      color: onChangedName ||
                              onChangedSurname ||
                              _userController.isProfilePhotoChange.value
                          ? AppColor.white
                          : AppColor.white.withOpacity(0.5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
