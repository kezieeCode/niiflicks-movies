// To parse this JSON data, do

//     final liveTvs = liveTvsFromJson(jsonString);

import 'dart:convert';

LiveChannel liveTvsFromJson(String str) =>
    LiveChannel.fromJson(json.decode(str));

String liveTvsToJson(LiveChannel data) => json.encode(data.toJson());

class LiveChannel {
  LiveChannel(
      {this.id, this.link, this.name, this.image, this.status, this.youtube});
  String id;
  String status;
  String youtube;
  String link;
  String name;
  String image;

  factory LiveChannel.fromJson(Map<String, dynamic> json) => LiveChannel(
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

  static List<LiveChannel> parseRecent(List<dynamic> data) {
    List<LiveChannel> entries = List<LiveChannel>();

    data.forEach((element) => entries.add(LiveChannel.fromJson(element)));

    return entries;
  }
}
