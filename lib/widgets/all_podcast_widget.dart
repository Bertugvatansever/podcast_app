import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/pages/podcast_page.dart';

class AllPodcast extends StatefulWidget {
  const AllPodcast({super.key});

  @override
  State<AllPodcast> createState() => _AllPodcastState();
}

// CANLI YILDIZI VE VİEW SAYISINI GÖREMİYORUZ.
class _AllPodcastState extends State<AllPodcast> {
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();

  bool categoryPodcast = false;
  bool mostPopular = false;
  bool latest = true;
  bool highestRating = false;
  bool sameButton = false;
  String categoryName = "";
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels > 0) {
        _podcastController.listClear.value = false;

        if (latest) {
          _podcastController.getAllPodcasts("podcastcreatedtime",
              categoryName: categoryName);
        } else if (mostPopular) {
          _podcastController.getAllPodcasts("podcastview",
              categoryName: categoryName);
        } else {
          _podcastController.getAllPodcasts("podcastrating",
              categoryName: categoryName);
        }
      }
    });
    _podcastController.listenAllPodcastRatings();
    _podcastController.listenAllPodcastView();
  }

  @override
  void dispose() {
    _podcastController.cancelListenAllPodcast();
    _podcastController.cancelListenView();
    super.dispose();
  }

  PodcastController _podcastController = Get.find();
  List<Color> containerColors = [
    Colors.black87,
    Color.fromRGBO(41, 93, 225, 0.957),
    Color.fromRGBO(191, 241, 6, 0.957),
    Color.fromRGBO(223, 8, 8, 0.89),
    AppColor.primaryColor.withOpacity(0.6),
    Color.fromRGBO(204, 47, 175, 0.957),
    Color.fromARGB(255, 255, 171, 44),
    Colors.purple,
    Color.fromRGBO(21, 163, 224, 0.957),
    Color.fromRGBO(187, 3, 153, 0.957),
    Colors.black87,
    Colors.brown,
    Color.fromRGBO(82, 247, 28, 0.957),
    Color.fromRGBO(249, 143, 229, 0.957),
  ];
  List<String> categories = [
    "Tüm Kategoriler",
    "Teknoloji",
    "Spor",
    "Sağlık",
    "Eğitim",
    "Moda",
    "Gastronomi",
    "Sanat",
    "Seyahat",
    "Müzik",
    "Sinema",
    "Tarih",
  ];
  List<String> categoriesPhotos = [
    "assets/categories.png",
    "assets/cpu.png",
    "assets/soccer-player.png",
    "assets/cardiogram.png",
    "assets/academic.png",
    "assets/dress.png",
    "assets/chef-hat.png",
    "assets/color.png",
    "assets/man.png",
    "assets/music.png",
    "assets/clapper.png",
    "assets/old-map.png",
  ];
  @override
  Widget build(BuildContext context) {
    // BOŞLUK HATASI GİDERİLCEK
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: _podcastController.podcastsPage.value ? 12.h : 20.h),
            ),
            _podcastController.podcastsPage.value
                ? SizedBox(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight -
                        kBottomNavigationBarHeight * 3.25,
                    child: _podcastController.firstLoadAllpodcast.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          )
                        : _podcastController.allPodcasts.isNotEmpty
                            ? Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          _podcastController.allPodcasts.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index == 0) {
                                          return Column(
                                            children: [
                                              SingleChildScrollView(
                                                padding: EdgeInsets.only(
                                                    right: 10.w),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 40.w,
                                                      height: 40.h,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            _podcastController
                                                                .podcastsPage
                                                                .value = false;
                                                            setState(() {
                                                              latest = true;
                                                              mostPopular =
                                                                  false;
                                                              highestRating =
                                                                  false;
                                                              categoryName = "";
                                                            });
                                                          },
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .arrowLeftLong,
                                                            color:
                                                                AppColor.white,
                                                            size: 25,
                                                          )),
                                                    ),
                                                    // SizedBox(
                                                    //   width: 15.w,
                                                    // ),
                                                    filteredButtons(
                                                        "Latest", latest),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    filteredButtons(
                                                        "Most Popular",
                                                        mostPopular),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    filteredButtons(
                                                        "Highest Rating",
                                                        highestRating)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => PodcastPage(
                                                          podcast:
                                                              _podcastController
                                                                      .allPodcasts[
                                                                  index]));
                                                    },
                                                    child: Container(
                                                      width: 400.w,
                                                      height: 400.h,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          SizedBox(
                                                            width: 345.w,
                                                            child: Text(
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              _podcastController
                                                                  .allPodcasts[
                                                                      index]
                                                                  .name!
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Container(
                                                            width: 345.w,
                                                            height: 200.h,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .grey
                                                                    .shade900),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child:
                                                                  Image.network(
                                                                width: 345.w,
                                                                height: 200.h,
                                                                _podcastController
                                                                        .allPodcasts[
                                                                            index]
                                                                        .photo ??
                                                                    "",
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child; // Resim yüklendikten sonra gösterilecek widget
                                                                  } else {
                                                                    return Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                      color: AppColor
                                                                          .primaryColor,
                                                                    )); // Yükleme esnasında gösterilecek widget
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          SizedBox(
                                                            width: 350.w,
                                                            height: 40.h,
                                                            child: Text(
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              _podcastController
                                                                  .allPodcasts[
                                                                      index]
                                                                  .episodes![0]
                                                                  .toString()
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 30.w,
                                                                    top: 20.h,
                                                                    left: 30.w),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          200.w,
                                                                      child:
                                                                          Text(
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        "${_podcastController.allPodcasts[index].user!.name!} ${_podcastController.allPodcasts[index].user!.surName!}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            50.h,
                                                                        width:
                                                                            170.w,
                                                                        child: ListView
                                                                            .builder(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          itemCount:
                                                                              (_podcastController.allPodcasts[index].category ?? []).length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int i) {
                                                                            return Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                i == (_podcastController.allPodcasts[index].category ?? []).length - 1
                                                                                    ? Text(
                                                                                        (_podcastController.allPodcasts[index].category ?? [])[i],
                                                                                        style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                                                                                      )
                                                                                    : Text(
                                                                                        (_podcastController.allPodcasts[index].category ?? [])[i],
                                                                                        style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                                                                                      ),
                                                                                i == _podcastController.allPodcasts[index].category!.length - 1
                                                                                    ? SizedBox()
                                                                                    : Text(
                                                                                        ",",
                                                                                        style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                                                                                      ),
                                                                                SizedBox(
                                                                                  width: 2.w,
                                                                                )
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Spacer(),
                                                                FaIcon(
                                                                  FontAwesomeIcons
                                                                      .eye,
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                ),
                                                                SizedBox(
                                                                  width: 5.w,
                                                                ),
                                                                Obx(
                                                                  () => Text(
                                                                    _podcastController.allPodcasts[index].viewCount.toString().length ==
                                                                            6
                                                                        ? _podcastController.allPodcasts[index].viewCount.toString().substring(0,
                                                                                3) +
                                                                            "B"
                                                                        : _podcastController.allPodcasts[index].viewCount.toString().length ==
                                                                                7
                                                                            ? _podcastController.allPodcasts[index].viewCount.toString().substring(0, 1) +
                                                                                "." +
                                                                                _podcastController.allPodcasts[index].viewCount.toString().substring(1, 2) +
                                                                                "M"
                                                                            : _podcastController.allPodcasts[index].viewCount.toString().length == 8
                                                                                ? _podcastController.allPodcasts[index].viewCount.toString().substring(0, 2) + "." + _podcastController.allPodcasts[index].viewCount.toString().substring(2, 3) + "M"
                                                                                : _podcastController.allPodcasts[index].viewCount.toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                Icon(
                                                                  Icons.star,
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                  size: 30,
                                                                ),
                                                                Text(
                                                                  _podcastController
                                                                          .allPodcasts[
                                                                              index]
                                                                          .rating!
                                                                          .substring(
                                                                              0,
                                                                              3) ??
                                                                      "0",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30.h,
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(PodcastPage(
                                                      podcast:
                                                          _podcastController
                                                                  .allPodcasts[
                                                              index]));
                                                },
                                                child: Container(
                                                  width: 400.w,
                                                  height: 400.h,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Text(
                                                        _podcastController
                                                            .allPodcasts[index]
                                                            .name!
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        width: 345.w,
                                                        height: 200.h,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Colors
                                                                .grey.shade900),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image.network(
                                                            width: 345.w,
                                                            height: 200.h,
                                                            _podcastController
                                                                    .allPodcasts[
                                                                        index]
                                                                    .photo ??
                                                                "",
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child; // Resim yüklendikten sonra gösterilecek widget
                                                              } else {
                                                                return Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                )); // Yükleme esnasında gösterilecek widget
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      SizedBox(
                                                        width: 350.w,
                                                        height: 40.h,
                                                        child: Text(
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          _podcastController
                                                              .allPodcasts[
                                                                  index]
                                                              .episodes![0]
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 30.w,
                                                                top: 20.h,
                                                                left: 30.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 200.w,
                                                                  child: Text(
                                                                    "${_podcastController.allPodcasts[index].user!.name!} ${_podcastController.allPodcasts[index].user!.surName!}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child:
                                                                      SizedBox(
                                                                    height:
                                                                        50.h,
                                                                    width:
                                                                        170.w,
                                                                    child: ListView
                                                                        .builder(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      itemCount:
                                                                          (_podcastController.allPodcasts[index].category ?? [])
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int i) {
                                                                        return Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            i == (_podcastController.allPodcasts[index].category ?? []).length - 1
                                                                                ? Text(
                                                                                    (_podcastController.allPodcasts[index].category ?? [])[i],
                                                                                    style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                                                                                  )
                                                                                : Text(
                                                                                    (_podcastController.allPodcasts[index].category ?? [])[i],
                                                                                    style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                                                                                  ),
                                                                            i == _podcastController.allPodcasts[index].category!.length - 1
                                                                                ? SizedBox()
                                                                                : Text(
                                                                                    ",",
                                                                                    style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                                                                                  ),
                                                                            SizedBox(
                                                                              width: 2.w,
                                                                            )
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .eye,
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                              _podcastController
                                                                  .allPodcasts[
                                                                      index]
                                                                  .viewCount
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color: AppColor
                                                                  .primaryColor,
                                                              size: 30,
                                                            ),
                                                            Text(
                                                              _podcastController
                                                                      .allPodcasts[
                                                                          index]
                                                                      .rating!
                                                                      .substring(
                                                                          0,
                                                                          3) ??
                                                                  "0",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Obx(
                                    () => _podcastController.isLoading.value
                                        ? Container(
                                            width: ScreenUtil().screenWidth,
                                            height: 62.h,
                                            child: Center(
                                              child: LinearProgressIndicator(
                                                minHeight: 10.h,
                                                color: AppColor.primaryColor,
                                                backgroundColor: AppColor.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  )
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.only(bottom: 30.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 400.w,
                                        height: 350.h,
                                        child: SvgPicture.asset(
                                          "assets/deneme.svg",
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Podcasts not found",
                                      style: TextStyle(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          _podcastController
                                              .podcastsPage.value = false;
                                          setState(() {
                                            latest = true;
                                            mostPopular = false;
                                            highestRating = false;
                                            categoryName = "";
                                          });
                                        },
                                        child: Text(
                                          "Go Back",
                                          style: TextStyle(
                                              color: AppColor.primaryColor,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ))
                : Text(
                    "KATEGORİLER",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
            _podcastController.podcastsPage.value
                ? SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
                    child: Wrap(
                      spacing: 18.w,
                      children: List.generate(
                        12,
                        (index) => InkWell(
                          onTap: () async {
                            _podcastController.podcastsPage.value = true;
                            _podcastController.isLoading.value = false;
                            _podcastController.lastDocument = null;

                            if (index == 0) {
                              _podcastController.listClear.value = true;
                              _podcastController.firstLoadAllpodcast.value =
                                  true;
                              await _podcastController
                                  .getAllPodcasts("podcastcreatedtime");

                              _podcastController.firstLoadAllpodcast.value =
                                  false;
                            } else {
                              _podcastController.listClear.value = true;
                              setState(() {
                                categoryPodcast = true;
                                categoryName = categories[index];
                              });
                              print(categories[index]);

                              _podcastController.firstLoadAllpodcast.value =
                                  true;

                              await _podcastController.getAllPodcasts(
                                  "podcastcreatedtime",
                                  categoryName: categories[index]);

                              _podcastController.firstLoadAllpodcast.value =
                                  false;
                            }
                          },
                          child: Container(
                            width: 170.w,
                            height: 130.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: containerColors[index]),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 10.h),
                                  child: CircleAvatar(
                                    backgroundColor: AppColor.white,
                                    radius: 31.w,
                                    child: SizedBox(
                                      width: 45.w,
                                      height: 45.h,
                                      child: Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            categoriesPhotos[index],
                                          )),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    categories[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  InkWell filteredButtons(String text, bool isSelected) {
    return InkWell(
      onTap: () async {
        setState(() {
          switch (text) {
            case "Most Popular":
              _podcastController.lastDocument = null;
              _podcastController.listClear.value = true;
              if (mostPopular) {
                sameButton = true;
              } else {
                sameButton = false;
              }
              mostPopular = true;
              latest = false;
              highestRating = false;

              break;
            case "Latest":
              _podcastController.lastDocument = null;
              _podcastController.listClear.value = true;
              if (latest) {
                sameButton = true;
              } else {
                sameButton = false;
              }
              latest = true;
              highestRating = false;
              mostPopular = false;

              break;
            case "Highest Rating":
              _podcastController.lastDocument = null;
              _podcastController.listClear.value = true;
              if (highestRating) {
                sameButton = true;
              } else {
                sameButton = false;
              }
              highestRating = true;
              mostPopular = false;
              latest = false;

              break;
          }
        });
        if (mostPopular == true && sameButton == false) {
          _podcastController.firstLoadAllpodcast.value = true;
          await _podcastController.getAllPodcasts("podcastview",
              categoryName: categoryName);
          _podcastController.firstLoadAllpodcast.value = false;
        } else if (latest == true && sameButton == false) {
          _podcastController.firstLoadAllpodcast.value = true;
          await _podcastController.getAllPodcasts("podcastcreatedtime",
              categoryName: categoryName);
          _podcastController.firstLoadAllpodcast.value = false;
        } else if (highestRating == true && sameButton == false) {
          _podcastController.firstLoadAllpodcast.value = true;
          await _podcastController.getAllPodcasts("podcastrating",
              categoryName: categoryName);
          _podcastController.firstLoadAllpodcast.value = false;
        }
      },
      child: Container(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: AppColor.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ),
        width: 110.w,
        height: 30.h,
        decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryColor : AppColor.textFieldColor,
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
