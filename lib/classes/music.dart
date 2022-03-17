// To parse this JSON data, do
//
//     final getViews = getViewsFromJson(jsonString);

import 'dart:convert';

Musics getViewsFromJson(String str) => Musics.fromJson(json.decode(str));

String getViewsToJson(Musics data) => json.encode(data.toJson());

class Musics {
  Musics({
    this.musics,
  });

  int musics;

  factory Musics.fromJson(Map<String, dynamic> json) => Musics(
        musics: json["musics"],
      );

  Map<String, dynamic> toJson() => {
        "musics": musics,
      };
}
