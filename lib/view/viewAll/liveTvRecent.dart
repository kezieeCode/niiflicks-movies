import 'package:flutter/material.dart';
import 'package:niiflicks/classes/new_releases.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/home/detail.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:niiflicks/classes/live_tvs_recent_.dart';
import 'package:niiflicks/view/video/web_game.dart';
import 'package:niiflicks/view/video/youtube_player.dart';
import 'package:url_launcher/url_launcher.dart';

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);

class liveTvRecentPage extends StatefulWidget {
  @override
  _liveTvRecentPageState createState() => _liveTvRecentPageState();
// }

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: liveTvRecentPage(),
    );
  }
}

class _liveTvRecentPageState extends State<liveTvRecentPage> {
  // Future<List<Trending>> trending() async {
  //   var url = Uri.parse('https://niiflicks.com/niiflicks/apis/movies/trending');
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return Trending.parseRecent(jsonDecode(response.body)["data"]);
  //   } else {
  //     throw Exception('Check your internet connection');
  //   }
  // }

  Future<List<LiveTvRecent>> LiveTvsRecent() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/livetv.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('for new releases');
      print(response.body);
      return LiveTvRecent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  // Future<List<Popular>> popular() async {
  //   var url =
  //       Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getpopular');
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return Popular.parseRecent(jsonDecode(response.body)["data"]);
  //   } else {
  //     throw Exception('Check your internet connection');
  //   }
  // }

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
            ' Recent Games'.toUpperCase(),
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
            future: LiveTvsRecent(),
            builder: (BuildContext context,
                AsyncSnapshot<List<LiveTvRecent>> snapshot) {
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
                    return Movie_Information(
                        movie_id: snapshot.data[index].id,
                        movie_title: snapshot.data[index].name,
                        movie_link: snapshot.data[index].link,
                        movie_image: snapshot.data[index].image,
                        movie_youtube: snapshot.data[index].youtube);
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

List<Widget> buildTrendingColumns(List<LiveTvRecent> data) {
  if (data.isNotEmpty) {
    return data.asMap().entries.map((element) {
      return Column(
        children: [
          Container(
            height: 120,
            child: Card(
              shadowColor: Colors.red,
              color: Colors.black,
              elevation: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'poster-${element.value.id}',
                        child: Image.network(
                          element.value.image,
                          // height: 150
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            element.value.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 16.0, bottom: 8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                // children: movies.genreIds
                                //     .take(3)
                                //     .map(buildGenreChip)
                                //     .toList(),
                                ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
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

class Movie_Information extends StatelessWidget {
  final movie_id;
  final movie_title;
  final movie_link;
  final movie_image;
  final movie_youtube;

  Movie_Information({
    this.movie_id,
    this.movie_title,
    this.movie_link,
    this.movie_image,
    this.movie_youtube,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launch(movie_link);
        // print(movie_youtube);
        // if (movie_youtube == "yes") {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => YouTubeLive(
        //                 stream: movie_link,
        //               )));
        // } else {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => WebGame(
        //                 stream: movie_link,
        //               )));
        // }
      },
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.black,
            shadowColor: Colors.red,
            elevation: 1,
            borderOnForeground: true,
            child: Image.network(
              movie_image,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
