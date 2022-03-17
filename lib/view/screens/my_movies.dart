import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:niiflicks/classes/new_movies.dart';
import 'package:niiflicks/classes/new_releases.dart';
import 'package:niiflicks/classes/popular.dart';
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/classes/recent_detail.dart';
import 'package:niiflicks/classes/trending.dart';
import 'package:niiflicks/classes/watch_list.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/constant/string_const.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';

import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/home/nav_drawer.dart';
import 'package:niiflicks/view/home/recent_detail.dart';
import 'package:niiflicks/view/home/seeries_season.dart';
import 'package:niiflicks/view/screens/search.dart';

import 'package:niiflicks/view/setting/settings_screen.dart';
import 'package:niiflicks/view/viewAll/action_my_movies.dart';
import 'package:niiflicks/view/viewAll/actorPage.dart';
import 'package:niiflicks/view/viewAll/adventure_my_movies.dart';
import 'package:niiflicks/view/viewAll/all_series.dart';
import 'package:niiflicks/view/viewAll/niiflicks_premieres.dart';
// import 'package:niiflicks/view/viewAll/newReleasesPage.dart';
// import 'package:niiflicks/view/viewAll/popularPage.dart';
import 'package:niiflicks/view/viewAll/recent_page.dart';
import 'package:niiflicks/view/viewAll/recommended-series.dart';
import 'package:niiflicks/view/viewAll/romance_my_movies.dart';
// import 'package:niiflicks/view/viewAll/trendingPage.dart';
import 'package:niiflicks/view/widget/ReleaseRow.dart';
import 'package:niiflicks/view/widget/actorsRow.dart';

import 'package:niiflicks/view/widget/popularRow.dart';
// import 'package:niiflicks/view/widget/trendingRow.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:volume_control/volume_control.dart';
import 'package:carousel_pro/carousel_pro.dart';

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);
GlobalKey keyButton = GlobalKey();
GlobalKey keyButton1 = GlobalKey();
GlobalKey keyButton2 = GlobalKey();
GlobalKey keyButton3 = GlobalKey();
GlobalKey keyButton4 = GlobalKey();
GlobalKey keyButton5 = GlobalKey();

class MyMovies extends StatefulWidget {
  final thumbnails;
  final id;
  final titles;
  final overviews;
  final budgets;
  final durations;
  final image;
  final play_movies;
  MyMovies(
      {this.thumbnails,
      this.titles,
      this.id,
      this.overviews,
      this.budgets,
      this.durations,
      this.image,
      this.play_movies});
  @override
  _MyMoviesState createState() => _MyMoviesState();
// }
// class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: MyMovies(),
    );
  }
}

class _MyMoviesState extends State<MyMovies> {
  @override
  void initState() {
    super.initState();
    getwatchLater();
    releases();
    // movieList();
    popular();

    _checkUpdate();
    moviesRecent();

    // _playSound();
  }

  void _checkUpdate() async {}

