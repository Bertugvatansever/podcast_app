import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podcast_app/app_colors.dart';

class AllPodcast extends StatefulWidget {
  const AllPodcast({super.key});

  @override
  State<AllPodcast> createState() => _AllPodcastState();
}

class _AllPodcastState extends State<AllPodcast> {
  List<Color> containerColors = [
    AppColor.primaryColor,
    Color.fromRGBO(92, 133, 237, 0.957),
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
  bool isSearchActive = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20.h,
            ),
            child: Align(
              alignment: Alignment.center,
              child: isSearchActive
                  ? Container(
                      width: 300.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                          color: AppColor.textFieldColor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: TextField(
                        style: TextStyle(color: AppColor.white),
                        enableSuggestions: false,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10.h),
                            border: InputBorder.none,
                            hintText: "Podcast Ara",
                            hintStyle:
                                TextStyle(color: AppColor.textFieldTextcolor)),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Text(
                      "KATEGORİLER",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
            child: Wrap(
              spacing: 18.w,
              children: List.generate(
                14,
                (index) => InkWell(
                  onTap: () {
                    setState(() {
                      isSearchActive = true;
                    });
                  },
                  child: Container(
                    width: 170.w,
                    height: 95.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
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
