import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/pages/follow_page.dart';
import 'package:podcast_app/pages/profile_page.dart';
import 'package:podcast_app/widgets/my_library.dart';
import 'package:podcast_app/widgets/my_profile_edit.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  PodcastController _podcastController = Get.find();
  UserController _userController = Get.find();
  Map<String, String>? followMap = {"follow": "0", "followers": "0"};
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });

    _userController
        .calculateFollowCount(_userController.currentUser.value.id!)
        .then((value) {
      setState(() {
        followMap = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _userController.isProfileEdit.value
          ? MyProfileEdit()
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor.withOpacity(0.9),
                        AppColor.primaryColor.withOpacity(0.8),
                        AppColor.primaryColor.withOpacity(0.7),
                        AppColor.primaryColor.withOpacity(0.6),
                        AppColor.primaryColor.withOpacity(0.5),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 15.w, top: 80.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 60.w,
                                child: _userController.isProfilePhoto.value
                                    ? ClipOval(
                                        child: Image.file(
                                          width: 140.w,
                                          height: 140.h,
                                          _userController
                                              .profilePhotoFile.value,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text(
                                        _userController.currentUser.value.name!
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 70.sp),
                                      ),
                              ),
                              SizedBox(
                                width: 13.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 7.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(ProfilePage(
                                            profileUser: _userController
                                                .currentUser.value));
                                      },
                                      child: Text(
                                        _userController.currentUser.value.name!
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: Row(
                                        children: [
                                          Text(
                                            maxLines: 1,
                                            followMap?["followers"]!.length == 5
                                                ? followMap!["followers"]!
                                                        .substring(0, 2) +
                                                    "B"
                                                : followMap?["followers"]!.length ==
                                                        6
                                                    ? followMap!["followers"]!
                                                            .substring(0, 3) +
                                                        "B"
                                                    : followMap?["followers"]!.length ==
                                                            7
                                                        ? followMap!["followers"]!.substring(0, 1) +
                                                            "." +
                                                            followMap!["followers"]!
                                                                .substring(
                                                                    1, 2) +
                                                            "M"
                                                        : followMap?["followers"]!
                                                                    .length ==
                                                                8
                                                            ? followMap!["followers"]!
                                                                    .substring(
                                                                        0, 2) +
                                                                "." +
                                                                followMap!["followers"]!
                                                                    .substring(
                                                                        2, 3) +
                                                                "M"
                                                            : followMap?["followers"] ??
                                                                "0",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              followMap = await Get.to(
                                                  () => FollowPage());
                                              setState(() {});
                                            },
                                            child: Text(
                                              "Followers",
                                              style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            maxLines: 1,
                                            followMap?["follow"]!.length == 5
                                                ? followMap!["follow"]!.substring(0, 2) +
                                                    "B"
                                                : followMap?["follow"]!.length ==
                                                        6
                                                    ? followMap!["follow"]!
                                                            .substring(0, 3) +
                                                        "B"
                                                    : followMap?["follow"]!
                                                                .length ==
                                                            7
                                                        ? followMap!["follow"]!
                                                                .substring(
                                                                    0, 1) +
                                                            "." +
                                                            followMap!["follow"]!
                                                                .substring(
                                                                    1, 2) +
                                                            "M"
                                                        : followMap?["follow"]!
                                                                    .length ==
                                                                8
                                                            ? followMap!["follow"]!
                                                                    .substring(
                                                                        0, 2) +
                                                                "." +
                                                                followMap!["follow"]!
                                                                    .substring(2, 3) +
                                                                "M"
                                                            : followMap?["follow"] ?? "0",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              followMap = await Get.to(
                                                  () => FollowPage());
                                              setState(() {});
                                            },
                                            child: Text(
                                              "Follow",
                                              style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    _userController.isProfileEdit.value = true;
                                  },
                                  child: Text(
                                    "Profili Düzenle",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.solidShareFromSquare,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.bookOpen,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                print(followMap!["followers"]);
                                print(followMap!["follow"]);
                                await _podcastController.getMyPodcasts(
                                    _userController.currentUser.value.id!);
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MyLibrary();
                                    });
                              },
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.greenAccent,
                                      title: Text(
                                        "Çıkış yapmak istediğinize emin misiniz ?",
                                        style: TextStyle(color: AppColor.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  await _userController
                                                      .signOut();
                                                  _userController
                                                          .beforeUserId.value =
                                                      _userController
                                                          .currentUser
                                                          .value
                                                          .id!;
                                                  _userController
                                                          .currentUser.value =
                                                      User(
                                                          id: "",
                                                          name: "",
                                                          surName: "",
                                                          photo: "",
                                                          email: "",
                                                          createdTime: 0,
                                                          favourite: [],
                                                          myRatings: {});
                                                  _userController.isProfilePhoto
                                                      .value = false;

                                                  Get.back();
                                                  _userController
                                                      .currentIndex.value = 0;
                                                },
                                                child: Text(
                                                  "Evet",
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontSize: 17.sp,
                                                  ),
                                                )),
                                            SizedBox(
                                              width: 47.w,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text("Hayır",
                                                    style: TextStyle(
                                                        color: AppColor.white,
                                                        fontSize: 17.sp))),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                size: 30,
                                Icons.logout,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 175.h,
                      ),
                      Text(
                        "Yakınlarda hiç hareket yok.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text("Yeni podcastlere göz at ",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
    );
  }
}
