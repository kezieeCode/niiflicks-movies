import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/classes/new_releases.dart';

import 'package:niiflicks/models/movie.dart';
import '../screens/movie_details_screen.dart';

class TopRatedListItem extends StatefulWidget {
  final int index;
  TopRatedListItem(this.index);

  @override
  _TopRatedListItemState createState() => _TopRatedListItemState();
}

class _TopRatedListItemState extends State<TopRatedListItem> {
  Future<List<Releases>> releases() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/newreleases');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return Releases.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: releases(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
              padding: const EdgeInsets.all(10),
              width: 160,
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => MovieDetailsScreen()));
                },
                child: Column(
                  children: buildTrendingColumns(snapshot.data),
                ),
              ),
            );
          }
        });
  }
}

List<Widget> buildTrendingColumns(
  List<Releases> data,
) {
  if (data.isNotEmpty) {
    return data.asMap().entries.map((element) {
      return Column(
        children: [
          Card(
            elevation: 10,
            child: Hero(
              tag: topRatedMovieList,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(element.value.thumbnail),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            element.value.title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }).toList();
  } else {
    return [Container()].toList();
  }
}
