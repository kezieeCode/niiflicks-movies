// To parse this JSON data, do
//
//     final series = seriesFromJson(jsonString);

import 'dart:convert';

Series seriesFromJson(String str) => Series.fromJson(json.decode(str));

String seriesToJson(Series data) => json.encode(data.toJson());

class Series {
    Series({
        this.id,
        this.title,
        this.filmposter,
        this.description,
        this.trailer,
        this.overview,
        
    });

    String id;
    String title;
    String filmposter;
    String description;
    String overview;
    String trailer;

    factory Series.fromJson(Map<String, dynamic> json) => Series(
        id: json["id"],
        title: json["title"],
        filmposter: json["filmposter"],
        description: json["description"],
        overview: json["overview"],
        trailer: json["trailer"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "filmposter": filmposter,
        "description": description,
        "overview": overview,
        "trailer": trailer,
    };
    static List<Series> parseRecent(List<dynamic> data) {
    List<Series> entries = List<Series>();

    data.forEach((element) => entries.add(Series.fromJson(element)));

    return entries;
  }
}
