import 'package:flutter/material.dart';
import 'package:niiflicks/classes/actor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/home/detail.dart';
import 'package:progress_indicators/progress_indicators.dart';

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);

class ActorsPage extends StatefulWidget {
  @override
  _ActorsPageState createState() => _ActorsPageState();
// }

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: ActorsPage(),
    );
  }
}

class _ActorsPageState extends State<ActorsPage> {
  Future<List<Actor>> actors() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getactors');
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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              )),
          title: Text(
            'Producers'.toUpperCase(),
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'NotoSerifJP-Light',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
            future: actors(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: JumpingDotsProgressIndicator(
                    numberOfDots: 5,
                    color: Colors.red,
                    fontSize: 100.0,
                    // valueColor:
                    //     new AlwaysStoppedAnimation<Color>(ColorConst.APP_COLOR),
                  ),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Movie_Info(
                      movie_id: snapshot.data[index].id,
                      movie_title: snapshot.data[index].title,
                      movie_thumbnail: snapshot.data[index].picture,
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

// List<Widget> buildTrendingColumns(List<Actor> data) {
//   if (data.isNotEmpty) {
//     return data.asMap().entries.map((element) {
//       return Column(
//         children: [
//           Container(
//             height: 120,
//             child: Card(
//               shadowColor: Colors.red,
//               color: Colors.black,
//               elevation: 10,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Expanded(
//                     flex: 1,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Hero(
//                         tag: 'poster-${element.value.id}',
//                         child: Image.network(
//                           element.value.thumbnail,
//                           // height: 150
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             element.value.title,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, color: Colors.red),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 8.0, right: 16.0, bottom: 8.0),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                                 // children: movies.genreIds
//                                 //     .take(3)
//                                 //     .map(buildGenreChip)
//                                 //     .toList(),
//                                 ),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsets.only(bottom: 8.0, right: 8.0),
//                           child: Text(
//                             element.value.overview,
//                             style: TextStyle(color: Colors.red),
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//         ],
//       );
//     }).toList();
//   } else {
//     return [Container()].toList();
//   }
// }

class Movie_Info extends StatelessWidget {
  final movie_id;
  final movie_title;
  final movie_trailer;
  final movie_image;
  final movie_payment;
  final movie_thumbnail;
  final movie_release_date;
  final movie_overview;
  final movie_duration;
  final movie_movie;
  Movie_Info(
      {this.movie_id,
      this.movie_title,
      this.movie_trailer,
      this.movie_image,
      this.movie_payment,
      this.movie_thumbnail,
      this.movie_release_date,
      this.movie_overview,
      this.movie_duration,
      this.movie_movie});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Card(
        color: Colors.black,
        shadowColor: Colors.red,
        elevation: 7,
        borderOnForeground: true,
        child: Image(
          image: NetworkImage(movie_thumbnail),
          height: 100,
        ),
      ),
    );
  }
}
