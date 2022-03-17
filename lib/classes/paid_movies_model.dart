// To parse this JSON data, do
//
//     final paidMoviesz = paidMovieszFromJson(jsonString);

import 'dart:convert';

PaidMoviesz paidMovieszFromJson(String str) => PaidMoviesz.fromJson(json.decode(str));

String paidMovieszToJson(PaidMoviesz data) => json.encode(data.toJson());

class PaidMoviesz {
    PaidMoviesz({
        this.id,
        this.title,
        this.trailer,
        this.movie,
        this.overview,
        this.filmposter,
        this.duration,
    });

    String id;
    String title;
    String trailer;
    dynamic movie;
    String overview;
    String filmposter;
    String duration;

    factory PaidMoviesz.fromJson(Map<String, dynamic> json) => PaidMoviesz(
        id: json["id"],
        title: json["title"],
        trailer: json["trailer"],
        movie: json["movie"],
        overview: json["overview"],
        filmposter: json["filmposter"],
        duration: json["duration"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "trailer": trailer,
        "movie": movie,
        "overview": overview,
        "filmposter": filmposter,
        "duration": duration,
    };
    static List<PaidMoviesz> parseRecent(List<dynamic> data) {
    List<PaidMoviesz> entries = List<PaidMoviesz>();

    data.forEach((element) => entries.add(PaidMoviesz.fromJson(element)));

    return entries;
  }
}


     