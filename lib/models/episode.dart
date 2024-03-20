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
  DateTime createdTime;

  Episode({
    required this.id,
    required this.name,
    required this.podcastName,
    required this.file,
    required this.createdTime,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json["id"],
        name: json["name"],
        podcastName: json["podcastname"],
        file: json["file"],
        createdTime: json["createdtime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "podcastname": podcastName,
        "file": file,
        "createdtime": createdTime,
      };
}
