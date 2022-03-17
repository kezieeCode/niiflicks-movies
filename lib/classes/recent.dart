// To parse this JSON data, do
//
//     final recent = recentFromJson(jsonString);

import 'dart:convert';

Recent recentFromJson(String str) => Recent.fromJson(json.decode(str));

String recentToJson(Recent data) => json.encode(data.toJson());

class Recent {
  Recent({
    this.thumbnail,
    this.title,
    this.date,
    this.slug,
  });

  String thumbnail;
  String title;
  String date;
  String slug;

  factory Recent.fromJson(Map<String, dynamic> json) => Recent(
        thumbnail: json["thumbnail"],
        title: json["title"],
        date: json["date"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail,
        "title": title,
        "date": date,
        "slug": slug,
      };
  static List<Recent> parseRecent(List<dynamic> data) {
    List<Recent> entries = List<Recent>();

    data.forEach((element) => entries.add(Recent.fromJson(element)));

    return entries;
  }
}
