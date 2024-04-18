import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/models/episode.dart';

class PodcastListenPage extends StatefulWidget {
  const PodcastListenPage({super.key, required this.episode});
  final Episode episode;
  @override
  State<PodcastListenPage> createState() => _PodcastListenPageState();
}

class _PodcastListenPageState extends State<PodcastListenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    animation = Tween<double>(begin: 0.0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.download,
                  color: AppColor.white,
                )),
          )
        ],
        title: Text(
          widget.episode.podcastName,
          style: TextStyle(
            color: AppColor.white,
            fontSize: 18.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 12.h,
            ),
            Center(
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.episode.episodeImage),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 48.w),
                child: Text(
                  widget.episode.podcastName,
                  style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.sp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 48.w),
                child: Text(
                  widget.episode.name,
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 20.sp),
                ),
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            SizedBox(
              width: 290.w,
              child: ProgressBar(
                progress: Duration.zero,
                total: Duration(minutes: 3),
                baseBarColor: AppColor.white,
                thumbColor: AppColor.primaryColor.withOpacity(0.9),
                progressBarColor: AppColor.primaryColor,
                thumbRadius: 7.w,
                thumbGlowRadius: 15.w,
                timeLabelTextStyle:
                    TextStyle(color: Colors.grey.shade300, fontSize: 16.sp),
                timeLabelLocation: TimeLabelLocation.below,
                timeLabelPadding: 5.h,
                onSeek: (value) {},
              ),
            ),
            Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 35.w),
                    child: IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.rotateLeft,
                        size: 60,
                        color: AppColor.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: AppColor.primaryColor,
                      radius: 40.w,
                      child: Center(
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: animation,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _animationController.forward();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35.w),
                    child: IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.rotateRight,
                        size: 60,
                        color: AppColor.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 34.5.h,
                left: 70.w,
                child: Text(
                  "10",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 34.5.h,
                right: 70.w,
                child: Text(
                  "10",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Text(
                    "Bölüm Hakkında",
                    style: TextStyle(color: Colors.white, fontSize: 32.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.turnDown,
                        color: Colors.white,
                        size: 27,
                      )),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Card(
                color: AppColor.textFieldColor.withOpacity(0.7),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text(
                    widget.episode.episodeAbout,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
