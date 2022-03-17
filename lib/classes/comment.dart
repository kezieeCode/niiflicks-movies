// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));

String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    this.id,
    this.uid,
    this.mid,
    this.commenti,
  });

  String id;
  String uid;
  String mid;
  String commenti;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        id: json["id"],
        uid: json["uid"],
        mid: json["mid"],
        commenti: json["commenti"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "mid": mid,
        "commenti": commenti,
      };
  static List<Comments> parseRecent(List<dynamic> data) {
    List<Comments> entries = List<Comments>();

    data.forEach((element) => entries.add(Comments.fromJson(element)));

    return entries;
  }
}
