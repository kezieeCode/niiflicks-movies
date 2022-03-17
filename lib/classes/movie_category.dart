// To parse this JSON data, do
//
//     final movieCategory = movieCategoryFromJson(jsonString);

import 'dart:convert';

MovieCategory movieCategoryFromJson(String str) =>
    MovieCategory.fromJson(json.decode(str));

String movieCategoryToJson(MovieCategory data) => json.encode(data.toJson());

class MovieCategory {
  MovieCategory({
    this.id,
    this.title,
    this.thumbnail,
    this.movie,
    this.rating,
    this.categories,
    this.status,
    this.duration,
    this.releasedate,
    this.budget,
    this.overview,
    this.images,
    this.trailer,
    this.keywords,
  });

  String id;
  String title;
  String thumbnail;
  String movie;
  String rating;
  String categories;
  String status;
  String duration;
  DateTime releasedate;
  String budget;
  String overview;
  String images;
  String trailer;
  String keywords;

  factory MovieCategory.fromJson(Map<String, dynamic> json) => MovieCategory(
        id: json["id"],
        title: json["title"],
        thumbnail: json["thumbnail"],
        movie: json["movie"],
        rating: json["rating"],
        categories: json["categories"],
        status: json["status"],
        duration: json["duration"],
        releasedate: DateTime.parse(json["releasedate"]),
        budget: json["budget"],
        overview: json["overview"],
        images: json["images"],
        trailer: json["trailer"],
        keywords: json["keywords"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "movie": movie,
        "rating": rating,
        "categories": categories,
        "status": status,
        "duration": duration,
        "releasedate":
            "${releasedate.year.toString().padLeft(4, '0')}-${releasedate.month.toString().padLeft(2, '0')}-${releasedate.day.toString().padLeft(2, '0')}",
        "budget": budget,
        "overview": overview,
        "images": images,
        "trailer": trailer,
        "keywords": keywords,
      };
  static List<MovieCategory> parseRecent(List<dynamic> data) {
    List<MovieCategory> entries = List<MovieCategory>();

    data.forEach((element) => entries.add(MovieCategory.fromJson(element)));

    return entries;
  }
}
