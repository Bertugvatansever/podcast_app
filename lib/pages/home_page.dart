import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast_app/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    indicatorColor: AppColor().primaryColor,
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
                    backgroundColor: AppColor().primaryColor,
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

          //   height: 60,
          //   child: TabBar(
          //     indicatorSize: TabBarIndicatorSize.tab,
          //     dividerColor: Colors.transparent,
          //     labelColor: Colors.white,
          //     unselectedLabelColor: Colors.grey,
          //     labelPadding: EdgeInsets.zero,
          //     tabs: [
          //       Text(
          //         "For You",
          //         style: TextStyle(fontSize: 16.sp),
          //       ),
          //       Text(
          //         "Podcasts",
          //         style: TextStyle(fontSize: 16.sp),
          //       ),
          //       Text(
          //         "AudioBook",
          //         style: TextStyle(fontSize: 16.sp),
          //       ),
          //     ],
          //   ),
          // ),

// TODO WIDGETS OF TABBAR
          Expanded(
            child: Container(
              width: ScreenUtil().screenWidth,
              child: TabBarView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.w),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          height: 200.h,
                          width: 345.w,
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: Text(
                              "Continue Listening",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.sp),
                            ),
                          ),
                          SizedBox(
                            width: 140.w,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: FaIcon(FontAwesomeIcons.arrowRight),
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(left: 25.w),
                        child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              width: 175.w,
                              height: 175.h,
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