  @override
  @override
  Future getwatchLater() async {
    BuildContext _context;
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    print(user_id);

    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getwatchlist');
    var data = {
      'userid': user_id,
    };

    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      return GetWatchlist.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
    }
  }

  Future<List<Releases>> releases() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/newreleases');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return Releases.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future romance() async {
    var uri = Uri.parse('https://universal-studios1.p.rapidapi.com/search.php');
    final data = {'keyword': 'romance'};
    final newUrl = uri.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    if (response.statusCode == 200) {
      print(response.body);
      print('action cameout');
      return Recent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      print('theres no action');
      throw Exception('No data to display');
    }
  }

  Future action() async {
    var uri = Uri.parse('https://universal-studios1.p.rapidapi.com/search.php');
    final data = {'keyword': 'action'};
    final newUrl = uri.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    if (response.statusCode == 200) {
      print(response.body);
      print('action cameout');
      return Recent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      print('theres no action');
      throw Exception('No data to display');
    }
  }

  Future adventure() async {
    var uri = Uri.parse('https://universal-studios1.p.rapidapi.com/search.php');
    var data = {"keyword": "adventure"};
    final newUrl = uri.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    if (response.statusCode == 200) {
      print(response.body);
      print('theres adventure');
      return Recent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      print('theres no adventure');
      throw Exception('No data to display');
    }
  }

  // ignore: missing_return
  Future moviesRecent() async {
    Uri url = Uri.parse('https://imdb-api.com/API/MostPopularTVs');
    String apkey = 'k_kyr1vihh';
    var data = {'apiKey': apkey};
    final newUrl = url.replace(queryParameters: data);
    var response = await http.get(newUrl);
    if (response.statusCode == 200) {
      print(response.body);

      return NewMovies.parseRecent(jsonDecode(response.body)['items']);
    } else {
      print('it didnt go through');
      throw Exception('No data to display');
    }
  }

  Future movieLists() async {
    var uri = 'https://universal-studios1.p.rapidapi.com/movies.php';

    var response = await http.get(Uri.parse(uri), headers: {
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

  Future niiflicksSeries() async {
    var uri = 'https://universal-studios1.p.rapidapi.com/series.php';

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

  Future recommendedSeries() async {
    var uri =
        'https://universal-studios1.p.rapidapi.com/recommended-series.php';

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

  Future<List<Popular>> popular() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getpopular');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return Popular.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  AudioPlayer player;
  void _playSound() async {
    // Set the new volume value, between 0-1
    VolumeControl.setVolume(1);
    player = AudioPlayer();
    await player.setAsset('assets/images/niiflicks.mp3');
    // await player.setVolume(1.0);
    await player.setLoopMode(LoopMode.off);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    var homeIcon = IconButton(
        icon: Image.asset(
          'assets/images/logo.png',
          height: 20,
        ),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        });
    return Material(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                icon: Icon(Icons.search))
          ],
          backgroundColor: Colors.black,
          title: Text(
            'Movies and tv shows'.toUpperCase(),
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
        ),
        body: Container(
          color: Colors.black,
          // bgbgColor: ColorConst.WHITE_BG_COLOR,
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'New Releases',
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
                                  builder: (context) => RecentMovies()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 280,
                  child: FutureBuilder(
                    future: movieLists(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, i) => Movie_Information(
                                  id: snapshot.data[i].slug,
                                  title: snapshot.data[i].title,
                                  covers: snapshot.data[i].thumbnail,
                                  date: snapshot.data[i].date,
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
                        'Series',
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
                                  builder: (context) => AllSeries()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 280,
                  child: FutureBuilder(
                    future: niiflicksSeries(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, i) => Seasonal_Information(
                                  id: snapshot.data[i].slug,
                                  title: snapshot.data[i].title,
                                  covers: snapshot.data[i].thumbnail,
                                  date: snapshot.data[i].date,
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
                        'Recommended Series',
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
                                  builder: (context) => RecommendedSeries()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 280,
                  child: FutureBuilder(
                    future: recommendedSeries(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, i) => Seasonal_Information(
                                  id: snapshot.data[i].slug,
                                  title: snapshot.data[i].title,
                                  covers: snapshot.data[i].thumbnail,
                                  date: snapshot.data[i].date,
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
                        'Romance',
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
                                  builder: (context) => Romance()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 280,
                  child: FutureBuilder(
                    future: romance(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, i) => Movie_Information(
                                  id: snapshot.data[i].slug,
                                  title: snapshot.data[i].title,
                                  covers: snapshot.data[i].thumbnail,
                                  date: snapshot.data[i].date,
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
                        'Action',
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
                                  builder: (context) => ActionMyMovies()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 280,
                  child: FutureBuilder(
                    future: action(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, i) => Movie_Information(
                                  id: snapshot.data[i].slug,
                                  title: snapshot.data[i].title,
                                  covers: snapshot.data[i].thumbnail,
                                  date: snapshot.data[i].date,
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
                        'Adventure',
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
                                  builder: (context) => AdventureMovies()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 280,
                  child: FutureBuilder(
                    future: adventure(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, i) => Movie_Information(
                                  id: snapshot.data[i].slug,
                                  title: snapshot.data[i].title,
                                  covers: snapshot.data[i].thumbnail,
                                  date: snapshot.data[i].date,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Movie_Information extends StatefulWidget {
  final id;
  final covers;
  final title;
  final date;

  Movie_Information({
    this.id,
    this.covers,
    this.title,
    this.date,
  });

  @override
  _Movie_InformationState createState() => _Movie_InformationState();
}

class _Movie_InformationState extends State<Movie_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => RecentDetailsScreen(
                    //id is the same as slug
                    id: widget.id,
                    date_produced: widget.date,
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

class Seasonal_Information extends StatefulWidget {
  final id;
  final covers;
  final title;
  final date;

  Seasonal_Information({
    this.id,
    this.covers,
    this.title,
    this.date,
  });

  @override
  _Seasonal_InformationState createState() => _Seasonal_InformationState();
}

class _Seasonal_InformationState extends State<Seasonal_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => SeriesSeason(
                    //id is the same as slug
                    id: widget.id,
                    date_produced: widget.date,
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
