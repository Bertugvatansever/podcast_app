import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';

class PodcastAddFirstWidget extends StatefulWidget {
  const PodcastAddFirstWidget({super.key});

  @override
  State<PodcastAddFirstWidget> createState() => _PodcastAddFirstWidgetState();
}

class _PodcastAddFirstWidgetState extends State<PodcastAddFirstWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  bool isSelected = true;

  Map<String, bool> isSelectedList = {};
  Color chipTextColor = Colors.black;
  List<String> selectedCategories = [];
  final PodcastController _podcastController = Get.find();

  final List<String> categories = [
    'Teknoloji',
    'Spor',
    'Sağlık',
    'Eğitim',
    'Moda',
    'Gastronomi',
    'Sanat',
    'Seyahat',
    'Müzik',
    'Sinema',
  ];
  TextEditingController _podcastNameController = TextEditingController();
  TextEditingController _podcastAboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _podcastNameController.text = _podcastController.podcastName.value;
    _podcastAboutController.text = _podcastController.podcastAbout.value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(children: [
        SizedBox(
          height: 15.h,
        ),
        Text(
          "Podcast Name",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColor.textFieldColor),
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: _podcastNameController,
            enableSuggestions: false,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                hintText: "Your Podcast Name",
                hintStyle: TextStyle(
                    color: AppColor.textFieldTextcolor, fontSize: 18.sp)),
            textAlign: TextAlign.center,
          ),
          width: 310.w,
          height: 50.h,
        ),
        SizedBox(
          height: 15.h,
        ),
        Text(
          "Podcast Category",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(categories.length, (index) {
            return buildChoiceChip(index);
          }),
        ),
        SizedBox(height: 10.h),
        Text(
          "Podcast About",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 25),
          color: AppColor.textFieldColor,
          child: TextField(
            enableSuggestions: false,
            style: TextStyle(color: Colors.white),
            controller: _podcastAboutController,
            minLines: 1,
            maxLines: 10,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              border: InputBorder.none,
              hintText: "Write About Podcast...",
              hintStyle: TextStyle(
                color: AppColor.textFieldTextcolor,
                fontSize: 20.sp,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 60.w),
              child: Text(
                "Podcast Image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            IconButton(
              icon: Icon(Icons.upload),
              color: AppColor.primaryColor,
              onPressed: () async {
                await _podcastController.selectPodcastPhoto();
              },
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Obx(() => _podcastController.podcastImageFile.value.path.isNotEmpty
            ? Container(
                child: Image.file(
                  File(_podcastController.podcastImageFile.value.path),
                  fit: BoxFit.cover,
                ),
                height: 200.h,
                width: 300.h,
              )
            : Container(
                child: Center(
                  child: Text(
                    "Please select a Photo",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
                  ),
                ),
                height: 200.h,
                width: 300.h,
                color: Colors.white,
              )),
        SizedBox(
          height: 15.h,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 13.h),
          child: ElevatedButton(
            onPressed: _podcastNameController.text.isNotEmpty &&
                    _podcastAboutController.text.isNotEmpty &&
                    _podcastController.selectedCategories.isNotEmpty &&
                    _podcastController.podcastImageFile.value.path.isNotEmpty
                ? () {
                    _podcastController.podcastName.value =
                        _podcastNameController.text;

                    _podcastController.podcastAbout.value =
                        _podcastAboutController.text;

                    _podcastController.startPage.value = false;
                  }
                : null,
            child: Text("Devam Et"),
            style: ElevatedButton.styleFrom(
                disabledForegroundColor: Colors.black,
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color.fromARGB(255, 180, 174, 174)),
          ),
        ),
      ]),
    );
  }

  Widget buildChoiceChip(int index) {
    return ChoiceChip(
      checkmarkColor: Colors.white,
      backgroundColor: Colors.white,
      label: Text(categories[index]),
      labelStyle: TextStyle(
          color:
              _podcastController.selectedCategories[categories[index]] == true
                  ? Colors.white
                  : Colors.black),
      selected:
          _podcastController.selectedCategories[categories[index]] == true,
      selectedColor: AppColor.primaryColor,
      onSelected: (value) {
        if (_podcastController.selectedCategories.keys
            .contains(categories[index])) {
          _podcastController.selectedCategories.remove(categories[index]);
        } else if (_podcastController.selectedCategories.keys.length <= 2) {
          _podcastController.selectedCategories[categories[index]] = value;
        }

        setState(() {
          _podcastController.selectedCategories[categories[index]] == true
              ? chipTextColor = Colors.white
              : chipTextColor = Colors.black;
        });
      },
    );
  }
}
