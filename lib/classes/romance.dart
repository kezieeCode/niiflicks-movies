// To parse this JSON data, do
//
//     final actionPart = actionPartFromJson(jsonString);

import 'dart:convert';

Romance actionPartFromJson(String str) => Romance.fromJson(json.decode(str));

String actionPartToJson(Romance data) => json.encode(data.toJson());

class Romance {
  Romance({
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

  factory Romance.fromJson(Map<String, dynamic> json) => Romance(
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

  static List<Romance> parseRecent(List<dynamic> data) {
    List<Romance> entries = List<Romance>();

    data.forEach((element) => entries.add(Romance.fromJson(element)));

    return entries;
  }
}
