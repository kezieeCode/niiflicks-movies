// To parse this JSON data, do

//     final liveTvs = liveTvsFromJson(jsonString);

import 'dart:convert';

LiveTvs liveTvsFromJson(String str) => LiveTvs.fromJson(json.decode(str));

String liveTvsToJson(LiveTvs data) => json.encode(data.toJson());

class LiveTvs {
  LiveTvs(
      {this.id, this.link, this.name, this.image, this.status, this.youtube});
  String id;
  String status;
  String youtube;
  String link;
  String name;
  String image;

  factory LiveTvs.fromJson(Map<String, dynamic> json) => LiveTvs(
        id: json["id"],
        link: json["link"],
        status: json["status"],
        youtube: json["youtube"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "name": name,
        "status": status,
        "youtube": youtube,
        "image": image,
      };

  static List<LiveTvs> parseRecent(List<dynamic> data) {
    List<LiveTvs> entries = List<LiveTvs>();

    data.forEach((element) => entries.add(LiveTvs.fromJson(element)));

    return entries;
  }
}
