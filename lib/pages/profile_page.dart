import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/models/user.dart';
import 'package:podcast_app/pages/podcast_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profileUser});
  final User profileUser;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PodcastController _podcastController = Get.find();
  bool isFollow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _podcastController.getProfilePodcasts(widget.profileUser.id!);
  }

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
                      width: ScreenUtil().screenHeight,
                      height: 400.h,
                      child: Image.network(
                        width: ScreenUtil().screenHeight,
                        height: 400.h,
                        widget.profileUser.photo!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.primaryColor,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      bottom: -7.h,
                      child: Text(
                        "${widget.profileUser.name} ${widget.profileUser.surName}"
                            .toUpperCase(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Container(
                          width: 41.w,
                          height: 41.h,
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.backward,
                              color: AppColor.white,
                              size: 17,
                            ),
                          ),
                        )),
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
                    IconButton(
                        onPressed: () {},
                        icon: Container(
                          width: 41.w,
                          height: 41.h,
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.block_sharp,
                              color: AppColor.white,
                              size: 23,
                            ),
                          ),
                        )),
                  ],
                ),
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
                Obx(
                  () => SizedBox(
                    width: ScreenUtil().screenWidth,
                    height: 500.h,
                    child: ListView.builder(
                      itemCount: _podcastController.profilePodcastList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => PodcastPage(
                                podcast: _podcastController
                                    .profilePodcastList[index]));
                          },
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
                                    child: Image.network(
                                      width: 110.w,
                                      height: 110.h,
                                      _podcastController
                                          .profilePodcastList[index].photo!,
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
                                      padding: EdgeInsets.only(
                                          top: 15.h, left: 15.w),
                                      child: SizedBox(
                                        width: 250.w,
                                        child: Center(
                                          child: Text(
                                            _podcastController
                                                .profilePodcastList[index]
                                                .name!,
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
                                      padding: EdgeInsets.only(
                                          top: 15.h, left: 15.w),
                                      child: SizedBox(
                                        width: 250.w,
                                        child: Center(
                                          child: Text(
                                            "${_podcastController.profilePodcastList[index].user!.name!} ${_podcastController.profilePodcastList[index].user!.surName!}",
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
      ),
    );
  }
}
