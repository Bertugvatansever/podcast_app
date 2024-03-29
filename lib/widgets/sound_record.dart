import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:record/record.dart';

class SoundRecordWidget extends StatefulWidget {
  const SoundRecordWidget({super.key});

  @override
  State<SoundRecordWidget> createState() => _SoundRecordWidgetState();
}

class _SoundRecordWidgetState extends State<SoundRecordWidget> {
  UserController _userController = Get.find();
  PodcastController _podcastController = Get.find();
  Duration _recordTime = Duration.zero;
  String _recordTimeString = "";
  late Timer _timer;
  final record = AudioRecorder();

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
                      await record.dispose();
                      _podcastController.isRecorded.value = false;
                      _podcastController.currentPodcastFilePath.value = "";
                      Get.back();
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
                        _recordTimeString,
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
                                        _podcastController.isPaused.value =
                                            !_podcastController.isPaused.value;
                                        if ((await record.isPaused())) {
                                          await record.resume();
                                        } else {
                                          await record.pause();
                                        }
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.pause,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        _podcastController.isPaused.value =
                                            !_podcastController.isPaused.value;
                                        if ((await record.isPaused())) {
                                          await record.resume();
                                        } else {
                                          await record.pause();
                                        }
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
                                String? soundFilePath = await record.stop();
                                _timer.cancel();
                                _recordTime = Duration.zero;
                                _recordTimeString = "";

                                _podcastController.isRecorded.value =
                                    !_podcastController.isRecorded.value;

                                _podcastController.audioPlayer
                                    .setFilePath(soundFilePath!);

                                Get.back();
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
                                  if (await record.hasPermission()) {
                                    Directory? directory =
                                        await getExternalStorageDirectory();
                                    String path = directory!.path;

                                    String soundFilePath =
                                        '$path/${DateTime.now().millisecondsSinceEpoch}.m4a';
                                    print(soundFilePath);
                                    // Start recording to file
                                    await record.start(const RecordConfig(),
                                        path: soundFilePath);

                                    _podcastController.currentPodcastFilePath
                                        .value = soundFilePath;

                                    // ... or to stream
                                    calculateRecordTime();
                                  }
                                }

                                _podcastController.isRecorded.value =
                                    !_podcastController.isRecorded.value;
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!(await record.isPaused())) {
        setState(() {
          _recordTime += Duration(seconds: 1);
          _recordTimeString = formatTime(_recordTime);
        });
      }
    });
  }

  String formatTime(Duration duration) {
    return duration.toString().split('.').first;
  }
}
