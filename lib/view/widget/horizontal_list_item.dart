import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:niiflicks/classes/trending.dart';
import 'package:niiflicks/view/screens/movie_details_screen.dart';

import 'package:niiflicks/models/movie.dart';
import 'package:http/http.dart' as http;

class HorizontalListItem extends StatefulWidget {
  // final int index;
  // final id;
  // final title;
  // final duration;
  // final ratings;
  // final description;

  // HorizontalListItem(
  //   this.index,
  // );

  @override
  _HorizontalListItemState createState() => _HorizontalListItemState();
}

class _HorizontalListItemState extends State<HorizontalListItem> {
  Future<List<Trending>> trending() async {
    var url = Uri.parse('https://niiflicks.com/niiflicks/apis/movies/trending');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return Trending.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: trending(),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Text('No internet connection');
        } else if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(10),
            width: 160,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => MovieDetailsScreen(
                //             //  id: (snapshot.data.),
                //             )));
              },
              child: Column(
                children: buildTrendingColumns(snapshot.data),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> buildTrendingColumns(List<Trending> data) {
    if (data.isNotEmpty) {
      return data.asMap().entries.map((element) {
        return Column(
          children: [
            Card(
              elevation: 10,
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
            SizedBox(
              height: 10,
            ),
            Text(
              element.value.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }).toList();
    } else {
      return [Container()].toList();
    }
  }
}
