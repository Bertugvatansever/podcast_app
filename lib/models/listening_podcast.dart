// To parse this JSON data, do
//
//     final ListeningPodcast = PodcastFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

import 'package:podcast_app/models/comment.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/user.dart';

class ListeningPodcast {
  String? podcastId;
  String? podcastEpisodeId;
  String? uri;
  String? podcastName;
  String? podcastOwner;
  String? podcastEpisodePhoto;
  String? podcastEpisodeAbout;
  String? podcastEpisodeName;
  int? listeningDuration;

  ListeningPodcast({
    required this.podcastId,
    required this.podcastEpisodeId,
    required this.uri,
    required this.podcastName,
    required this.podcastOwner,
    required this.podcastEpisodePhoto,
    required this.podcastEpisodeAbout,
    required this.podcastEpisodeName,
  });

  factory ListeningPodcast.fromJson(Map<String, dynamic> json) =>
      ListeningPodcast(
          podcastId: json["podcastId"],
          podcastEpisodeId: json["podcastEpisodeId"],
          uri: json["uri"],
          podcastName: json["podcastName"],
          podcastOwner: json["podcastOwner"],
          podcastEpisodePhoto: json["podcastEpisodePhoto"],
          podcastEpisodeAbout: json["podcastEpisodeAbout"],
          podcastEpisodeName: json["podcastEpisodeName"]);

  Map<String, dynamic> toJson() => {
        "podcastId": podcastId,
        "podcastEpisodeId": podcastEpisodeId,
        "uri": uri,
        "podcastName": podcastName,
        "podcastOwner": podcastOwner,
        "podcastEpisodePhoto": podcastEpisodePhoto,
        "podcastEpisodeAbout": podcastEpisodeAbout,
        "podcastEpisodeName": podcastEpisodeName,
      };
}
