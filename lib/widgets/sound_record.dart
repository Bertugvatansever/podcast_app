import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';

class SoundRecordWidget extends StatefulWidget {
  const SoundRecordWidget({super.key});

  @override
  State<SoundRecordWidget> createState() => _SoundRecordWidgetState();
}

class _SoundRecordWidgetState extends State<SoundRecordWidget> {
  UserController _userController = Get.find();
  PodcastController _podcastController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: ScreenUtil().screenHeight / 2 + 17.h,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
            color: AppColor().backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            Divider(
              indent: 177.w,
              endIndent: 177.w,
              thickness: 3,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    "Record Podcast",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 77.w,
                ),
                IconButton(
                    color: Colors.white,
                    onPressed: () async {
                      _podcastController.deletePodcastRecord();
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(
              thickness: 0,
              color: Colors.grey,
            ),
            _podcastController.isRecorded.value
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 13.h),
                        child: Text(
                          "Recording",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        _podcastController.recordTimeString,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      SizedBox(
                          width: 170.w,
                          child: Lottie.asset('assets/wave.json')),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: Text(
                      "Tap Microphone",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                      ),
                    ),
                  ),
            SizedBox(
              height: 45.h,
            ),
            _podcastController.isRecorded.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 90.w,
                        height: 90.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColor().primaryColor.withOpacity(0.9),
                              AppColor().primaryColor.withOpacity(0.8),
                              AppColor().primaryColor.withOpacity(0.7),
                              AppColor().primaryColor.withOpacity(0.6),
                              AppColor().primaryColor.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor().primaryColor,
                              ),
                              child: _podcastController.isPaused.value
                                  ? IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.play,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        _podcastController.pauseCheckRecord();
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.pause,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        _podcastController.pauseCheckRecord();
                                      },
                                    )),
                        ),
                      ),
                      Container(
                        width: 90.w,
                        height: 90.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColor().primaryColor.withOpacity(0.9),
                              AppColor().primaryColor.withOpacity(0.8),
                              AppColor().primaryColor.withOpacity(0.7),
                              AppColor().primaryColor.withOpacity(0.6),
                              AppColor().primaryColor.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor().primaryColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.square,
                                size: 30,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                _podcastController.stopPodcastRecord();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Center(
                      child: Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColor().primaryColor.withOpacity(0.9),
                              AppColor().primaryColor.withOpacity(0.8),
                              AppColor().primaryColor.withOpacity(0.7),
                              AppColor().primaryColor.withOpacity(0.6),
                              AppColor().primaryColor.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor().primaryColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.mic,
                                size: 35,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                if (!_podcastController.isRecorded.value) {
                                  calculateRecordTime();
                                  _podcastController.startPodcastRecord();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 30.h,
            )
          ],
        ),
      ),
    );
  }

  void calculateRecordTime() {
    _podcastController.timer =
        Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!(await _podcastController.record.isPaused())) {
        setState(() {
          _podcastController.recordTime += Duration(seconds: 1);
          _podcastController.recordTimeString =
              formatTime(_podcastController.recordTime);
        });
      }
    });
  }

  String formatTime(Duration duration) {
    return duration.toString().split('.').first;
  }
}
