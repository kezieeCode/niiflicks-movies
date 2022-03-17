// To parse this JSON data, do
//
//     final science = scienceFromJson(jsonString);

import 'dart:convert';

Actionss actionssFromJson(String str) => Actionss.fromJson(json.decode(str));

String actionssToJson(Actionss data) => json.encode(data.toJson());

class Actionss {
  Actionss({
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

  factory Actionss.fromJson(Map<String, dynamic> json) => Actionss(
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

  static List<Actionss> parseRecent(List<dynamic> data) {
    List<Actionss> entries = [];

    data.forEach((element) => entries.add(Actionss.fromJson(element)));

    return entries;
  }
}
