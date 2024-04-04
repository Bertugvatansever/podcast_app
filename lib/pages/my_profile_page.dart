import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast_app/app_colors.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor.withOpacity(0.9),
            AppColor.primaryColor.withOpacity(0.8),
            AppColor.primaryColor.withOpacity(0.7),
            AppColor.primaryColor.withOpacity(0.6),
            AppColor.primaryColor.withOpacity(0.5),
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 20.w, top: 80.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 70.w,
                    child: Text(
                      "B",
                      style: TextStyle(fontSize: 70.sp),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bertuğ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "takipçi",
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "9",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "takip ediliyor",
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 23.w),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {},
                    child: Text(
                      "Profili Düzenle",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                width: 20.h,
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.solidShareFromSquare,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 20.w,
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.bookOpen,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 20.w,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(
            height: 175.h,
          ),
          Text(
            "Yakınlarda hiç hareket yok.",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text("Yeni podcastlere göz at ",
              style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
