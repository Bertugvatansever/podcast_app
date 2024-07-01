import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/models/download.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/listening_podcast.dart';

// BAŞLANGIÇ DEĞERİ HEP 0 GELİYOR
class PodcastListenPage extends StatefulWidget {
  PodcastListenPage({
    super.key,
    required this.episodeId,
    required this.podcastId,
  });
  final String episodeId;
  final String podcastId;

  //TODO id ile local veya remotadaki listeningPodcast çekilecek

  @override
  State<PodcastListenPage> createState() => _PodcastListenPageState();
}

class _PodcastListenPageState extends State<PodcastListenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  PodcastController _podcastController = Get.find();
  UserController _userController = Get.find();
  ListeningPodcast? _listeningPodcast;
  bool confirm = false;
  bool isDownloading = false;
  bool isLoading = false;
  String? tempEpisodephoto;
  String? tempEpisodeUri;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("CALIYOR MU" + _podcastController.audioPlayer.playing.toString());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    animation = Tween<double>(begin: 0.0, end: 1).animate(_animationController);

    setState(() {
      isLoading = true;
    });

    if (_podcastController.audioPlayer.playing) {
      _animationController.forward();
    }
    _podcastController.isFinished.value = false;
    _podcastController
        .getPodcastById(widget.podcastId, widget.episodeId,
            _userController.currentUser.value.id!)
        .then((value) {
      if (value != null) {
        setState(() {
          _listeningPodcast = value;
        });

        int? duration = _podcastController
            .getEpisodeDuration(_listeningPodcast!.podcastEpisodeId!);

        if (duration != null) {
          setState(() {
            _listeningPodcast!.listeningDuration = duration;
          });
        } else {
          setState(() {
            duration = 0;
            _listeningPodcast!.listeningDuration = duration;
          });
        }

        if (_podcastController.isActiveDownloadListen.value) {
          _podcastController.audioPlayer
              .setFilePath(value.uri!,
                  initialPosition:
                      Duration(seconds: _listeningPodcast!.listeningDuration!))
              .then((_) {
            setState(() {
              isLoading = false;
            });
          });
        } else {
          _podcastController.audioPlayer
              .setUrl(value.uri!,
                  initialPosition:
                      Duration(seconds: _listeningPodcast!.listeningDuration!))
              .then((_) {
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Obx(
              () => _podcastController.isDownloadedPodcast.value
                  ? _podcastController.isActiveDownloadListen.value
                      ? IconButton(
                          onPressed: () async {
                            confirm = await _podcastController.deleteDownload(
                                _listeningPodcast!.podcastEpisodeId!,
                                _listeningPodcast!.uri!,
                                _listeningPodcast!.podcastEpisodePhoto!);
                            confirm
                                ? _podcastController.downloadsList.removeWhere(
                                    (element) =>
                                        element.podcastEpisodeId ==
                                        _listeningPodcast!.podcastEpisodeId)
                                : ();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Center(
                                    child: confirm
                                        ? Text(
                                            "Dosya başarıyla silindi  !",
                                            style: TextStyle(fontSize: 15.sp),
                                          )
                                        : Text(
                                            "Dosya silinirken bir hata oluştu !",
                                            style: TextStyle(fontSize: 15.sp),
                                          )),
                                showCloseIcon: true,
                                backgroundColor: confirm
                                    ? AppColor.primaryColor
                                    : Colors.red));
                            setState(() {
                              print(isLoading);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: confirm ? Colors.red : Colors.white,
                            size: 27.sp,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: Icon(
                            Icons.check,
                            color: AppColor.white,
                          ),
                        )
                  : IconButton(
                      onPressed: () async {
                        _podcastController.isDownloadingPodcast.value = true;
                        confirm = await _podcastController.downloadPodcastFile(
                            _listeningPodcast!.uri,
                            _listeningPodcast!.podcastEpisodePhoto,
                            _listeningPodcast!.podcastEpisodeId!);
                        tempEpisodephoto =
                            _listeningPodcast!.podcastEpisodePhoto;
                        tempEpisodeUri = _listeningPodcast!.uri;

                        _listeningPodcast!.podcastEpisodePhoto =
                            _podcastController.downloadPhotoPath.value;
                        _listeningPodcast!.uri =
                            _podcastController.downloadFilePath.value;
                        await _podcastController
                            .downloadPodcastLocalDb(_listeningPodcast!);
                        _listeningPodcast!.podcastEpisodePhoto =
                            tempEpisodephoto;
                        _listeningPodcast!.uri = tempEpisodeUri;

                        _podcastController.isDownloadingPodcast.value = false;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Center(
                                child: confirm
                                    ? Text(
                                        "Dosya başarıyla indirildi  !",
                                        style: TextStyle(fontSize: 15.sp),
                                      )
                                    : Text(
                                        "Dosya indirilirken bir hata oluştu !",
                                        style: TextStyle(fontSize: 15.sp),
                                      )),
                            showCloseIcon: true,
                            backgroundColor:
                                confirm ? AppColor.primaryColor : Colors.red));
                        await _podcastController.checkPodcastDownloaded(
                            _listeningPodcast!.podcastEpisodeId!);
                      },
                      icon: _podcastController.isDownloadingPodcast.value
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: CircularProgressIndicator(
                                color: AppColor.primaryColor,
                                strokeWidth: 4.0.w,
                              ),
                            )
                          : FaIcon(
                              FontAwesomeIcons.download,
                              color: AppColor.white,
                            )),
            ),
          )
        ],
        title: Text(
          _listeningPodcast?.podcastName ?? "",
          style: TextStyle(
            color: AppColor.white,
            fontSize: 18.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
        leading: IconButton(
            onPressed: () async {
              if (_podcastController.isActiveDownloadListen.value == false &&
                  _podcastController.isFinished.value == false) {
                print(_podcastController.isFinished.value);
                _podcastController.setContinueListeningPodcast(
                    _userController.currentUser.value.id!, _listeningPodcast!);
              } else {
                await _podcastController.getContinueListeningPodcast(
                    _userController.currentUser.value.id!);
              }

              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.white,
            )),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Center(
                    child: _podcastController.isActiveDownloadListen.value
                        ? Container(
                            width: 300.w,
                            height: 300.h,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: Image.file(
                                File(_listeningPodcast?.podcastEpisodePhoto ??
                                    ""),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            width: 300.w,
                            height: 300.h,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: Image.network(
                                loadingBuilder:
                                    (context, child, loadingProgress) {
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
                                _listeningPodcast?.podcastEpisodePhoto ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 48.w),
                      child: SizedBox(
                        width: 300.w,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          _listeningPodcast?.podcastName ?? "",
                          style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.sp),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 48.w),
                      child: SizedBox(
                        width: 300.w,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          _listeningPodcast?.podcastEpisodeName ?? "",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 20.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  SizedBox(
                    width: 290.w,
                    child: StreamBuilder<Duration?>(
                      stream: _podcastController.audioPlayer.positionStream,
                      builder: (context, snapshotPosition) {
                        return StreamBuilder<Duration?>(
                            initialData: Duration(
                                seconds: _listeningPodcast!.listeningDuration!),
                            stream:
                                _podcastController.audioPlayer.durationStream,
                            builder: (context, snapshotDuration) {
                              if (snapshotPosition.data != null) {
                                _podcastController.setEpisodeDuration(
                                    _listeningPodcast!.podcastEpisodeId!,
                                    snapshotPosition.data!.inSeconds);
                              }

                              return ProgressBar(
                                progress: snapshotPosition.data ??
                                    Duration(
                                        seconds: _listeningPodcast!
                                            .listeningDuration!),
                                total: snapshotDuration.data ?? Duration(),
                                baseBarColor: AppColor.white,
                                thumbColor:
                                    AppColor.primaryColor.withOpacity(0.9),
                                progressBarColor: AppColor.primaryColor,
                                thumbRadius: 7.w,
                                thumbGlowRadius: 15.w,
                                timeLabelTextStyle: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 16.sp),
                                timeLabelLocation: TimeLabelLocation.below,
                                timeLabelPadding: 5.h,
                                onSeek: (duration) {
                                  print("zaman" + duration.toString());
                                  _podcastController.audioPlayer.seek(duration);
                                },
                              );
                            });
                      },
                    ),
                  ),
                  Stack(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 35.w),
                          child: IconButton(
                            onPressed: () {
                              final currentPosition =
                                  _podcastController.audioPlayer.position;
                              final newPosition =
                                  currentPosition - Duration(seconds: 10);
                              _podcastController.audioPlayer.seek(newPosition);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.rotateLeft,
                              size: 60,
                              color: AppColor.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: CircleAvatar(
                            backgroundColor: AppColor.primaryColor,
                            radius: 40.w,
                            child: Center(
                              child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: animation,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_podcastController.audioPlayer.playing) {
                              _animationController.reverse();
                              _podcastController.audioPlayer.pause();
                            } else {
                              _animationController.forward();
                              _podcastController.audioPlayer.play();
                              _podcastController.audioPlayer.playerStateStream
                                  .listen((state) {
                                if (state.processingState ==
                                    ProcessingState.completed) {
                                  _podcastController.audioPlayer
                                      .seek(Duration.zero);
                                  _animationController.reverse();
                                  _podcastController.audioPlayer.stop();

                                  _podcastController
                                      .deleteContinueListeningPodcast(
                                          _userController.currentUser.value.id!,
                                          _listeningPodcast!.podcastEpisodeId!);
                                  _userController.deleteEpisodeDuration(
                                      _listeningPodcast!.podcastEpisodeId!);
                                  _podcastController.isFinished.value = true;
                                }
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 35.w),
                          child: IconButton(
                            onPressed: () {
                              final currentPosition =
                                  _podcastController.audioPlayer.position;
                              final newPosition =
                                  currentPosition + Duration(seconds: 10);
                              _podcastController.audioPlayer.seek(newPosition);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.rotateRight,
                              size: 60,
                              color: AppColor.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 34.5.h,
                      left: 70.w,
                      child: Text(
                        "10",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: 34.5.h,
                      right: 70.w,
                      child: Text(
                        "10",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6.w),
                        child: Text(
                          "Bölüm Hakkında",
                          style:
                              TextStyle(color: Colors.white, fontSize: 32.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: IconButton(
                            onPressed: () {},
                            icon: FaIcon(
                              FontAwesomeIcons.turnDown,
                              color: Colors.white,
                              size: 27,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Card(
                      color: AppColor.textFieldColor.withOpacity(0.7),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        child: Text(
                          _listeningPodcast?.podcastEpisodeAbout ?? "",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
