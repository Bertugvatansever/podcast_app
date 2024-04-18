// To parse this JSON data, do
//
//     final Episode = EpisodeFromJson(jsonString);

import 'dart:convert';

Episode episodeFromJson(String str) => Episode.fromJson(json.decode(str));

String episodeToJson(Episode data) => json.encode(data.toJson());

class Episode {
  String id;
  String name;
  String podcastName;
  String file;
  String episodeImage;
  int createdTime;
  String episodeAbout;

  Episode(
      {required this.id,
      required this.name,
      required this.podcastName,
      required this.file,
      required this.episodeImage,
      required this.createdTime,
      required this.episodeAbout});

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
      id: json["episodeid"],
      name: json["episodename"],
      podcastName: json["podcastname"],
      file: json["episodefile"],
      episodeImage: json["episodeimage"],
      createdTime: json["episodecreatedtime"],
      episodeAbout: json["episodeabout"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "podcastname": podcastName,
        "file": file,
        "episodeimage": episodeImage,
        "createdtime": createdTime,
        "episodeabout": episodeAbout
      };
}
