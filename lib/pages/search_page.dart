import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/pages/podcast_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

PodcastController _podcastController = PodcastController();

class _SearchPageState extends State<SearchPage> {
  List<Podcast> searchPodcastList = [];
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _podcastController.getAllPodcastsSearch().then((_) {
      searchPodcastList.addAll(_podcastController.searchPodcastList);
      print("SEARCH" + searchPodcastList.length.toString());
      _podcastController.searchPodcastList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Search Page",
          style: TextStyle(color: AppColor.white),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Center(
                  child: Container(
                    width: 250.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: AppColor.textFieldColor),
                    child: TextField(
                      onChanged: (value) {
                        searchPodcast(value);
                      },
                      controller: _textEditingController,
                      style: TextStyle(color: AppColor.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Search Podcast",
                        hintStyle:
                            TextStyle(color: AppColor.textFieldTextcolor),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(bottom: 9.h, left: 9.w, right: 9.w),
                      ),
                      cursorColor: AppColor.primaryColor.withOpacity(0.4),
                      enableSuggestions: false,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight -
                    kBottomNavigationBarHeight * 4.75.h,
                child: _podcastController.searchPodcastList.isEmpty
                    ? _textEditingController.text.isNotEmpty
                        ? Center(
                            child: Text(
                              "No podcasts found",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              "Please Search Podcast",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          )
                    : ListView.builder(
                        itemCount: _podcastController.searchPodcastList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => PodcastPage(
                                      podcast: _podcastController
                                          .searchPodcastList[index]));
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Container(
                                        width: 120.w,
                                        height: 120.h,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          child: Image.network(
                                            _podcastController
                                                .searchPodcastList[index]
                                                .photo!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 35.w,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          _podcastController
                                              .searchPodcastList[index].name!,
                                          style: TextStyle(
                                              color: AppColor.white,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Text(
                                          "${_podcastController.searchPodcastList[index].user!.name!} ${_podcastController.searchPodcastList[index].user!.surName!}",
                                          style: TextStyle(
                                              color:
                                                  AppColor.textFieldTextcolor,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              )
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchPodcast(String searchWord) {
    _podcastController.searchPodcastList.clear();
    if (searchWord.isEmpty) {
      _podcastController.searchPodcastList.clear();
    }

    if (searchPodcastList.isNotEmpty && searchWord.isNotEmpty) {
      _podcastController.searchPodcastList.addAll(searchPodcastList.where(
          (podcast) =>
              podcast.name!.toLowerCase().contains(searchWord.toLowerCase()) ||
              podcast.user!.name!
                  .toLowerCase()
                  .contains(searchWord.toLowerCase()) ||
              podcast.user!.surName!
                  .toLowerCase()
                  .contains(searchWord.toLowerCase())));
    }
    setState(() {});
  }
}
