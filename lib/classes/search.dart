// To parse this JSON data, do
//
//     final serch = serchFromJson(jsonString);

import 'dart:convert';

Search serchFromJson(String str) => Search.fromJson(json.decode(str));

String serchToJson(Search data) => json.encode(data.toJson());

class Search {
  Search({
    this.id,
    this.title,
    this.thumbnail,
    this.movie,
    this.rating,
    this.categories,
    this.status,
    this.duration,
    this.releasedate,
    this.payment,
    this.price,
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
  String payment;
  String price;
  String budget;
  String overview;
  String images;
  String trailer;
  String keywords;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
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
  static List<Search> parseRecent(List<dynamic> data) {
    List<Search> entries = List<Search>();

    data.forEach((element) => entries.add(Search.fromJson(element)));

    return entries;
  }
}
