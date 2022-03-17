// To parse this JSON data, do
//
//     final getRelated = getRelatedFromJson(jsonString);

import 'dart:convert';

GetRelated getRelatedFromJson(String str) =>
    GetRelated.fromJson(json.decode(str));

String getRelatedToJson(GetRelated data) => json.encode(data.toJson());

class GetRelated {
  GetRelated({
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
    this.payment,
    this.price,
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
  String payment;
  String price;
  String overview;
  String images;
  String trailer;
  String keywords;

  factory GetRelated.fromJson(Map<String, dynamic> json) => GetRelated(
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
        payment: json["payment"],
        price: json["price"],
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
        "payment": payment,
        "price": price,
        "overview": overview,
        "images": images,
        "trailer": trailer,
        "keywords": keywords,
      };
  static List<GetRelated> parseRecent(List<dynamic> data) {
    List<GetRelated> entries = List<GetRelated>();

    data.forEach((element) => entries.add(GetRelated.fromJson(element)));

    return entries;
  }
}
