// To parse this JSON data, do
//
//     final releases = releasesFromJson(jsonString);

import 'dart:convert';

List<Releases> releasesFromJson(String str) =>
    List<Releases>.from(json.decode(str).map((x) => Releases.fromJson(x)));

String releasesToJson(List<Releases> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Releases {
  Releases(
      {this.id,
      this.title,
      this.thumbnail,
      this.movie,
      this.rating,
      this.categories,
      this.payment,
      this.price,
      this.status,
      this.duration,
      this.releasedate,
      this.budget,
      this.overview,
      this.images,
      this.trailer,
      this.keywords,
      this.whouploaded,
      this.uploadstatus,
      this.producerlink});

  String id;
  String title;
  String thumbnail;
  String movie;
  String rating;
  String categories;
  String payment;
  String price;
  String status;
  String duration;
  String releasedate;
  // DateTime releasedate;
  String budget;
  String overview;
  String images;
  String trailer;
  String keywords;
  String whouploaded;
  String uploadstatus;
  String producerlink;

  factory Releases.fromJson(Map<String, dynamic> json) => Releases(
      id: json["id"],
      title: json["title"],
      thumbnail: json["thumbnail"],
      movie: json["movie"],
      rating: json["rating"],
      categories: json["categories"],
      payment: json["payment"],
      price: json["price"],
      status: json["status"],
      duration: json["duration"],
      releasedate: json["releasedate"],
      // releasedate: DateTime.parse(json["releasedate"]),
      budget: json["budget"],
      overview: json["overview"],
      images: json["images"],
      trailer: json["trailer"],
      keywords: json["keywords"],
      uploadstatus: json["uploadstatus"],
      producerlink: json["producerlink"],
      whouploaded: json["whouploaded"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "movie": movie,
        "rating": rating,
        "categories": categories,
        "payment": payment,
        "price": price,
        "status": status,
        "duration": duration,
        "releasedate": releasedate,
        // "releasedate":
        //     "${releasedate.year.toString().padLeft(4, '0')}-${releasedate.month.toString().padLeft(2, '0')}-${releasedate.day.toString().padLeft(2, '0')}",
        "budget": budget,
        "overview": overview,
        "images": images,
        "trailer": trailer,
        "keywords": keywords,
        "whouploaded": whouploaded,
        "uploadstatus": uploadstatus,
        "producerlink": producerlink
      };
  static List<Releases> parseRecent(List<dynamic> data) {
    List<Releases> entries = List<Releases>();

    data.forEach((element) => entries.add(Releases.fromJson(element)));

    return entries;
  }
}
