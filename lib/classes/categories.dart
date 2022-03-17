// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
    Category({
        this.id,
        this.category,
        this.picture,
        this.datecreated,
    });

    String id;
    String category;
    String picture;
    DateTime datecreated;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        category: json["category"],
        picture: json["picture"],
        datecreated: DateTime.parse(json["datecreated"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "picture": picture,
        "datecreated": datecreated.toIso8601String(),
    };
    static List<Category>parseRecent(List<dynamic> data) {
    List<Category> entries = List<Category>();

    data.forEach((element) => entries.add(Category.fromJson(element)));

    return entries;
  }
}
