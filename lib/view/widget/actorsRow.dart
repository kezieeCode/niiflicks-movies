import 'package:flutter/material.dart';
import 'package:niiflicks/classes/actor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);

class ActorsRow extends StatefulWidget {
  final thumbnails;
  final titles;
  final overviews;
  final budgets;
  final durations;
  final image;
  final play_movies;
  ActorsRow(
      {this.thumbnails,
      this.titles,
      this.overviews,
      this.budgets,
      this.durations,
      this.image,
      this.play_movies});
  @override
  _ActorsRowState createState() => _ActorsRowState();
// }

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: ActorsRow(),
    );
  }
}

class _ActorsRowState extends State<ActorsRow> {
  Future<List<Actor>> actors() async {
    var url = Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getactors');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return Actor.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: actors(),
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
                    height: 180,
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

List<Widget> buildTrendingColumns(List<Actor> data) {
  if (data.isNotEmpty) {
    return data.asMap().entries.map((element) {
      return Column(
        children: [
          circleAvatars(
              image: NetworkImage(element.value.picture), color: Colors.red),
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

Widget circleAvatars({ImageProvider image, Color color}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: color, width: 3),
    ),
    child: CircleAvatar(
      backgroundImage: image,
      maxRadius: 70,
    ),
  );
}
