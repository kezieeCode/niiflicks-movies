import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:niiflicks/classes/paid_movies_model.dart';
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/classes/series.dart';
import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/home/recent_detail.dart';
import 'package:niiflicks/view/home/recent_detail_paid.dart';
import 'package:niiflicks/view/home/seriies_details.dart';
import 'package:niiflicks/view/screens/search.dart';
import 'package:niiflicks/view/viewAll/niiflicks_premieres.dart';
import 'package:niiflicks/view/viewAll/recent_page.dart';
import 'package:niiflicks/view/viewAll/series_grid.dart';
import 'package:niiflicks/view/viewAll/trends.dart';
import 'package:api_cache_manager/api_cache_manager.dart';

class PaidMovies extends StatefulWidget {
  const PaidMovies({Key key}) : super(key: key);

  @override
  _PaidMoviesState createState() => _PaidMoviesState();
}

Future<List<PaidMoviesz>> paidMovies() async {
  var url = 'http://www.niiflicks.com/niiflicks/apis/movies/d_movies.php';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var newresponse = jsonDecode(response.body)["error"];
    if (newresponse == false) {
      print(response.body);
      print('it showed');
      return PaidMoviesz.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
    }
  } else {
    print(response.body);
    throw Exception('No data to display');
  }
}

Future niiflicksPremieres() async {
  var uri = 'https://universal-studios1.p.rapidapi.com/cinema-movies.php';

  var response = await http.get(Uri.parse(uri), headers: {
    'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
    'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
  });
  if (response.statusCode == 200) {
    print(response.body);
    return Recent.parseRecent(jsonDecode(response.body)["data"]);
  } else {
    print(response.body);
    throw Exception('No data to display');
  }
}

Future<List<Series>> seriesMovies() async {
  var url = 'https://www.niiflicks.com/niiflicks/apis/movies/get_series.php';
  var isCachExist = await APICacheManager().isAPICacheKeyExist('series');
  var response = await http.get(Uri.parse(url));
  if (!isCachExist) {
    print('cache never did');
    if (response.statusCode == 200) {
      APICacheDBModel apiCacheDBModel =
          new APICacheDBModel(key: 'series', syncData: response.body);
      await APICacheManager().addCacheData(apiCacheDBModel);
      print(response.body);
      print('it worked');
      return Series.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      throw Exception('There was nothing');
    }
  } else {
    print(response.body);
    print('it exists');
    var cacheData = await APICacheManager().getCacheData('series');
    return Series.parseRecent(jsonDecode(cacheData.syncData)["data"]);
  }
}

initState() {
  seriesMovies();
  paidMovies();
}

var connect = 'https://niiflicks.com/producers/storage/movie/filmposters/';
var series = 'https://niiflicks.com/producers/storage/tvseries/filmposters/';
var tvtrailers = 'https://niiflicks.com/producers/storage/tvseries/trailers/';
var slash = '/';
var trailer = 'https://niiflicks.com/producers/storage/movie/trailers/';
var movie = 'https://niiflicks.com/producers/storage/movie/movies/';

class _PaidMoviesState extends State<PaidMovies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Exclusive content'.toUpperCase(),
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.red,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Hollywood',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    FlatButton(
                      child: Text(
                        'View All',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NiiflicksPremieres()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                child: FutureBuilder(
                  future: niiflicksPremieres(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, i) => Premiere_Information(
                                id: snapshot.data[i].slug,
                                title: snapshot.data[i].title,
                                covers: snapshot.data[i].thumbnail,
                              ));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('No movies found'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Nollywood',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    FlatButton(
                      child: Text(
                        'View All',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaidMoviess()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                child: FutureBuilder(
                  future: paidMovies(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PaidMoviesz>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, i) => Movie_Information(
                                id: snapshot.data[i].id,
                                title: snapshot.data[i].title,
                                poster: connect + snapshot.data[i].filmposter,
                                release_status: snapshot.data[i].duration,
                                movie: movie + snapshot.data[i].movie,
                                description: snapshot.data[i].overview,
                              ));
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: Text('No movies found'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         'TV shows',
              //         style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.red),
              //       ),
              //       FlatButton(
              //         child: Text(
              //           'View All',
              //           style: TextStyle(color: Colors.red),
              //         ),
              //         onPressed: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => PaidMovieszz()));
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   height: 280,
              //   child: FutureBuilder(
              //     future: seriesMovies(),
              //     builder: (BuildContext context,
              //         AsyncSnapshot<List<Series>> snapshot) {
              //       if (snapshot.hasData) {
              //         print('show kwanu');
              //         return ListView.builder(
              //             scrollDirection: Axis.horizontal,
              //             itemCount: snapshot.data.length,
              //             itemBuilder: (ctx, i) => SeriesInformation(
              //                   series_id: snapshot.data[i].id,
              //                   filmposter:
              //                       series + snapshot.data[i].filmposter,
              //                   title: snapshot.data[i].title,
              //                   overview: snapshot.data[i].overview,
              //                   trailer: tvtrailers +
              //                       slash +
              //                       snapshot.data[i].trailer,
              //                 ));
              //       } else if (snapshot.hasError) {
              //         print(snapshot.error);
              //         return Center(
              //           child: Text('No movies found'),
              //         );
              //       } else {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Movie_Information extends StatefulWidget {
  final id;
  final poster;
  final title;
  final movie;
  final description;
  // final trailer;
  final release_status;

  Movie_Information(
      {this.id,
      this.poster,
      this.title,
      this.description,
      // this.trailer,
      this.release_status,
      this.movie});

  @override
  _Movie_InformationState createState() => _Movie_InformationState();
}

class _Movie_InformationState extends State<Movie_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => DetailsScreen(
                  id: widget.id,
                  description: widget.description,
                  cover: widget.poster,
                  movie: widget.movie,
                  title: widget.title,
                )));
      },
      child: Container(
        child: Card(
          color: Colors.black,
          shadowColor: Colors.red,
          elevation: 7,
          borderOnForeground: true,
          child: Image(
            image: NetworkImage(widget.poster),
            height: 100,
          ),
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

  SeriesInformation(
      {this.series_id,
      this.title,
      this.filmposter,
      this.overview,
      this.trailer});

  @override
  _SeriesInformationState createState() => _SeriesInformationState();
}

class _SeriesInformationState extends State<SeriesInformation> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.title);
        print(widget.filmposter);
        print(widget.overview);
        print(widget.trailer);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SeriesDetails(
                      series_id: widget.series_id,
                      title: widget.title,
                      cover: widget.filmposter,
                      overview: widget.overview,
                      trailer: widget.trailer,
                    )));
      },
      child: Container(
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

class Premiere_Information extends StatefulWidget {
  final id;
  final covers;
  final title;
  final date;

  Premiere_Information({
    this.id,
    this.covers,
    this.title,
    this.date,
  });

  @override
  _Premiere_InformationState createState() => _Premiere_InformationState();
}

class _Premiere_InformationState extends State<Premiere_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => RecentDetailsScreenPaid(
                    //id is the same as slug
                    id: widget.id,

                    cover: widget.covers,
                    title: widget.title,
                  )),
        );
      },
      child: Card(
        color: Colors.black,
        shadowColor: Colors.red,
        elevation: 7,
        borderOnForeground: true,
        child: Image(
          image: NetworkImage(widget.covers),
          height: 100,
        ),
      ),
    );
  }
}
