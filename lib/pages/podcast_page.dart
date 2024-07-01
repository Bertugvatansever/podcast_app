import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/pages/podcast_listen_page.dart';
import 'package:podcast_app/pages/profile_page.dart';

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
  bool isLoading = false;
  TextEditingController _searchController = TextEditingController();
  double star = 0;
  double previousRating = 0;
  PodcastController _podcastController = Get.find();
  UserController _userController = Get.find();
  List<Episode> searchResult = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    _podcastController.podcastRating.value = widget.podcast.rating!;
    _podcastController.listenPodcastRatings(widget.podcast.id!);
    _podcastController.getPodcastEpisodes(widget.podcast.id!).then((_) {
      searchResult.addAll(_podcastController.podcastEpisodeList);
      setState(() {
        isLoading = false;
      });
    });
    isFavorite = _userController.currentUser.value.favourite!
        .contains(widget.podcast.id);
    isFollow =
        _podcastController.followPodcastIdList.contains(widget.podcast.id);
    _userController
        .getUserRatingList(_userController.currentUser.value.id!)
        .then((_) {
      if (_userController.currentUser.value.myRatings != null) {
        isRated = _userController.currentUser.value.myRatings!
            .containsKey(widget.podcast.id!);
        if (isRated) {
          setState(() {
            print(widget.podcast.rating);
            star = _userController
                .currentUser.value.myRatings![widget.podcast.id]!;
            previousRating = star;
            print("STAR" + star.toString());
            print("previousRating" + previousRating.toString());
          });
        }
      }
    });
    _podcastController.setPodcastView(
        widget.podcast.id!, widget.podcast.viewCount ?? 0);
  }

  @override
  void dispose() {
    _podcastController.cancelListenPodcast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () async {
              await _podcastController
                  .getFavouritePodcasts(_userController.currentUser.value.id!);
              await _podcastController
                  .getFollowPodcasts(_userController.currentUser.value.id!);
              await _podcastController.getContinueListeningPodcast(
                  _userController.currentUser.value.id!);
              Get.back(result: {
                "follow": (_userController.followPodcastList.length +
                        _userController.followUserList.length)
                    .toString(),
                "followers":
                    (_userController.followersUserList.length).toString()
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
        title: Container(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _searchEpisodes(value);
              print("arama sonucu" + searchResult.length.toString());
            },
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            )
          : SingleChildScrollView(
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
                                            child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                        )); // Yükleme esnasında gösterilecek widget
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
                                    child: Obx(
                                      () => Text(
                                        _podcastController.podcastRating.value
                                                .substring(0, 3) ??
                                            "0",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AppColor.white,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                              InkWell(
                                onTap: () async {
                                  User user =
                                      await _userController.getPodcastOwnerUser(
                                          widget.podcast.user!.id!);

                                  Get.to(() => ProfilePage(
                                        profileUser: user,
                                      ));
                                },
                                child: SizedBox(
                                  width: 180.w,
                                  child: Text(
                                    '${widget.podcast.user?.name ?? ""}  ${widget.podcast.user?.surName}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 46.h,
                                    width: 170.w,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: (widget.podcast.category ?? [])
                                          .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            index ==
                                                    (widget.podcast.category ??
                                                                [])
                                                            .length -
                                                        1
                                                ? Text(
                                                    (widget.podcast.category ??
                                                        [])[index],
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 17.sp),
                                                  )
                                                : Text(
                                                    (widget.podcast.category ??
                                                        [])[index],
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 17.sp),
                                                  ),
                                            index ==
                                                    widget.podcast.category!
                                                            .length -
                                                        1
                                                ? SizedBox()
                                                : Text(
                                                    ",",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
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
                              initialRating: star,
                              itemSize: 31,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppColor.primaryColor,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  star = rating;
                                  if (isRated) {
                                    _podcastController
                                        .setPodcastRating(
                                            widget.podcast.id!,
                                            rating,
                                            _userController
                                                .currentUser.value.id!,
                                            previousRating: previousRating)
                                        .then((_) {});
                                  } else {
                                    _podcastController
                                        .setPodcastRating(
                                            widget.podcast.id!,
                                            rating,
                                            _userController
                                                .currentUser.value.id!)
                                        .then((_) {
                                      setState(() {
                                        isRated = true;
                                      });
                                    });
                                  }
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
                            onPressed: () async {
                              setState(() {
                                isFollow = !isFollow;
                              });
                              if (isFollow) {
                                await _userController.follow(
                                    _userController.currentUser.value.id!,
                                    widget.podcast.id!,
                                    true);
                                _userController.followPodcastList
                                    .add(widget.podcast);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: AppColor.primaryColor,
                                        showCloseIcon: true,
                                        content: Center(
                                          child:
                                              Text("Podcast Takip Ediliyor !"),
                                        )));
                              } else {
                                await _userController.unFollow(
                                    _userController.currentUser.value.id!,
                                    widget.podcast.id!,
                                    true);
                                _userController.followPodcastList.removeWhere(
                                    (podcast) =>
                                        podcast.id == widget.podcast.id);
                              }
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              AppColor.primaryColor,
                                          showCloseIcon: true,
                                          content: Center(
                                            child: Text(
                                                "Podcast bildirimleri aktif"),
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: AppColor.primaryColor,
                                        showCloseIcon: true,
                                        content: Center(
                                          child: Text(
                                              "Podcast favorilere eklendi"),
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
                              _podcastController.podcastEpisodeList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                print(_podcastController
                                    .podcastEpisodeList[index].file);
                                _podcastController.audioPlayer.setUrl(
                                    _podcastController
                                        .podcastEpisodeList[index].file);
                                print(_podcastController.audioPlayer.duration);
                                Get.to(() => PodcastListenPage(
                                      episodeId: _podcastController
                                          .podcastEpisodeList[index].episodeId,
                                      podcastId: _podcastController
                                          .podcastEpisodeList[index].podcastId,
                                    ));
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.w, bottom: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 110.w,
                                      height: 110.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey.shade900),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          width: 110.w,
                                          height: 110.h,
                                          _podcastController
                                              .podcastEpisodeList[index]
                                              .episodeImage,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.h, left: 15.w),
                                          child: SizedBox(
                                            width: 250.w,
                                            child: Text(
                                              _podcastController
                                                  .podcastEpisodeList[index]
                                                  .podcastName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.h, left: 15.w),
                                          child: SizedBox(
                                            width: 250.w,
                                            child: Text(
                                              _podcastController
                                                  .podcastEpisodeList[index]
                                                  .name,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 18.sp,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
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

  void _searchEpisodes(String searchTerm) {
    _podcastController.podcastEpisodeList.clear();
    if (searchTerm.isEmpty) {
      _podcastController.podcastEpisodeList.addAll(searchResult);
    } else {
      _podcastController.podcastEpisodeList.addAll(searchResult.where(
          (episode) =>
              episode.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
              episode.podcastName
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase())));
    }
    setState(() {});
  }
}
