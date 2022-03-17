// To parse this JSON data, do
//
//     final liveTvs = liveTvsFromJson(jsonString);

import 'dart:convert';

LiveTvRecent liveTvsFromJson(String str) =>
    LiveTvRecent.fromJson(json.decode(str));

String liveTvsToJson(LiveTvRecent data) => json.encode(data.toJson());

class LiveTvRecent {
  LiveTvRecent({
    this.id,
    this.link,
    this.name,
    this.image,
    this.youtube,
  });
  String id;
  String youtube;
  String link;
  String name;
  String image;

  factory LiveTvRecent.fromJson(Map<String, dynamic> json) => LiveTvRecent(
        id: json["id"],
        link: json["link"],
        name: json["name"],
        image: json["image"],
        youtube: json["youtube"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "name": name,
        "image": image,
        "youtube": youtube
      };

  static List<LiveTvRecent> parseRecent(List<dynamic> data) {
    List<LiveTvRecent> entries = List<LiveTvRecent>();

    data.forEach((element) => entries.add(LiveTvRecent.fromJson(element)));

    return entries;
  }
}
