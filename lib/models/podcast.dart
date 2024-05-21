// To parse this JSON data, do
//
//     final Podcast = PodcastFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

import 'package:podcast_app/models/comment.dart';
import 'package:podcast_app/models/episode.dart';
import 'package:podcast_app/models/user.dart';

class Podcast {
  String? id;
  String? name;
  List<String>? category;
  String? photo;
  String? about;
  int? createdTime;
  String? rating;
  User? user;
  List<Comment>? comments;
  List<String>? episodes;

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
      category:
          (json["podcastcategory"] as List).map((e) => e.toString()).toList(),
      photo: json["podcastimage"],
      about: json["podcastabout"],
      createdTime: json["podcastcreatedtime"],
      rating: json["podcastrating"],
      user: User.fromJson(json["podcastuser"]),
      comments: json["podcastcomments"] == null
          ? []
          : (json["podcastcomments"] as List)
              .map((e) => Comment.fromJson(e.toJson()))
              .toList(),
      episodes:
          (json["podcastcategory"] as List).map((e) => e.toString()).toList());

  Map<String, dynamic> toJson() => {
        "podcastid": id,
        "podcastname": name,
        "podcastcategory": category,
        "podcastphoto": photo,
        "podcastabout": about,
        "podcastcreatedTime": createdTime,
        "podcastrating": rating,
        "podcastuser": user?.toJson(),
        "podcastcomments": comments?.map((e) => e.toJson()).toList(),
        "podcastepisodes": episodes
      };
}
