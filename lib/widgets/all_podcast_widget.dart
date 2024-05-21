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

class _AllPodcastState extends State<AllPodcast> {
  ScrollController _scrollController = ScrollController();
  bool categoryPodcast = false;
  String categoryName = "";
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels > 0) {
        if (_podcastController.emptyPodcast.value == false) {
          _podcastController.isLoading.value = true;
          _podcastController.listClear.value = false;
          _podcastController.getAllPodcasts(categoryName: categoryName);
        } else {
          _podcastController.isLoading.value = false;
        }
      }
    });
  }

  PodcastController _podcastController = Get.find();
  List<Color> containerColors = [
    AppColor.primaryColor,
    Color.fromRGBO(41, 93, 225, 0.957),
    Color.fromRGBO(247, 55, 55, 0.94),
    Color.fromRGBO(214, 32, 32, 0.957),
    Color.fromRGBO(125, 226, 66, 0.957),
    Color.fromRGBO(192, 97, 175, 0.957),
    Color.fromRGBO(196, 241, 35, 0.957),
    Color.fromRGBO(71, 148, 176, 0.957),
    Color.fromRGBO(18, 13, 17, 0.957),
    Color.fromRGBO(228, 1, 186, 0.957),
    Color.fromRGBO(21, 163, 224, 0.957),
    Color.fromRGBO(215, 199, 212, 0.957),
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
    "Film",
    "Kitaplar",
    "Tarih"
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: _podcastController.podcastsPage.value ? 0.h : 20.h),
            ),
            _podcastController.podcastsPage.value
                ? SizedBox()
                : Text(
                    "KATEGORİLER",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
            _podcastController.podcastsPage.value
                ? SizedBox(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight -
                        kBottomNavigationBarHeight * 3.25,
                    // PageView kaydırmalı sayfa geçişlerinde çok kullanışlı
                    child: _podcastController.allPodcasts.isNotEmpty
                        ? Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      _podcastController.allPodcasts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 0) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    _podcastController
                                                        .podcastsPage
                                                        .value = false;
                                                  },
                                                  icon: FaIcon(
                                                    FontAwesomeIcons
                                                        .arrowLeftLong,
                                                    color: AppColor.white,
                                                  )),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: 300.w,
                                                    height: 32.h,
                                                    decoration: BoxDecoration(
                                                        color: AppColor
                                                            .textFieldColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    child: TextField(
                                                      cursorColor:
                                                          AppColor.primaryColor,
                                                      style: TextStyle(
                                                          color:
                                                              AppColor.white),
                                                      enableSuggestions: false,
                                                      decoration: InputDecoration(
                                                          focusColor: AppColor
                                                              .primaryColor,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  bottom: 10.h),
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Podcast Ara",
                                                          hintStyle: TextStyle(
                                                              color: AppColor
                                                                  .textFieldTextcolor)),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Column(
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
                                                              "12",
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
                                                              "4.3",
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
                                                  podcast: _podcastController
                                                      .allPodcasts[index]));
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
                                                            FontWeight.bold),
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
                                                                .circular(15),
                                                        color: Colors
                                                            .grey.shade900),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.network(
                                                        width: 345.w,
                                                        height: 200.h,
                                                        _podcastController
                                                                .allPodcasts[
                                                                    index]
                                                                .photo ??
                                                            "",
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
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
                                                          TextOverflow.ellipsis,
                                                      _podcastController
                                                          .allPodcasts[index]
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
                                                    padding: EdgeInsets.only(
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
                                                              child: SizedBox(
                                                                height: 50.h,
                                                                width: 170.w,
                                                                child: ListView
                                                                    .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount:
                                                                      (_podcastController.allPodcasts[index].category ??
                                                                              [])
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int i) {
                                                                    return Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        i == (_podcastController.allPodcasts[i].category ?? []).length - 1
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
                                                                          width:
                                                                              2.w,
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
                                                          FontAwesomeIcons.eye,
                                                          color: AppColor
                                                              .primaryColor,
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Text(
                                                          "12",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                          "4.3",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                              _podcastController.isLoading.value
                                  ? Container(
                                      width: ScreenUtil().screenWidth,
                                      height: 17.h,
                                      color: Colors.transparent,
                                      child: Center(
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          color: AppColor.primaryColor,
                                          minHeight: 17.h,
                                        ),
                                      ),
                                    )
                                  : SizedBox()
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
                                      _podcastController.podcastsPage.value =
                                          false;
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
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
                    child: Wrap(
                      spacing: 18.w,
                      children: List.generate(
                        14,
                        (index) => InkWell(
                          onTap: () async {
                            if (index == 0) {
                              _podcastController.listClear.value = true;
                              await _podcastController.getAllPodcasts();
                            } else {
                              _podcastController.listClear.value = true;
                              setState(() {
                                categoryPodcast = true;
                                categoryName = categories[index];
                              });
                              print(categories[index]);
                              await _podcastController.getAllPodcasts(
                                  categoryName: categories[index]);
                            }

                            _podcastController.podcastsPage.value = true;
                          },
                          child: Container(
                            width: 170.w,
                            height: 95.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: containerColors[index]),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                            // İstenilen boşluk değerini burada belirtin
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
}
