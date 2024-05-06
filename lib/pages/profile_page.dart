import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podcast_app/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollow = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            width: ScreenUtil().screenWidth,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(),
                      width: ScreenUtil().screenHeight,
                      height: 400.h,
                      child: Image.asset(
                        "assets/roman-reigns.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: -7.h,
                      child: Text(
                        "ROMAN REIGNS",
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.sp),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "1000000",
                          style: TextStyle(
                              color: AppColor.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "Takipçi",
                          style:
                              TextStyle(color: AppColor.white, fontSize: 17.sp),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "270",
                          style: TextStyle(
                              color: AppColor.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "Takip Edilen",
                          style:
                              TextStyle(color: AppColor.white, fontSize: 17.sp),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "25",
                          style: TextStyle(
                              color: AppColor.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "Podcast Sayısı",
                          style:
                              TextStyle(color: AppColor.white, fontSize: 17.sp),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFollow = !isFollow;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: AppColor.white,
                        minimumSize: Size(200.w, 35.h)),
                    child: Text(isFollow ? "Takip ediliyor" : "Takip et")),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "Podcasts",
                  style: TextStyle(color: AppColor.white, fontSize: 20.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: 500.h,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.w, bottom: 15.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 110.w,
                                height: 110.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.shade900),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    width: 100.w,
                                    height: 100.h,
                                    "assets/artemis.jpg",
                                    fit: BoxFit.cover,
                                    // loadingBuilder:
                                    //     (context, child, loadingProgress) {
                                    //   if (loadingProgress == null) {
                                    //     return child; // Resim yüklendikten sonra gösterilecek widget
                                    //   } else {
                                    //     return Center(
                                    //         child: CircularProgressIndicator(
                                    //             color: AppColor
                                    //                 .primaryColor)); // Yükleme esnasında gösterilecek widget
                                    //   }
                                    // },
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
                                          "Deneme Podcasti",
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
                                          "Deneme Podcasti",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
