import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/widgets/podcast_add_second.dart';
import 'package:podcast_app/widgets/sound_record.dart';

class PodcastAdd extends StatefulWidget {
  const PodcastAdd({super.key});

  @override
  State<PodcastAdd> createState() => _PodcastAddState();
}

class _PodcastAddState extends State<PodcastAdd>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  bool isSelected = true;
  bool startPage = true;
  List<bool> isSelectedList = List.generate(10, (index) => false);
  Color chipTextColor = Colors.black;
  List<String> selectedCategories = [];
  final UserController _userController = Get.find();
  final PodcastController _podcastController = Get.find();

  final List<String> categories = [
    'Teknoloji',
    'Spor',
    'Sağlık',
    'Eğitim',
    'Moda',
    'Gastronomi',
    'Sanat',
    'Seyahat',
    'Müzik',
    'Sinema',
  ];
  TextEditingController _podcastNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Text(
              "New Podcast",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
              child: startPage
                  ? Column(children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Podcast Name",
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
                            color: AppColor().textFieldColor),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _podcastNameController,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.w),
                              hintText: "Your Podcast Name",
                              hintStyle: TextStyle(
                                  color: AppColor().textFieldTextcolor,
                                  fontSize: 18.sp)),
                          textAlign: TextAlign.center,
                        ),
                        width: 310.w,
                        height: 50.h,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Podcast Category",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: List.generate(categories.length, (index) {
                          return buildChoiceChip(index);
                        }),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Podcast About",
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
                        color: AppColor().textFieldColor,
                        child: TextField(
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 20.h),
                            border: InputBorder.none,
                            hintText: "Write About Podcast...",
                            hintStyle: TextStyle(
                              color: AppColor().textFieldTextcolor,
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
                              "Podcast Image",
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
                            color: AppColor().primaryColor,
                            onPressed: () async {
                              await _podcastController.selectPodcastPhoto();
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
                      Obx(() => _podcastController
                              .podcastImageFile.value.path.isNotEmpty
                          ? Container(
                              child: Image.file(
                                File(_podcastController
                                    .podcastImageFile.value.path),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp),
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
                              "Podcast File",
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
                                color: AppColor().primaryColor,
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
                                color: AppColor().primaryColor,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(
                        () => _podcastController
                                .currentPodcastFilePath.value.isNotEmpty
                            ? Card(
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            builder:
                                                (context, snapshotDuration) {
                                              return ProgressBar(
                                                thumbGlowRadius: 15.w,
                                                progressBarColor:
                                                    AppColor().primaryColor,
                                                thumbRadius: 6.w,
                                                thumbColor: AppColor()
                                                    .primaryColor
                                                    .withOpacity(0.9),
                                                progress:
                                                    snapshotPosition.data ??
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
                                      color: AppColor().primaryColor,
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
                                      if (_podcastController
                                          .audioPlayer.playing) {
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
                                            _podcastController.audioPlayer
                                                .stop();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h, top: 0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  startPage = true;
                                });
                              },
                              child: Container(
                                width: 35.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: startPage
                                        ? AppColor().primaryColor
                                        : Colors.grey.shade400),
                                child: Center(
                                  child: Text(
                                    "1",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17.sp),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  startPage = false;
                                });
                              },
                              child: Container(
                                width: 35.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: startPage
                                        ? Colors.grey.shade400
                                        : AppColor().primaryColor),
                                child: Center(
                                  child: Text(
                                    "2",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17.sp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ])
                  : PodcastSecondPage()),
        ),
      ]),
    );
  }

  Widget buildChoiceChip(int index) {
    return ChoiceChip(
      checkmarkColor: Colors.white,
      backgroundColor: Colors.white,
      label: Text(categories[index]),
      labelStyle:
          TextStyle(color: isSelectedList[index] ? Colors.white : Colors.black),
      selected: isSelectedList[index],
      selectedColor: AppColor().primaryColor,
      onSelected: (value) {
        setState(() {
          isSelectedList[index] = value;
          isSelectedList[index]
              ? chipTextColor = Colors.white
              : chipTextColor = Colors.black;
        });
      },
    );
  }
}
