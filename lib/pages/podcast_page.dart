import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/pages/podcast_listen_page.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key, required this.podcast});
  final Podcast podcast;
  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  bool isNotification = false;
  bool isRated = false;
  bool isFavorite = false;
  bool isFollow = false;
  bool favouriteCheck = false;
  double star = 0;
  PodcastController _podcastController = Get.find();
  UserController _userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _podcastController.getContinueListeningPodcastEpisodes(widget.podcast.id!);
    // isFavoritePodcast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
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
        title: Container(
          child: TextField(
            cursorWidth: 1.w,
            textAlign: TextAlign.center,
            enableSuggestions: false,
            style: TextStyle(color: AppColor.white),
            cursorColor: AppColor.primaryColor,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 9.h),
              hintText: "Find Episode",
              hintStyle: TextStyle(color: AppColor.textFieldTextcolor),
              border: InputBorder.none,
            ),
          ),
          width: 300.w,
          height: 24.h,
          decoration: BoxDecoration(
              color: AppColor.textFieldColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
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
                        padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
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
                    ],
                  ),
                  SizedBox(
                    width: 13.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 26,
                              color: AppColor.primaryColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 5.w,
                                top: 1.h,
                              ),
                              child: Text(
                                "4.3",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                          ),
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
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, bottom: 10.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RatingBar.builder(
                        unratedColor: AppColor.textFieldColor,
                        initialRating: 0,
                        itemSize: 31,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: AppColor.primaryColor,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            star = rating;
                            isRated = true;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, bottom: 7.h),
                    child: isRated
                        ? Text(
                            "You are voted ${star.toString()} star !",
                            style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "Please Rate This Podcast !",
                            style: TextStyle(color: AppColor.white),
                          ),
                  )
                ],
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
                      onPressed: () {
                        setState(() {
                          isFollow = !isFollow;
                        });
                      },
                      child: Text(
                        isFollow ? "Takip Ediliyor" : "Takip Et",
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
                            isNotification = !isNotification;
                          });
                          if (isNotification == true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: AppColor.primaryColor,
                                showCloseIcon: true,
                                content: Center(
                                  child: Text("Podcast bildirimleri aktif"),
                                )));
                          } else {}
                        },
                        icon: Icon(
                          Icons.notifications,
                          color: isNotification
                              ? AppColor.primaryColor
                              : Colors.white,
                          size: 30,
                        )),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          isFavorite = !isFavorite;
                        });

                        if (isFavorite) {
                          await _podcastController.addPodcastFavourite(
                              _userController.currentUser.value.id!,
                              widget.podcast.id!);

                          _userController.currentUser.value.favourite
                              ?.add(widget.podcast.id!);
                        } else {
                          await _podcastController.removePodcastFavourite(
                              _userController.currentUser.value.id!,
                              widget.podcast.id!);

                          _userController.currentUser.value.favourite
                              ?.remove(widget.podcast.id!);
                        }

                        if (isFavorite == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColor.primaryColor,
                              showCloseIcon: true,
                              content: Center(
                                child: Text("Podcast favorilere eklendi"),
                              )));
                        }
                      },
                      icon: _userController.currentUser.value.favourite!
                              .contains(widget.podcast.id)
                          ? FaIcon(
                              FontAwesomeIcons.solidBookmark,
                              color: AppColor.primaryColor,
                            )
                          : FaIcon(
                              FontAwesomeIcons.bookmark,
                              color: AppColor.white,
                            ),
                    ),
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

  Future<void> isFavoritePodcast() async {
    isFavorite = await _podcastController.isFavorite(
        widget.podcast.id!, _userController.currentUser.value.id!);
    setState(() {
      favouriteCheck = true;
    });
  }
}
