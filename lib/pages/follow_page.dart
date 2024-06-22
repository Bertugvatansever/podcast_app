import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/pages/podcast_page.dart';
import 'package:podcast_app/pages/profile_page.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({
    super.key,
  });
  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  UserController _userController = Get.find();
  PodcastController _podcastController = Get.find();
  bool isLoading = false;
  bool podcasts = true;
  bool users = false;
  bool unFollow = false;
  Map<String, String>? followMap = {"follow": "0", "followers": "0"};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    _userController.getFollow(_userController.currentUser.value.id!).then((_) {
      _userController
          .getFollowers(_userController.currentUser.value.id!)
          .then((_) {
        setState(() {
          followMap!["followers"] =
              _userController.followersUserList.length.toString();
          followMap!["follow"] = (_userController.followPodcastList.length +
                  _userController.followUserList.length)
              .toString();
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${_userController.currentUser.value.name!} ${_userController.currentUser.value.surName!}",
            style: TextStyle(color: AppColor.white),
          ),
          centerTitle: true,
          leading: IconButton(
              color: AppColor.white,
              onPressed: () {
                Get.back(result: {
                  "follow": (_userController.followPodcastList.length +
                          _userController.followUserList.length)
                      .toString(),
                  "followers":
                      (_userController.followersUserList.length).toString()
                });
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: AppColor.backgroundColor,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              )
            : DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                        splashFactory: NoSplash.splashFactory,
                        labelPadding: EdgeInsets.only(top: 25.h, bottom: 12.h),
                        unselectedLabelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicatorColor: AppColor.primaryColor,
                        labelColor: AppColor.primaryColor.withOpacity(0.8),
                        tabs: [
                          Text("${followMap!["follow"]} Follow"),
                          Text("${followMap!["followers"]} Followers")
                        ]),
                    Expanded(
                      child: TabBarView(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.h, left: 18.w),
                              child: Row(
                                children: [
                                  Text(
                                    podcasts
                                        ? "Follow Podcasts"
                                        : "Follow Users",
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.change_circle_rounded,
                                      color: AppColor.white,
                                      size: 40,
                                    ),
                                    onSelected: (value) {
                                      if (value == "podcast") {
                                        setState(() {
                                          podcasts = true;
                                          users = false;
                                        });
                                      } else if (value == "user") {
                                        setState(() {
                                          users = true;
                                          podcasts = false;
                                        });
                                      }
                                    },
                                    offset: Offset(110.w, -12.h),
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem<String>(
                                        value: 'podcast',
                                        child: Text('Podcasts'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'user',
                                        child: Text('Users'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Obx(
                              () => Expanded(
                                child: ListView.builder(
                                  itemCount: podcasts
                                      ? _userController.followPodcastList.length
                                      : _userController.followUserList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String photoUrl = podcasts
                                        ? _userController
                                            .followPodcastList[index].photo!
                                        : _userController
                                            .followUserList[index].photo!;
                                    return InkWell(
                                      onTap: () async {
                                        podcasts
                                            ? followMap = await Get.to(() =>
                                                PodcastPage(
                                                    podcast: _userController
                                                            .followPodcastList[
                                                        index]))
                                            : followMap = await Get.to(
                                                ProfilePage(
                                                    profileUser: _userController
                                                            .followUserList[
                                                        index]));
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 24.h),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 12.w),
                                              child: Container(
                                                width: 65.w,
                                                height: 65.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        Colors.grey.shade900),
                                                child: ClipOval(
                                                  child: photoUrl.isNotEmpty
                                                      ? Image.network(
                                                          podcasts
                                                              ? _userController
                                                                  .followPodcastList[
                                                                      index]
                                                                  .photo!
                                                              : _userController
                                                                  .followUserList[
                                                                      index]
                                                                  .photo!,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            } else {
                                                              return Center(
                                                                  child:
                                                                      SizedBox(
                                                                height: 25.h,
                                                                width: 25.w,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                ),
                                                              ));
                                                            }
                                                          },
                                                        )
                                                      : Icon(
                                                          Icons.person,
                                                          size: 45,
                                                          color: Colors.grey,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 21.w,
                                            ),
                                            Column(
                                              children: [
                                                podcasts
                                                    ? Text(
                                                        _userController
                                                            .followPodcastList[
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                            color:
                                                                AppColor.white,
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : SizedBox(),
                                                SizedBox(
                                                  height: 6.h,
                                                ),
                                                Text(
                                                    podcasts
                                                        ? "${_userController.followPodcastList[index].user!.name} ${_userController.followPodcastList[index].user!.surName}"
                                                        : "${_userController.followUserList[index].name} ${_userController.followUserList[index].surName}",
                                                    style: TextStyle(
                                                        color: AppColor.white,
                                                        fontSize: 18.sp))
                                              ],
                                            ),
                                            SizedBox(
                                              width: 21.w,
                                            ),
                                            AnimatedButton(
                                                color: Colors.red,
                                                isFixedHeight: false,
                                                width: 105.w,
                                                height: 35.h,
                                                text: "UnFollow",
                                                buttonTextStyle: TextStyle(
                                                  color: AppColor.white,
                                                ),
                                                pressEvent: () async {
                                                  bool unFollow =
                                                      await _showAlertDialog(
                                                          context);
                                                  if (unFollow) {
                                                    if (podcasts) {
                                                      await _userController
                                                          .unFollow(
                                                        _userController
                                                            .currentUser
                                                            .value
                                                            .id!,
                                                        _userController
                                                            .followPodcastList[
                                                                index]
                                                            .id!,
                                                        true,
                                                      );
                                                      _userController
                                                          .followPodcastList
                                                          .removeAt(index);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              AppColor
                                                                  .primaryColor,
                                                          showCloseIcon: true,
                                                          content: Center(
                                                            child: Text(
                                                                "Takipten çıkıldı!"),
                                                          ),
                                                        ),
                                                      );
                                                      setState(() {
                                                        followMap![
                                                            "follow"] = (_userController
                                                                    .followPodcastList
                                                                    .length +
                                                                _userController
                                                                    .followUserList
                                                                    .length)
                                                            .toString();
                                                      });
                                                    } else {
                                                      await _userController
                                                          .unFollow(
                                                        _userController
                                                            .currentUser
                                                            .value
                                                            .id!,
                                                        _userController
                                                            .followUserList[
                                                                index]
                                                            .id!,
                                                        false,
                                                      );
                                                      _userController
                                                          .followUserList
                                                          .removeAt(index);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              AppColor
                                                                  .primaryColor,
                                                          showCloseIcon: true,
                                                          content: Center(
                                                            child: Text(
                                                                "Takipten çıkıldı!"),
                                                          ),
                                                        ),
                                                      );
                                                      setState(() {
                                                        followMap![
                                                            "follow"] = (_userController
                                                                    .followPodcastList
                                                                    .length +
                                                                _userController
                                                                    .followUserList
                                                                    .length)
                                                            .toString();
                                                      });
                                                    }
                                                  }
                                                })
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.h, left: 18.w),
                              child: Row(
                                children: [
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Obx(
                              () => Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      _userController.followersUserList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 24.h),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 12.w),
                                            child: Container(
                                              width: 65.w,
                                              height: 65.h,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade900),
                                              child: ClipOval(
                                                  child: _userController
                                                          .followersUserList[
                                                              index]
                                                          .photo!
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          _userController
                                                              .followersUserList[
                                                                  index]
                                                              .photo!,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            } else {
                                                              return Center(
                                                                  child:
                                                                      SizedBox(
                                                                height: 25.h,
                                                                width: 25.w,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                ),
                                                              ));
                                                            }
                                                          },
                                                        )
                                                      : Icon(
                                                          Icons.person,
                                                          size: 45,
                                                          color: Colors.grey,
                                                        )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 21.w,
                                          ),
                                          Text(
                                              "${_userController.followersUserList[index].name} ${_userController.followersUserList[index].surName}",
                                              style: TextStyle(
                                                  color: AppColor.white,
                                                  fontSize: 18.sp)),
                                          SizedBox(
                                            width: 21.w,
                                          ),
                                          AnimatedButton(
                                            color: AppColor.primaryColor,
                                            isFixedHeight: false,
                                            width: 105.w,
                                            height: 35.h,
                                            text: "Go Profile",
                                            buttonTextStyle: TextStyle(
                                              color: AppColor.white,
                                            ),
                                            pressEvent: () async {
                                              followMap = await Get.to(ProfilePage(
                                                  profileUser: _userController
                                                          .followersUserList[
                                                      index]));
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    )
                  ],
                )));
  }

  Future<bool> _showAlertDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unfollow'),
          content: Text('Are you sure you want to unfollow?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Get.back(result: false); // Hayır seçeneğine basıldığında
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Get.back(result: true); // Evet seçeneğine basıldığında
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // null kontrolü yaparak false döndür
  }
}
