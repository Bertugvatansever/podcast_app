// To parse this JSON data, do
//
//     final Podcast = PodcastFromJson(jsonString);

import 'dart:convert';

import 'package:podcast_app/models/comment.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/user.dart';

Podcast podcastFromJson(String str) => Podcast.fromJson(json.decode(str));

String podcastToJson(Podcast data) => json.encode(data.toJson());

class Podcast {
  String id;
  String name;
  List<String> category;
  String photo;
  String about;
  DateTime createdTime;
  String rating;
  User user;
  List<Comment> comments;
  List<Episode> episodes;

  Podcast(
      {required this.id,
      required this.name,
      required this.category,
      required this.photo,
      required this.about,
      required this.createdTime,
      required this.rating,
      required this.user,
      required this.comments,
      required this.episodes});

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
      id: json["podcastid"],
      name: json["podcastname"],
      category: json["podcastcategory"],
      photo: json["podcastphoto"],
      about: json["podcastabout"],
      createdTime: json["podcastcreatedTime"],
      rating: json["podcastrating"],
      user: json["podcastuser"],
      comments: json["podcastcomments"],
      episodes: json["podcastepisodes"]);

  Map<String, dynamic> toJson() => {
        "podcastid": id,
        "podcastname": name,
        "podcastcategory": category,
        "podcastphoto": photo,
        "podcastabout": about,
        "podcastcreatedTime": createdTime,
        "podcastrating": rating,
        "podcastuser": user,
        "podcastcomments": comments,
        "podcastepisodes": episodes
      };
}
