import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/widgets/podcast_add_first.dart';
import 'package:podcast_app/widgets/podcast_add_second.dart';

class PodcastAdd extends StatefulWidget {
  PodcastAdd({super.key, this.podcast});
  final Podcast? podcast;
  @override
  State<PodcastAdd> createState() => _PodcastAddState();
}

class _PodcastAddState extends State<PodcastAdd>
    with SingleTickerProviderStateMixin {
  PodcastController _podcastController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Text(
              "New Podcast",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Obx(
        () => Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: SingleChildScrollView(
                child: _podcastController.startPage.value
                    ? PodcastAddFirstWidget()
                    : PodcastAddSecondWidget(
                        podcast: widget.podcast,
                      )),
          ),
        ]),
      ),
    );
  }
}
