// To parse this JSON data, do
//
//     final science = scienceFromJson(jsonString);

import 'dart:convert';

Science scienceFromJson(String str) => Science.fromJson(json.decode(str));

String scienceToJson(Science data) => json.encode(data.toJson());

class Science {
  Science({
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

  factory Science.fromJson(Map<String, dynamic> json) => Science(
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

  static List<Science> parseRecent(List<dynamic> data) {
    List<Science> entries = List<Science>();

    data.forEach((element) => entries.add(Science.fromJson(element)));

    return entries;
  }
}
