// To parse this JSON data, do
//
//     final seasons = seasonsFromJson(jsonString);

import 'dart:convert';

Seasons seasonsFromJson(String str) => Seasons.fromJson(json.decode(str));

String seasonsToJson(Seasons data) => json.encode(data.toJson());

class Seasons {
  Seasons({
    this.id,
    this.tvseriesId,
    this.filmposter,
    this.seasonNumber,
    this.dollaramount,
    this.viewCount,
  });

  String id;
  String tvseriesId;
  String filmposter;
  String seasonNumber;
  String dollaramount;
  String viewCount;

  factory Seasons.fromJson(Map<String, dynamic> json) => Seasons(
        id: json["id"],
        tvseriesId: json["tvseries_id"],
        filmposter: json["filmposter"],
        seasonNumber: json["season_number"],
        dollaramount: json["dollaramount"],
        viewCount: json["view_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tvseries_id": tvseriesId,
        "filmposter": filmposter,
        "season_number": seasonNumber,
        "dollaramount": dollaramount,
        "view_count": viewCount,
      };
  static List<Seasons> parseRecent(List<dynamic> data) {
    List<Seasons> entries = List<Seasons>();

    data.forEach((element) => entries.add(Seasons.fromJson(element)));

    return entries;
  }
}
