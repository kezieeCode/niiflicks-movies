// To parse this JSON data, do
//
//     final movieModels = movieModelsFromJson(jsonString);

import 'dart:convert';

MovieModels movieModelsFromJson(String str) => MovieModels.fromJson(json.decode(str));

String movieModelsToJson(MovieModels data) => json.encode(data.toJson());

class MovieModels {
    MovieModels({
        this.title,
        this.streamLink,
        this.synopsis,
    });

    String title;
    String streamLink;
    String synopsis;

    factory MovieModels.fromJson(Map<String, dynamic> json) => MovieModels(
        title: json["title"],
        streamLink: json["stream_link"],
        synopsis: json["synopsis"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "stream_link": streamLink,
        "synopsis": synopsis,
    };
     
}
