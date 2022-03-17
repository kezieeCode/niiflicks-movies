import 'package:flutter/material.dart';
// import 'package:niiflicks/classes/actor.dart';
import 'package:niiflicks/classes/new_releases.dart';
import 'package:niiflicks/classes/popular.dart';
import 'dart:convert';
import 'package:niiflicks/classes/trending.dart';
import 'package:niiflicks/view/screens/movie_details_screen.dart';

import 'package:niiflicks/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/models/movie.dart';
import 'package:niiflicks/view/widget/horizontal_list_item.dart';

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);

class PopularRow extends StatefulWidget {
  @override
  _PopularRowState createState() => _PopularRowState();
// }
// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: PopularRow(),
    );
  }
}

class _PopularRowState extends State<PopularRow> {
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

  Future<List<Releases>> newreleases() async {
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

  Future<List<Popular>> popular() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getpopular');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return Popular.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: popular(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Text('No internet connection');
          } else if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              // width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 210,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(right: 10),
                      shrinkWrap: true,
                      children: buildTrendingColumns(snapshot.data),
                    ),
                  )
                ],
              ),
            );

            // return Material(
            //   child: Container(
            //     // bgbgColor: ColorConst.WHITE_BG_COLOR,
            //     child: Center(
            //       child: ListView(
            //         children: <Widget>[
            //
            //
            //
            //
            //           Container(
            //
            //             height: 260,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget>[
            //                 Row(
            //                   children: <Widget>[
            //                     SizedBox(
            //                       width: 10,
            //                     ),
            //                     Text("Trending", style: kTitleStyle),
            //                   ],
            //                 ),
            //                 SizedBox(
            //                   height: 10,
            //                 ),
            //                 Container(
            //                   height: 200,
            //                   child: ListView(
            //                     scrollDirection: Axis.horizontal,
            //                     padding: EdgeInsets.only(right: 10),
            //                     shrinkWrap: true,
            //                     children:  buildTrendingColumns(snapshot.data),
            //
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //
            //
            //
            //
            //         ],
            //       ),
            //     ),
            //   ),
            // );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

List<Widget> buildTrendingColumns(List<Popular> data) {
  if (data.isNotEmpty) {
    return data.asMap().entries.map((element) {
      return Column(
        children: [
          Container(
            height: 200,
            child: Card(
              shadowColor: Colors.red,
              color: Colors.black,
              elevation: 10,
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(element.value.thumbnail))),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    }).toList();
  } else {
    return [Container()].toList();
  }
}
