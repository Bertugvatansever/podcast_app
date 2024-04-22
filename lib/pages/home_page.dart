import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/pages/podcast_page.dart';
import 'package:podcast_app/widgets/all_podcast_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController _userController = Get.find();
  PodcastController _podcastController = Get.find();
  bool isPhotosLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _podcastController.getContinueListeningPodcast();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            height: 60,
          ),
          Container(
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    indicatorColor: AppColor.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    labelPadding: const EdgeInsets.all(12.0),
                    tabs: [
                      Text(
                        "For You",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(
                        "Podcasts",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(
                        "AudioBook",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColor.primaryColor,
                    child: const Center(
                      child: Icon(
                        Icons.notifications,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Obx(
                  () => SingleChildScrollView(
                    // TODO WIDGETS OF TABBAR
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        SizedBox(
                          width: ScreenUtil().screenWidth,
                          height: 380.h,
                          // PageView kaydırmalı sayfa geçişlerinde çok kullanışlı
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: 400.w,
                                height: 300.h,
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
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 23.w,
                              ),
                              child: Text(
                                "Continue Listening",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.sp),
                              ),
                            ),
                            SizedBox(
                              width: 145.w,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: FaIcon(FontAwesomeIcons.arrowRight),
                              color: Colors.white,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 250.h,
                          width: ScreenUtil().screenWidth,
                          child: Padding(
                            padding: EdgeInsets.only(left: 22.w),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _podcastController.continuePodcastList.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => PodcastPage(
                                              podcast: _podcastController
                                                  .continuePodcastList[index],
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 165.w,
                                            height: 165.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey.shade900),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                width: 165.w,
                                                height: 165.h,
                                                _podcastController
                                                        .continuePodcastList[
                                                            index]
                                                        .photo ??
                                                    "",
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child; // Resim yüklendikten sonra gösterilecek widget
                                                  } else {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color:
                                                          AppColor.primaryColor,
                                                    )); // Yükleme esnasında gösterilecek widget
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Container(
                                            width: 160.w,
                                            child: Center(
                                              child: Text(
                                                _podcastController
                                                        .continuePodcastList[
                                                            index]
                                                        .name ??
                                                    "",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 160.w,
                                            child: Center(
                                              child: Text(
                                                '${_podcastController.continuePodcastList[index].user?.name ?? ""} ${_podcastController.continuePodcastList[index].user?.surName ?? ""}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AllPodcast()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
