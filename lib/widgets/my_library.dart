import 'dart:io';

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
import 'package:podcast_app/models/download.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/pages/podcast_add_page.dart';
import 'package:podcast_app/pages/podcast_listen_page.dart';
import 'package:podcast_app/pages/podcast_page.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  PodcastController _podcastController = Get.find();
  UserController _userController = Get.find();

  bool myPodcasts = true;
  bool downloads = false;
  bool favorites = false;

  @override
  Widget build(BuildContext context) {
    List<Podcast> podcastList = myPodcasts
        ? _podcastController.myPodcasts
        : favorites
            ? _podcastController.favouriteList
            : _podcastController.myPodcasts;
    return Container(
      height: ScreenUtil().screenHeight / 1.12.h,
      decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Divider(
            indent: 150.w,
            endIndent: 150.w,
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Library",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 13.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    print(_podcastController.myPodcasts.length);

                    setState(() {
                      myPodcasts = true;
                      downloads = false;
                      favorites = false;
                      print(myPodcasts);
                    });
                    _podcastController.isActiveDownloadListen.value = false;
                  },
                  child: Container(
                    width: 122.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: myPodcasts
                            ? AppColor.primaryColor
                            : AppColor.textFieldColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "My Podcasts",
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: myPodcasts
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      downloads = true;
                      myPodcasts = false;
                      favorites = false;
                    });
                    await _podcastController.getDownloadsPodcast();
                    _podcastController.isActiveDownloadListen.value = true;
                  },
                  child: Container(
                    width: 122.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: downloads
                            ? AppColor.primaryColor
                            : AppColor.textFieldColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "Downloads",
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: downloads
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await _podcastController.getFavouritePodcasts(
                        _userController.currentUser.value.id!);

                    setState(() {
                      favorites = true;
                      myPodcasts = false;
                      downloads = false;
                    });
                    _podcastController.isActiveDownloadListen.value = false;
                  },
                  child: Container(
                    width: 122.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: favorites
                            ? AppColor.primaryColor
                            : AppColor.textFieldColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "Favorites",
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: favorites
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Obx(
            () => SizedBox(
                width: ScreenUtil().screenWidth,
                height: 500.h,
                child: podcastList.isNotEmpty ||
                        _podcastController.downloadsList.isNotEmpty
                    ? ListView.builder(
                        itemCount: downloads
                            ? _podcastController.downloadsList.length
                            : podcastList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (_podcastController
                                  .isActiveDownloadListen.value) {
                                _podcastController.audioPlayer.setFilePath(
                                    _podcastController
                                        .downloadsList[index].uri!);
                                Get.to(PodcastListenPage(
                                    episodeId: _podcastController
                                        .downloadsList[index].podcastEpisodeId!,
                                    podcastId: _podcastController
                                        .downloadsList[index].podcastId!));
                              } else {
                                Get.to(
                                    PodcastPage(podcast: podcastList[index]));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10.w, bottom: 12.h, top: 10.h),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (_podcastController
                                          .isActiveDownloadListen.value) {
                                        _podcastController.audioPlayer
                                            .setFilePath(_podcastController
                                                .downloadsList[index].uri!);
                                        Get.to(PodcastListenPage(
                                            episodeId: _podcastController
                                                .downloadsList[index]
                                                .podcastEpisodeId!,
                                            podcastId: _podcastController
                                                .downloadsList[index]
                                                .podcastId!));
                                      } else {
                                        Get.to(PodcastPage(
                                            podcast: podcastList[index]));
                                      }
                                    },
                                    child: downloads
                                        ? Container(
                                            width: 95.w,
                                            height: 95.h,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              child: Image.file(
                                                File(_podcastController
                                                    .downloadsList[index]
                                                    .podcastEpisodePhoto!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 95.w,
                                            height: 95.h,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              child: Image.network(
                                                width: 95.w,
                                                height: 95.h,
                                                podcastList[index].photo!,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color:
                                                          AppColor.primaryColor,
                                                    ));
                                                  }
                                                },
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade900,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 18.w,
                                  ),
                                  SizedBox(
                                    height: 90.h,
                                    width: 210.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            downloads
                                                ? _podcastController
                                                    .downloadsList[index]
                                                    .podcastName!
                                                : podcastList[index].name!,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            downloads
                                                ? _podcastController
                                                    .downloadsList[index]
                                                    .podcastOwner!
                                                : "${podcastList[index].user!.name!} ${podcastList[index].user!.surName!}",
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 14.sp),
                                          ),
                                        ),
                                        downloads
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: 3.h,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      _podcastController
                                                          .downloadsList[index]
                                                          .podcastEpisodeName!,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade400,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                        myPodcasts
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AnimatedButton(
                                                      pressEvent: () {
                                                        _podcastController
                                                            .startPage
                                                            .value = false;
                                                        _podcastController
                                                            .addNewEpisode
                                                            .value = true;
                                                        Get.to(() => PodcastAdd(
                                                              podcast:
                                                                  podcastList[
                                                                      index],
                                                            ));
                                                      },
                                                      text: "Add Episode",
                                                      color:
                                                          AppColor.primaryColor,
                                                      width: 150.w,
                                                      height: 35.h,
                                                      isFixedHeight: false,
                                                      buttonTextStyle:
                                                          TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColor
                                                                  .white),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 8.h, right: 3.w),
                                      child: IconButton(
                                          onPressed: (favorites || downloads)
                                              ? () async {
                                                  Get.snackbar(
                                                      favorites
                                                          ? podcastList[index]
                                                              .name!
                                                          : _podcastController
                                                              .downloadsList[
                                                                  index]
                                                              .podcastName!,
                                                      favorites
                                                          ? 'Podcast favorilerden kaldırıldı !'
                                                          : 'Podcast indirilenlerden silindi !',
                                                      backgroundColor:
                                                          Colors.red,
                                                      colorText: Colors.white,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      duration:
                                                          Duration(seconds: 3),
                                                      dismissDirection:
                                                          DismissDirection
                                                              .horizontal);
                                                  if (favorites) {
                                                    _podcastController
                                                        .removePodcastFavourite(
                                                            _userController
                                                                .currentUser
                                                                .value
                                                                .id!,
                                                            podcastList[index]
                                                                .id!);
                                                    _userController.currentUser
                                                        .value.favourite
                                                        ?.remove(
                                                            _podcastController
                                                                .favouriteList[
                                                                    index]
                                                                .id);
                                                    podcastList.removeAt(index);
                                                  } else {
                                                    await _podcastController
                                                        .deleteDownload(
                                                            _podcastController
                                                                .downloadsList[
                                                                    index]
                                                                .podcastEpisodeId!,
                                                            _podcastController
                                                                .downloadsList[
                                                                    index]
                                                                .uri!,
                                                            _podcastController
                                                                .downloadsList[
                                                                    index]
                                                                .podcastEpisodePhoto!);
                                                    _podcastController
                                                        .downloadsList
                                                        .removeAt(index);
                                                  }
                                                }
                                              : null,
                                          icon: favorites
                                              ? FaIcon(
                                                  size: 27,
                                                  FontAwesomeIcons.solidStar,
                                                  color: AppColor.primaryColor,
                                                )
                                              : downloads
                                                  ? FaIcon(
                                                      size: 30,
                                                      FontAwesomeIcons.trashCan,
                                                      color:
                                                          AppColor.primaryColor,
                                                    )
                                                  : SizedBox()))
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "There are no events yet",
                          style:
                              TextStyle(color: AppColor.white, fontSize: 17.sp),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
