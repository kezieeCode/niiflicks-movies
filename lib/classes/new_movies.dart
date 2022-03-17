// To parse this JSON data, do
//
//     final newMovies = newMoviesFromJson(jsonString);

import 'dart:convert';

NewMovies newMoviesFromJson(String str) => NewMovies.fromJson(json.decode(str));

String newMoviesToJson(NewMovies data) => json.encode(data.toJson());

class NewMovies {
  NewMovies({
    this.id,
    this.rank,
    this.rankUpDown,
    this.title,
    this.fullTitle,
    this.year,
    this.image,
    this.crew,
    this.imDbRating,
    this.imDbRatingCount,
  });

  String id;
  String rank;
  String rankUpDown;
  String title;
  String fullTitle;
  String year;
  String image;
  String crew;
  String imDbRating;
  String imDbRatingCount;

  factory NewMovies.fromJson(Map<String, dynamic> json) => NewMovies(
        id: json["id"],
        rank: json["rank"],
        rankUpDown: json["rankUpDown"],
        title: json["title"],
        fullTitle: json["fullTitle"],
        year: json["year"],
        image: json["image"],
        crew: json["crew"],
        imDbRating: json["imDbRating"],
        imDbRatingCount: json["imDbRatingCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank": rank,
        "rankUpDown": rankUpDown,
        "title": title,
        "fullTitle": fullTitle,
        "year": year,
        "image": image,
        "crew": crew,
        "imDbRating": imDbRating,
        "imDbRatingCount": imDbRatingCount,
      };
  static List<NewMovies> parseRecent(List<dynamic> data) {
    List<NewMovies> entries = List<NewMovies>();

    data.forEach((element) => entries.add(NewMovies.fromJson(element)));

    return entries;
  }
}
