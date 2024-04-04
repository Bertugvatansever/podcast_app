import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/widgets/sound_record.dart';

class PodcastSecondPage extends StatefulWidget {
  const PodcastSecondPage({super.key});

  @override
  State<PodcastSecondPage> createState() => _PodcastSecondPageState();
}

class _PodcastSecondPageState extends State<PodcastSecondPage>
    with SingleTickerProviderStateMixin {
  bool secondPage = true;
  late AnimationController _animationController;
  late Animation<double> animation;
  PodcastController _podcastController = Get.find();
  TextEditingController _episodeController = TextEditingController();
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
    return Column(children: [
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
            color: AppColor().textFieldColor),
        child: TextField(
          style: TextStyle(color: Colors.white),
          controller: _episodeController,
          enableSuggestions: false,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              hintText: "Your Episode Name",
              hintStyle: TextStyle(
                  color: AppColor().textFieldTextcolor, fontSize: 18.sp)),
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
        color: AppColor().textFieldColor,
        child: TextField(
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            border: InputBorder.none,
            hintText: "Write About Episode...",
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
                          stream: _podcastController.audioPlayer.positionStream,
                          builder: (context, snapshotPosition) {
                            return StreamBuilder<Duration?>(
                                stream: _podcastController
                                    .audioPlayer.durationStream,
                                builder: (context, snapshotDuration) {
                                  return ProgressBar(
                                    thumbGlowRadius: 15.w,
                                    progressBarColor: AppColor().primaryColor,
                                    thumbRadius: 6.w,
                                    thumbColor: AppColor()
                                        .primaryColor
                                        .withOpacity(0.9),
                                    progress:
                                        snapshotPosition.data ?? Duration(),
                                    total: snapshotDuration.data ?? Duration(),
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
                          _podcastController.currentPodcastFilePath.value = "";
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
                            _podcastController.audioPlayer.playerStateStream
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
                    padding: EdgeInsets.only(bottom: 25.h, top: 15.h),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Create Podcast"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().primaryColor,
                          foregroundColor: Colors.white),
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
    ]);
  }
}
