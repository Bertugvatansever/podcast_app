import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast_app/app_colors.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  bool myPodcasts = true;
  bool downloads = false;
  bool favorites = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight / 1.12.h,
      decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Divider(
            indent: 150.w,
            endIndent: 150.w,
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Library",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 13.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (myPodcasts == false) {
                      setState(() {
                        myPodcasts = !myPodcasts;
                        downloads = false;
                        favorites = false;
                        print(myPodcasts);
                      });
                    } else {}
                  },
                  child: Container(
                    width: 122.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: myPodcasts
                            ? AppColor.primaryColor
                            : AppColor.textFieldColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "My Podcasts",
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: myPodcasts
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (downloads == false) {
                      setState(() {
                        downloads = !downloads;
                        myPodcasts = false;
                        favorites = false;
                      });
                    } else {}
                  },
                  child: Container(
                    width: 122.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: downloads
                            ? AppColor.primaryColor
                            : AppColor.textFieldColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "Downloads",
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: downloads
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (favorites == false) {
                      setState(() {
                        favorites = !favorites;
                        myPodcasts = false;
                        downloads = false;
                      });
                    } else {}
                  },
                  child: Container(
                    width: 122.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: favorites
                            ? AppColor.primaryColor
                            : AppColor.textFieldColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "Favorites",
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: favorites
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: ScreenUtil().screenWidth,
            height: 500.h,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 10.w, bottom: 12.h, top: 10.h),
                  child: Row(
                    children: [
                      Container(
                        width: 95.w,
                        height: 95.h,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/artemis.jpg",
                                )),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                      SizedBox(
                        height: 90.h,
                        width: 210.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Podcast Adı",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Podcast Sahibi",
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14.sp),
                              ),
                            ),
                            myPodcasts
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: AnimatedButton(
                                          pressEvent: () {},
                                          text: "Add Episode",
                                          color: AppColor.primaryColor,
                                          width: 150.w,
                                          height: 35.h,
                                          isFixedHeight: false,
                                          buttonTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.white),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 8.h, right: 3.w),
                          child: IconButton(
                              onPressed: () {},
                              icon: favorites
                                  ? FaIcon(
                                      size: 27,
                                      FontAwesomeIcons.solidStar,
                                      color: AppColor.primaryColor,
                                    )
                                  : downloads
                                      ? FaIcon(
                                          size: 30,
                                          FontAwesomeIcons.trashCan,
                                          color: AppColor.primaryColor,
                                        )
                                      : SizedBox()))
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
