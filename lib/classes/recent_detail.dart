// To parse this JSON data, do
//
//     final recentDetails = recentDetailsFromJson(jsonString);

import 'dart:convert';

RecentDetails recentDetailsFromJson(String str) =>
    RecentDetails.fromJson(json.decode(str));

String recentDetailsToJson(RecentDetails data) => json.encode(data.toJson());

class RecentDetails {
  RecentDetails({
    this.title,
    this.title2,
    this.description,
    this.stream,
    this.download,
    this.downloadId,
  });

  String title;
  String title2;
  String description;
  String stream;
  String download;
  String downloadId;

  factory RecentDetails.fromJson(Map<String, dynamic> json) => RecentDetails(
        title: json["title"],
        title2: json["title2"],
        description: json["description"],
        stream: json["stream"],
        download: json["download"],
        downloadId: json["download_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "title2": title2,
        "description": description,
        "stream": stream,
        "download": download,
        "download_id": downloadId,
      };
  static List<RecentDetails> parseRecent(List<dynamic> data) {
    List<RecentDetails> entries = List<RecentDetails>();

    data.forEach((element) => entries.add(RecentDetails.fromJson(element)));

    return entries;
  }
}
