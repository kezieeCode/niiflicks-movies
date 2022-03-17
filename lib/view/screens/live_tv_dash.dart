import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:niiflicks/classes/live_tv.dart';
import 'package:niiflicks/classes/live_channels.dart';
import 'package:niiflicks/classes/live_tvs_recent_.dart';

// import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:niiflicks/view/viewAll/liveTv.dart';
import 'package:niiflicks/view/viewAll/live_channels.dart';
import 'package:niiflicks/view/viewAll/liveTvRecent.dart';
import 'package:niiflicks/view/home/nav_drawer.dart';
// import 'package:niiflicks/view/search/search_screen.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:niiflicks/view/video/web_game.dart';
import 'package:niiflicks/view/video/youtube_player.dart';
import 'package:url_launcher/url_launcher.dart';

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
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

class LiveTVDash extends StatefulWidget {
  final movie_id;
  final movie_title;
  final movie_link;
  final movie_image;

  LiveTVDash(
      {this.movie_id, this.movie_title, this.movie_link, this.movie_image});
  @override
  _LiveTVDashState createState() => _LiveTVDashState();
// }
// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: LiveTVDash(),
    );
  }
}

class _LiveTVDashState extends State<LiveTVDash> {
  @override
  void initState() {
    super.initState();
    // whoConnectects();
    liveTv();
    liveTvsRecent();
    liveChannels();

    _checkUpdate();
  }

  void _checkUpdate() async {}
  String message = 'Check your network conection';
  @override
  @override
  Future<List<LiveTvs>> liveTv() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/livetv.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('for live tv');
      print(response.body);
      return LiveTvs.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future<List<LiveTvRecent>> liveTvsRecent() async {
    var url = Uri.parse(
        'https://niiflicks.com/niiflicks/apis/movies/livetvrecent.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('for live tv');
      print(response.body);
      return LiveTvRecent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future<List<LiveChannel>> liveChannels() async {
    var url = Uri.parse(
        'https://niiflicks.com/niiflicks/apis/movies/livechannel.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('for live channels');
      print(response.body);
      return LiveChannel.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future<Null> _refresh() {
    // return movieList().then((_user) {
    //   setState(() => movieList = _user);
    // });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  AudioPlayer player;

  bool _available = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _scaffoldKey,

        // extendBodyBehindAppBar: true,
        appBar: getAppBarWithBackBtn(
            bgColor: Colors.black,
            ctx: context,
            title: Text(
              'LIVE TVs'.toUpperCase(),
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () => null,
                icon: Icon(
                  Icons.live_tv,
                  color: Colors.red,
                ),
              )
            ],
            icon: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              ),
            )),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: Container(
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
                          'Live Games',
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
                                    builder: (context) => liveTvPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 220,
                    child: FutureBuilder(
                      future: liveTv(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (ctx, i) => Movie_Information(
                                    movie_id: snapshot.data[i].id,
                                    movie_link: snapshot.data[i].link,
                                    movie_title: snapshot.data[i].name,
                                    movie_image: snapshot.data[i].image,
                                    movie_youtube: snapshot.data[i].youtube,
                                  ));
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(message),
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
                          'Recent Games',
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
                                    builder: (context) => liveTvRecentPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    child: FutureBuilder(
                      future: liveTvsRecent(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (ctx, i) => Movie_Information(
                                    movie_id: snapshot.data[i].id,
                                    movie_link: snapshot.data[i].link,
                                    movie_title: snapshot.data[i].name,
                                    movie_image: snapshot.data[i].image,
                                    movie_youtube: snapshot.data[i].youtube,
                                  ));
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(message),
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
      ),
    );
  }
}

class Movie_Information extends StatelessWidget {
  final movie_id;
  final movie_title;
  final movie_link;
  final movie_image;
  final movie_youtube;

  Movie_Information(
      {this.movie_id,
      this.movie_title,
      this.movie_link,
      this.movie_image,
      this.movie_youtube});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launch(movie_link);
      },
      child: Container(
        height: 50,
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
            child: Container(
              width: 200,
              color: Colors.grey[600],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 175),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 30,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        'Football',
                        style: TextStyle(color: Colors.black),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      movie_title,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Stack(
                    children: [(Image.asset(
                      'assets/images/television.jpeg',
                    ))],
                  )
                ],
              ),
            )
            // Image.network(
            //   movie_image,
            //   fit: BoxFit.fill,
            // )
            ),
      ),
    );
  }
}
