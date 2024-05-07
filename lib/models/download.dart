import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

part 'download.g.dart';

Download downloadsFromJson(String str) => Download.fromJson(json.decode(str));

String downloadsToJson(Download data) => json.encode(data.toJson());

@HiveType(typeId: 0)
class Download {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? location;
  @HiveField(2)
  String? podcastName;
  @HiveField(3)
  String? podcastOwner;
  @HiveField(4)
  String? podcastEpisodePhoto;
  @HiveField(5)
  String? podcastEpisodeAbout;
  @HiveField(6)
  String? podcastEpisodeName;

  Download(
      {this.id,
      this.location,
      this.podcastName,
      this.podcastOwner,
      this.podcastEpisodePhoto,
      this.podcastEpisodeAbout,
      this.podcastEpisodeName});

  factory Download.fromJson(Map<String, dynamic> json) => Download(
        id: json["id"],
        location: json["location"],
        podcastName: json["podcastName"],
        podcastOwner: json["podcastOwner"],
        podcastEpisodePhoto: json["podcastEpisodePhoto"],
        podcastEpisodeAbout: json["podcastEpisodeAbout"],
        podcastEpisodeName: json["podcastEpisodeName"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "podcastName": podcastName,
        "podcastOwner": podcastOwner,
        "podcastEpisodePhoto": podcastEpisodePhoto,
        "podcastEpisodeAbout": podcastEpisodeAbout,
        "id": id,
        "podcastEpisodeName": podcastEpisodeName
      };
}
