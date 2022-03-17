// To parse this JSON data, do
//
//     final getViews = getViewsFromJson(jsonString);

import 'dart:convert';

GetViews getViewsFromJson(String str) => GetViews.fromJson(json.decode(str));

String getViewsToJson(GetViews data) => json.encode(data.toJson());

class GetViews {
  GetViews({
    this.noofviews,
  });

  int noofviews;

  factory GetViews.fromJson(Map<String, dynamic> json) => GetViews(
        noofviews: json["noofviews"],
      );

  Map<String, dynamic> toJson() => {
        "noofviews": noofviews,
      };
}
