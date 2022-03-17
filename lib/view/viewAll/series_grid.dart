import 'package:flutter/material.dart';

import 'package:niiflicks/classes/new_releases.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:niiflicks/classes/paid_movies_model.dart';
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/classes/series.dart';
import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/home/recent_detail.dart';
import 'package:niiflicks/view/home/seriies_details.dart';
import 'package:progress_indicators/progress_indicators.dart';

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);

class PaidMovieszz extends StatefulWidget {
  @override
  _PaidMovieState createState() => _PaidMovieState();
// }

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: PaidMovieszz(),
    );
  }
}

class _PaidMovieState extends State<PaidMovieszz> {
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

  Future<List<Series>> paidMoviesAll() async {
    var url =
        Uri.parse('https://www.niiflicks.com/niiflicks/apis/movies/get_series.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return Series.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future<List<Recent>> movieList() async {
    var uri = 'https://simplemovie.p.rapidapi.com/movie/list/recent';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return Recent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      throw Exception('No data to display');
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
  var connect = 'https://niiflicks.com/producers/storage/filmposters/';
  var series = 'https://niiflicks.com/producers/storage/tvseries/filmposters/';
var slash = '/';
var tvtrailers = 'https://niiflicks.com/producers/storage/tvseries/trailers/';
var trailer = 'https://niiflicks.com/producers/storage/trailers/';
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
            'SEASONAL MOVIES'.toUpperCase(),
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'NotoSerifJP-Light',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
            future: paidMoviesAll(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Series>> snapshot) {
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
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    print(series+snapshot.data[index].filmposter);
                    return SeriesInformation(
                               series_id: snapshot.data[index].id,
                               filmposter: series+snapshot.data[index].filmposter,
                               title: snapshot.data[index].title,
                               overview: snapshot.data[index].overview,
                               trailer: tvtrailers+slash+snapshot.data[index].trailer,
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

List<Widget> buildTrendingColumns(List<Releases> data) {
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
                          element.value.thumbnail,
                          // height: 150
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            element.value.title,
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
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, right: 8.0),
                          child: Text(
                            element.value.overview,
                            style: TextStyle(color: Colors.red),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
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

class Movie_Information extends StatefulWidget {
  final movie_id;
  final movie_title;
  final movie_date;
  final movie_description;
  final movie_movie;
  final movie_image;

  Movie_Information({
    this.movie_id,
    this.movie_title,
    this.movie_description,
    this.movie_movie,
    this.movie_date,
    this.movie_image,
  });

  @override
  State<Movie_Information> createState() => _Movie_InformationState();
}

class _Movie_InformationState extends State<Movie_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => DetailsScreen(
                id: widget.movie_id,
                  description: widget.movie_description,
                  cover: widget.movie_image,
                  movie: widget.movie_movie,
                  title: widget.movie_title)));
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
        child: Container(
          width: 20,
          height: double.infinity,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.black,
              shadowColor: Colors.red,
              elevation: 1,
              borderOnForeground: true,
              child: Image.network(
                widget.movie_image,
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }
}
class SeriesInformation extends StatefulWidget {
  final series_id;
  final title;
  final filmposter;
  final overview;
  final trailer;

  SeriesInformation({this.series_id, this.title, this.filmposter, this.overview,this.trailer});

  @override
  _SeriesInformationState createState() => _SeriesInformationState();
}


class _SeriesInformationState extends State<SeriesInformation> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
   
        print(widget.title);
        print(widget.filmposter);
        print(widget.overview);
        print(widget.trailer);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SeriesDetails(
          series_id: widget.series_id,
          title: widget.title,
          cover: widget.filmposter,
          overview: widget.overview,
          trailer: widget.trailer,
        )));
      },
      child:Container(
        child: Card(
          color: Colors.black,
          shadowColor: Colors.red,
          elevation: 7,
          borderOnForeground: true,
          child: Image(
            image: NetworkImage(widget.filmposter),
            height: 100,
          ),
        ),
      ),
    );
  }
}