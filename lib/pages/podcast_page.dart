import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/pages/podcast_listen_page.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key, required this.podcast});
  final Podcast podcast;
  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  bool isFollow = false;
  PodcastController _podcastController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _podcastController.getContinueListeningPodcastEpisodes(widget.podcast.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: ScreenUtil().screenWidth,
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Container(
                          width: 170.w,
                          height: 170.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade900),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              width: 170.w,
                              height: 170.h,
                              widget.podcast.photo!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // Resim yüklendikten sonra gösterilecek widget
                                } else {
                                  return Center(
                                      child:
                                          CircularProgressIndicator()); // Yükleme esnasında gösterilecek widget
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 13.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 180.w,
                          child: Text(
                            widget.podcast.name!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${widget.podcast.user?.name ?? ""}  ${widget.podcast.user?.surName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 50.h,
                              width: 170.w,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    (widget.podcast.category ?? []).length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      index ==
                                              (widget.podcast.category ?? [])
                                                      .length -
                                                  1
                                          ? Text(
                                              (widget.podcast.category ??
                                                  [])[index],
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 17.sp),
                                            )
                                          : Text(
                                              (widget.podcast.category ??
                                                  [])[index],
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 17.sp),
                                            ),
                                      index ==
                                              widget.podcast.category!.length -
                                                  1
                                          ? SizedBox()
                                          : Text(
                                              ",",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 17.sp),
                                            ),
                                      SizedBox(
                                        width: 2.w,
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.podcast.about!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 11.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Takip Et",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(180.w, 35.h),
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: Colors.white),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isFollow = !isFollow;
                          });
                        },
                        icon: Icon(
                          Icons.notifications,
                          color:
                              isFollow ? AppColor.primaryColor : Colors.white,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 11.w),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Episodes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.turnDown,
                        color: Colors.white,
                      ))
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: 500.h,
                  child: ListView.builder(
                    itemCount:
                        _podcastController.continuePodcastEpisodeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          print(_podcastController
                              .continuePodcastEpisodeList[index].file);
                          _podcastController.audioPlayer.setUrl(
                              _podcastController
                                  .continuePodcastEpisodeList[index].file);
                          print(_podcastController.audioPlayer.duration);
                          Get.to(() => PodcastListenPage(
                              episode: _podcastController
                                  .continuePodcastEpisodeList[index]));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.shade900),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    width: 100.w,
                                    height: 100.h,
                                    _podcastController
                                        .continuePodcastEpisodeList[index]
                                        .episodeImage,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.h, left: 15.w),
                                    child: SizedBox(
                                      width: 250.w,
                                      child: Center(
                                        child: Text(
                                          _podcastController
                                              .continuePodcastEpisodeList[index]
                                              .podcastName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.h, left: 15.w),
                                    child: SizedBox(
                                      width: 250.w,
                                      child: Center(
                                        child: Text(
                                          _podcastController
                                              .continuePodcastEpisodeList[index]
                                              .name,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 18.sp,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}
