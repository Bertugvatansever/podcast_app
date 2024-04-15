import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/widgets/sound_record.dart';

class PodcastAddSecondWidget extends StatefulWidget {
  const PodcastAddSecondWidget({super.key});

  @override
  State<PodcastAddSecondWidget> createState() => _PodcastAddSecondWidgetState();
}

class _PodcastAddSecondWidgetState extends State<PodcastAddSecondWidget>
    with SingleTickerProviderStateMixin {
  bool isUploading = false;
  late AnimationController _animationController;
  late Animation<double> animation;
  PodcastController _podcastController = Get.find();
  UserController _userController = Get.find();

  TextEditingController _episodeNameController = TextEditingController();
  TextEditingController _episodeAboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _episodeNameController.text = _podcastController.episodeName.value;
    _episodeAboutController.text = _podcastController.episodeAbout.value;
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? SizedBox(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
                strokeWidth: 5.w,
              ),
            ),
          )
        : Column(children: [
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Episode Name",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.textFieldColor),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _episodeNameController,
                enableSuggestions: false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    hintText: "Your Episode Name",
                    hintStyle: TextStyle(
                        color: AppColor.textFieldTextcolor, fontSize: 18.sp)),
                textAlign: TextAlign.center,
              ),
              width: 310.w,
              height: 50.h,
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Episode About",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 25),
              color: AppColor.textFieldColor,
              child: TextField(
                style: TextStyle(color: Colors.white),
                enableSuggestions: false,
                controller: _episodeAboutController,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  border: InputBorder.none,
                  hintText: "Write About Episode...",
                  hintStyle: TextStyle(
                    color: AppColor.textFieldTextcolor,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: Text(
                    "Episode Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                IconButton(
                  icon: Icon(Icons.upload),
                  color: AppColor.primaryColor,
                  onPressed: () async {
                    await _podcastController.selectEpisodePhoto();
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Obx(() =>
                _podcastController.podcastEpisodeImageFile.value.path.isNotEmpty
                    ? Container(
                        child: Image.file(
                          File(_podcastController
                              .podcastEpisodeImageFile.value.path),
                          fit: BoxFit.cover,
                        ),
                        height: 200.h,
                        width: 300.h,
                      )
                    : Container(
                        child: Center(
                          child: Text(
                            "Please select a Photo",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.sp),
                          ),
                        ),
                        height: 200.h,
                        width: 300.h,
                        color: Colors.white,
                      )),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 100.w),
                  child: Text(
                    "Episode File",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                IconButton(
                    onPressed: () async {
                      await _podcastController.selectPodcastFile();
                    },
                    icon: Icon(
                      Icons.upload,
                      color: AppColor.primaryColor,
                    )),
                SizedBox(
                  width: 20.w,
                ),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isDismissible: false,
                          enableDrag: false,
                          context: context,
                          builder: (BuildContext context) {
                            return SoundRecordWidget();
                          });
                    },
                    icon: Icon(
                      Icons.mic,
                      color: AppColor.primaryColor,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => _podcastController.currentPodcastFilePath.value.isNotEmpty
                  ? Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Demo Podcast"),
                                SizedBox(
                                  height: 5.h,
                                )
                              ],
                            ),
                            subtitle: StreamBuilder<Duration?>(
                                stream: _podcastController
                                    .audioPlayer.positionStream,
                                builder: (context, snapshotPosition) {
                                  return StreamBuilder<Duration?>(
                                      stream: _podcastController
                                          .audioPlayer.durationStream,
                                      builder: (context, snapshotDuration) {
                                        return ProgressBar(
                                          thumbGlowRadius: 15.w,
                                          progressBarColor:
                                              AppColor.primaryColor,
                                          thumbRadius: 6.w,
                                          thumbColor: AppColor.primaryColor
                                              .withOpacity(0.9),
                                          progress: snapshotPosition.data ??
                                              Duration(),
                                          total: snapshotDuration.data ??
                                              Duration(),
                                          onSeek: (duration) {
                                            _podcastController.audioPlayer
                                                .seek(duration);
                                          },
                                        );
                                      });
                                }),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: AppColor.primaryColor,
                              ),
                              onPressed: () {
                                _podcastController
                                    .currentPodcastFilePath.value = "";
                              },
                            ),
                            leading: IconButton(
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: animation,
                                size: 48.0,
                                semanticLabel: 'Show menu',
                              ),
                              onPressed: () {
                                if (_podcastController.audioPlayer.playing) {
                                  _animationController.reverse();
                                  _podcastController.audioPlayer.pause();
                                } else {
                                  _animationController.forward();
                                  _podcastController.audioPlayer.play();
                                  _podcastController
                                      .audioPlayer.playerStateStream
                                      .listen((state) {
                                    if (state.processingState ==
                                        ProcessingState.completed) {
                                      _podcastController.audioPlayer
                                          .seek(Duration.zero);
                                      _animationController.reverse();
                                      _podcastController.audioPlayer.stop();
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h, top: 21.h),
                          child: AnimatedButton(
                            pressEvent: () async {
                              _podcastController.episodeName.value =
                                  _episodeNameController.text;
                              _podcastController.episodeAbout.value =
                                  _episodeAboutController.text;

                              setState(() {
                                isUploading = true;
                              });

                              bool? confirm =
                                  await _podcastController.uploadPodcast(
                                      _podcastController.podcastName.value,
                                      _podcastController.podcastAbout.value,
                                      _userController.currentUser.value,
                                      _podcastController.episodeName.value);
                              setState(() {
                                isUploading = false;
                              });

                              print(confirm);
                              confirm
                                  ? AwesomeDialog(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.h),
                                      btnOkText: "Go Back",
                                      bodyHeaderDistance: 20.h,
                                      headerAnimationLoop: false,
                                      dialogBackgroundColor: AppColor
                                          .backgroundColor
                                          .withOpacity(0.7),
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      title:
                                          _podcastController.podcastName.value,
                                      titleTextStyle: TextStyle(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23.sp),
                                      desc: 'Podcast succesfully created',
                                      descTextStyle: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 17.sp),
                                      btnOkOnPress: () {
                                        _userController.currentIndex.value = 0;
                                        _podcastController.startPage.value =
                                            true;
                                      },
                                    ).show()
                                  : AwesomeDialog(
                                      btnOkText: "Go Back",
                                      btnOkColor: Colors.red.shade600,
                                      bodyHeaderDistance: 20.h,
                                      headerAnimationLoop: false,
                                      dialogBackgroundColor:
                                          AppColor.backgroundColor,
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title:
                                          _podcastController.podcastName.value,
                                      titleTextStyle: TextStyle(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23.sp),
                                      desc:
                                          'An error occurred while creating the podcast',
                                      descTextStyle: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 17.sp),
                                      btnOkOnPress: () {
                                        Get.back();
                                      },
                                    ).show();
                              confirm ? allTextClear() : SizedBox();
                            },
                            text: "Create Podcast",
                            color: AppColor.primaryColor,
                            width: 200.w,
                            buttonTextStyle: TextStyle(
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: Text(
                          "When the file is uploaded it will go here",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
            TextButton(
                onPressed: () {
                  _podcastController.startPage.value = true;
                  _podcastController.episodeName.value =
                      _episodeNameController.text;
                  _podcastController.episodeAbout.value =
                      _episodeAboutController.text;
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Text(
                    "Go Back",
                    style: TextStyle(
                        fontSize: 20.sp, color: AppColor.primaryColor),
                  ),
                ))
          ]);
  }

  void allTextClear() {
    _podcastController.podcastName.value = "";
    _podcastController.podcastAbout.value = "";
    _podcastController.podcastImageFile.value = File("");
    _podcastController.podcastImageFile.value = File("");
    _podcastController.currentPodcastFilePath.value = "";
    _podcastController.episodeName.value = "";
    _podcastController.episodeAbout.value = "";
    _podcastController.podcastEpisodeImageFile.value = File("");
  }
}
