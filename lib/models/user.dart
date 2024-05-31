// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

import 'package:podcast_app/models/podcast.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? name;
  String? surName;
  String? photo;
  String? email;
  int? createdTime;
  List<String>? favourite;
  Map<String, double>? myRatings;
  User(
      {required this.id,
      required this.name,
      required this.surName,
      required this.photo,
      required this.email,
      required this.createdTime,
      required this.favourite,
      required this.myRatings});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        surName: json["surname"],
        photo: json["photo"],
        email: json["email"],
        createdTime: json["createdtime"],
        favourite: json["favourites"] == null
            ? []
            : List<String>.from(json["favourites"]!.map((x) => x)),
        myRatings: json["myRatings"] == null
            ? {}
            : Map<String, double>.from(json["myRatings"]
                .map((key, value) => MapEntry(key, value.toDouble()))),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surName,
        "photo": photo,
        "email": email,
        "createdtime": createdTime,
        "favourites": favourite
      };
}
