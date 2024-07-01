import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/pages/podcast_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profileUser});
  final User profileUser;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PodcastController _podcastController = Get.find();
  UserController _userController = Get.find();
  bool isFollow = false;
  Map<String, String>? followMap;
  String? podcastCount;
  bool isLoading = false;
  bool myProfile = false;
  @override
  void initState() {
    // TODO: TAKİP EDİP ETMEDİĞİNİ HER GİRİŞTE KONTROL ET.
    super.initState();

    setState(() {
      isFollow = _userController.followUserList
          .any((user) => user.id == widget.profileUser.id);
      isLoading = true;
    });
    _podcastController.getProfilePodcasts(widget.profileUser.id!);
    _userController.calculateFollowCount(widget.profileUser.id!).then((value) {
      setState(() {
        followMap = value;
      });
    });
    _userController.calculatePodcastCount(widget.profileUser.id!).then((value) {
      setState(() {
        podcastCount = value;
        isLoading = false;
      });
    });
    if (_userController.currentUser.value.id == widget.profileUser.id) {
      setState(() {
        myProfile = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ))
            : SingleChildScrollView(
                child: Container(
                  width: ScreenUtil().screenWidth,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              width: ScreenUtil().screenWidth,
                              height: 400.h,
                              child: widget.profileUser.photo!.isNotEmpty
                                  ? Image.network(
                                      width: ScreenUtil().screenWidth,
                                      height: 400.h,
                                      widget.profileUser.photo!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColor.primaryColor,
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : Image.asset(
                                      "assets/profile_photo.jpg",
                                      fit: BoxFit.cover,
                                    )),
                          Positioned(
                            bottom: -7.h,
                            child: SizedBox(
                              width: ScreenUtil().screenWidth,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: AutoSizeText(
                                  maxLines: 1,
                                  "${widget.profileUser.name} ${widget.profileUser.surName}"
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                followMap?["followers"]!.length == 6
                                    ? followMap!["followers"]!.substring(0, 3) +
                                        "B"
                                    : followMap?["followers"]!.length == 7
                                        ? followMap!["followers"]!
                                                .substring(0, 1) +
                                            "." +
                                            followMap!["followers"]!
                                                .substring(1, 2) +
                                            "M"
                                        : followMap?["followers"]!.length == 8
                                            ? followMap!["followers"]!
                                                    .substring(0, 2) +
                                                "." +
                                                followMap!["followers"]!
                                                    .substring(2, 3) +
                                                "M"
                                            : followMap?["followers"] ?? "0",
                                style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                "Takipçi",
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 17.sp),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                followMap?["follow"]!.length == 6
                                    ? followMap!["follow"]!.substring(0, 3) +
                                        "B"
                                    : followMap?["follow"]!.length == 7
                                        ? followMap!["follow"]!
                                                .substring(0, 1) +
                                            "." +
                                            followMap!["follow"]!
                                                .substring(1, 2) +
                                            "M"
                                        : followMap?["follow"]!.length == 8
                                            ? followMap!["follow"]!
                                                    .substring(0, 2) +
                                                "." +
                                                followMap!["follow"]!
                                                    .substring(2, 3) +
                                                "M"
                                            : followMap?["follow"] ?? "0",
                                style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                "Takip Edilen",
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 17.sp),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                podcastCount ?? "0",
                                style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                "Podcast Sayısı",
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 17.sp),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: myProfile
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceAround,
                        children: [
                          myProfile
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: IconButton(
                                      onPressed: () {
                                        Get.back(result: {
                                          "follow": (_userController
                                                      .followPodcastList
                                                      .length +
                                                  _userController
                                                      .followUserList.length)
                                              .toString(),
                                          "followers": (_userController
                                                  .followersUserList.length)
                                              .toString()
                                        });
                                      },
                                      icon: Container(
                                        width: 41.w,
                                        height: 41.h,
                                        decoration: BoxDecoration(
                                            color: AppColor.primaryColor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.backward,
                                            color: AppColor.white,
                                            size: 17,
                                          ),
                                        ),
                                      )),
                                ),
                          myProfile
                              ? IconButton(
                                  onPressed: () {
                                    Get.back(result: {
                                      "follow": (_userController
                                                  .followPodcastList.length +
                                              _userController
                                                  .followUserList.length)
                                          .toString(),
                                      "followers": (_userController
                                              .followersUserList.length)
                                          .toString()
                                    });
                                  },
                                  icon: Container(
                                    width: 250.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Go Back",
                                      style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                  ))
                              : SizedBox(),
                          myProfile
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(right: 13.w),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          isFollow = !isFollow;
                                        });
                                        if (isFollow) {
                                          await _userController.follow(
                                              _userController
                                                  .currentUser.value.id!,
                                              widget.profileUser.id!,
                                              false);
                                          _userController.followUserList
                                              .add(widget.profileUser);
                                        } else {
                                          await _userController.unFollow(
                                              _userController
                                                  .currentUser.value.id!,
                                              widget.profileUser.id!,
                                              false);
                                          _userController.followUserList
                                              .removeWhere((user) =>
                                                  user.id ==
                                                  widget.profileUser.id);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColor.primaryColor,
                                          foregroundColor: AppColor.white,
                                          minimumSize: Size(200.w, 35.h)),
                                      child: Text(isFollow
                                          ? "Takip ediliyor"
                                          : "Takip et")),
                                ),
                          myProfile
                              ? SizedBox()
                              : IconButton(
                                  onPressed: () {},
                                  icon: Container(
                                    width: 41.w,
                                    height: 41.h,
                                    decoration: BoxDecoration(
                                        color: AppColor.primaryColor,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Icon(
                                        Icons.block_sharp,
                                        color: AppColor.white,
                                        size: 23,
                                      ),
                                    ),
                                  )),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Podcasts",
                        style:
                            TextStyle(color: AppColor.white, fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Obx(
                        () => SizedBox(
                            width: ScreenUtil().screenWidth,
                            height:
                                _podcastController.profilePodcastList.length *
                                    125.h,
                            child: _podcastController
                                    .profilePodcastList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: _podcastController
                                        .profilePodcastList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => PodcastPage(
                                              podcast: _podcastController
                                                  .profilePodcastList[index]));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.w, bottom: 15.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 110.w,
                                                height: 110.h,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color:
                                                        Colors.grey.shade900),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    width: 110.w,
                                                    height: 110.h,
                                                    _podcastController
                                                        .profilePodcastList[
                                                            index]
                                                        .photo!,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child; // Resim yüklendikten sonra gösterilecek widget
                                                      } else {
                                                        return Center(
                                                            child: CircularProgressIndicator(
                                                                color: AppColor
                                                                    .primaryColor)); // Yükleme esnasında gösterilecek widget
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.h, left: 15.w),
                                                    child: SizedBox(
                                                      width: 250.w,
                                                      child: Text(
                                                        _podcastController
                                                            .profilePodcastList[
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.h, left: 15.w),
                                                    child: SizedBox(
                                                      width: 250.w,
                                                      child: Text(
                                                          "${_podcastController.profilePodcastList[index].user!.name!} ${_podcastController.profilePodcastList[index].user!.surName!}",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontSize: 18.sp,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      "No Podcasts Found",
                                      style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 24.sp),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
