import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
                          height: 170.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget.podcast.photo!),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
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
                        Text(
                          widget.podcast.name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.podcast.user?.name ?? "",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.sp),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(widget.podcast.user?.surName ?? "",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.sp)),
                          ],
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
              SizedBox(
                width: ScreenUtil().screenWidth,
                height: 500.h,
                child: ListView.builder(
                  itemCount:
                      _podcastController.continuePodcastEpisodeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
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
                                  image: DecorationImage(
                                      image: NetworkImage(_podcastController
                                          .continuePodcastEpisodeList[index]
                                          .episodeImage),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 15.h, left: 15.w),
                                  child: Text(
                                    _podcastController
                                        .continuePodcastEpisodeList[index]
                                        .podcastName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 15.h, left: 15.w),
                                  child: Text(
                                    _podcastController
                                        .continuePodcastEpisodeList[index].name,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ),
    );
  }
}
