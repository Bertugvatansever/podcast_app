import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';

class AllPodcast extends StatefulWidget {
  const AllPodcast({super.key});

  @override
  State<AllPodcast> createState() => _AllPodcastState();
}

class _AllPodcastState extends State<AllPodcast> {
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
    "Psikolojik",
    "Röportaj",
    "Eğitici",
    "Müzik",
    "Komedi",
    "Haber",
    "Bilim",
    "Teknoloji",
    "Belgesel",
    "Video Oyunları",
    "Film",
    "Kitaplar",
    "Tarih"
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  height: 610.h,
                  // PageView kaydırmalı sayfa geçişlerinde çok kullanışlı
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 300.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                      color: AppColor.textFieldColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    cursorColor: AppColor.primaryColor,
                                    style: TextStyle(color: AppColor.white),
                                    enableSuggestions: false,
                                    decoration: InputDecoration(
                                        focusColor: AppColor.primaryColor,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 10.h),
                                        border: InputBorder.none,
                                        hintText: "Podcast Ara",
                                        hintStyle: TextStyle(
                                            color:
                                                AppColor.textFieldTextcolor)),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            SizedBox(
                              height: 15.h,
                            )
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              width: 400.w,
                              height: 360.h,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    "ANTİK HİKAYELER",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage("assets/Troy.png"),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: 200.h,
                                    width: 345.w,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  SizedBox(
                                    width: 350.w,
                                    height: 30.h,
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      "Sparta: Mükemmel olmak isteyen toplum.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 30.w, top: 20.h, left: 30.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 200.w,
                                              child: Text(
                                                "Bertuğ Vatanseverrrrrr ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Tarih, Savaş",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        FaIcon(
                                          FontAwesomeIcons.eye,
                                          color: AppColor.primaryColor,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          "12",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: AppColor.primaryColor,
                                          size: 30,
                                        ),
                                        Text(
                                          "4.3",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
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
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
                  child: Wrap(
                    spacing: 18.w,
                    children: List.generate(
                      14,
                      (index) => InkWell(
                        onTap: () {
                          if (index == 0) {}

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
    );
  }
}
