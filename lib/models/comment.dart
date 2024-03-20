// To parse this JSON data, do
//
//     final Comment = CommentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  String id;
  String name;
  String surName;
  String photo;
  String rating;
  String text;
  DateTime createdTime;

  Comment({
    required this.id,
    required this.name,
    required this.surName,
    required this.photo,
    required this.rating,
    required this.text,
    required this.createdTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        name: json["name"],
        surName: json["surname"],
        photo: json["photo"],
        rating: json["rating"],
        text: json["text"],
        createdTime: json["createdtime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surName,
        "photo": photo,
        "rating": rating,
        "text": text,
        "createdtime": createdTime,
      };
}
