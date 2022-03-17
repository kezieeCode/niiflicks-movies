// To parse this JSON data, do
//
//     final releases = releasesFromJson(jsonString);

import 'dart:convert';

List<Actor> releasesFromJson(String str) => List<Actor>.from(json.decode(str).map((x) => Actor.fromJson(x)));

String releasesToJson(List<Actor> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Actor {
  Actor({
    this.id,
    this.title,
    this.picture,

  });

  String id;
  String title;
  String picture;


  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
    id: json["id"],
    title: json["title"],
    picture: json["picture"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "picture": picture,

  };
  static List<Actor>parseRecent(List<dynamic> data) {
    List<Actor> entries = List<Actor>();

    data.forEach((element) => entries.add(Actor.fromJson(element)));

    return entries;
  }
}