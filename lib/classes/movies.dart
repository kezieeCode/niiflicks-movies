// To parse this JSON data, do
//
//     final actionPart = actionPartFromJson(jsonString);

import 'dart:convert';

Movies actionPartFromJson(String str) => Movies.fromJson(json.decode(str));

String actionPartToJson(Movies data) => json.encode(data.toJson());

class Movies {
  Movies({
    this.cover,
    this.title,
    this.date,
    this.vidId,
    this.replaced,
  });

  String cover;
  String title;
  DateTime date;
  String vidId;
  String replaced;

  factory Movies.fromJson(Map<String, dynamic> json) => Movies(
        cover: json["cover"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        vidId: json["vid_id"],
        replaced: json["replaced"],
      );

  Map<String, dynamic> toJson() => {
        "cover": cover,
        "title": title,
        "date": date.toIso8601String(),
        "vid_id": vidId,
        "replaced": replaced,
      };

  static List<Movies> parseRecent(List<dynamic> data) {
    List<Movies> entries = List<Movies>();

    data.forEach((element) => entries.add(Movies.fromJson(element)));

    return entries;
  }
}
