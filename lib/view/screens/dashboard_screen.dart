import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:new_version/new_version.dart';
import 'package:niiflicks/classes/new_releases.dart';
import 'package:niiflicks/classes/popular.dart';
import 'package:niiflicks/classes/recent.dart';

import 'package:niiflicks/classes/trending.dart';
import 'package:niiflicks/classes/watch_list.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/constant/string_const.dart';
import 'package:niiflicks/models/movie.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';

import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/home/login.dart';
import 'package:niiflicks/view/home/nav_drawer.dart';
import 'package:niiflicks/view/home/recent_detail.dart';
import 'package:niiflicks/view/musics/browse_widget.dart';
import 'package:niiflicks/view/screens/live_tv_dash.dart';
import 'package:niiflicks/view/screens/my_movies.dart';
import 'package:niiflicks/view/screens/offline_downloads.dart';
import 'package:niiflicks/view/screens/paid_movies.dart';

import 'package:niiflicks/view/setting/settings_screen.dart';
import 'package:niiflicks/view/subscription/subscription_if_expired.dart';
import 'package:niiflicks/view/viewAll/actorPage.dart';

import 'package:niiflicks/view/viewAll/trends.dart';

import 'package:niiflicks/view/widget/ReleaseRow.dart';
import 'package:niiflicks/view/subscription/subscription1.dart';
import 'package:niiflicks/view/widget/actorsRow.dart';

import 'package:niiflicks/view/widget/popularRow.dart';

import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:volume_control/volume_control.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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

class DashboardScreen extends StatefulWidget {
  final thumbnails;
  final id;
  final titles;
  final overviews;
  final budgets;
  final durations;
  final image;
  final play_movies;
  DashboardScreen(
      {this.thumbnails,
      this.titles,
      this.id,
      this.overviews,
      this.budgets,
      this.durations,
      this.image,
      this.play_movies});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
// }
// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: DashboardScreen(),
    );
  }
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer timer;
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer.cancel();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    // whoConnectects();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    releases();
    _playSound();
    zoomBackwards();
  }

  @override
  @override
  void dispose() {
    // TODO: implement dispose
    //
    super.dispose();
  }

  void logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged');
    await Future.delayed(Duration(seconds: 2));

    // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    navigationPush(context, Login());
  }

  String message = 'Check your network connection';
  @override
  List<Recent> recent = [];
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
  double _height = 0;
  zoomBackwards() {
    setState(() {
      _height = 280;
    });
  }

  Future getwatchLater() async {
    BuildContext _context;
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    print(user_id);
    // print(widget.movie_id);
    // print(widget.movie);

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

  Future<List<GetWatchlist>> watchLater() async {
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    print(user_id);
    var data = {"userid": user_id};

    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getwatchlist');
    // final newUri = url.replace(queryParameters: data);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print(response.body);
      return GetWatchlist.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  List _options = [];
  Future<List<Releases>> releases() async {
    var url = Uri.parse(
        'https://niiflicks.com/niiflicks/apis/movies/newreleases.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('for new releases');
      print(response.body);
      return Releases.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future movieList() async {
    var uri = "https://universal-studios1.p.rapidapi.com/cinema-movies.php";

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

  Future<List<Recent>> moviesList() async {
    var uri = 'https://universal-studios1.p.rapidapi.com/cinema-movies.php';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    if (response.statusCode == 200) {
      print('check api subscription');
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

  Future<Null> _refresh() {
    return movieList().then((_user) {
      setState(() => recent = _user);
    });
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

  bool _available = false;
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
        // key: _scaffoldKey,
        // drawer: NavDrawer(),
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text(
            'Niiflicks',
            style: TextStyle(
                color: Colors.red,
                fontSize: 27,
                fontWeight: FontWeight.bold,
                fontFamily: 'GoudyHvyface BT'),
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                logoutUser();
              },
              child: Image.asset(
                'assets/images/logo.png',
                height: 35,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.black,
            // bgbgColor: ColorConst.WHITE_BG_COLOR,
            child: Center(
              child: ListView(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('See an Ad to watch any content'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 5),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {},
                        ),
                      ));

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyMovies()));
                    },
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.dstATop,
                            ),
                            image: AssetImage('assets/images/collage.jpg')),
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 20.0),
                        ],
                        border: Border.all(
                          color: Colors.red[600],
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Free movies and Tv Shows'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaidMovies()));
                    },
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.dstATop,
                            ),
                            image: AssetImage('assets/images/paid.jpg')),
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 20.0),
                        ],
                        border: Border.all(
                          color: Colors.red[600],
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Niiflicks Premium'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LiveTVDash()));
                    },
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.dstATop,
                            ),
                            image: AssetImage('assets/images/LS.jpg')),
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 20.0),
                        ],
                        border: Border.all(
                          color: Colors.red[600],
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'free sports'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BrowseWidget()));
                    },
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.dstATop,
                            ),
                            image: AssetImage('assets/images/LIVE.jpg')),
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 20.0),
                        ],
                        border: Border.all(
                          color: Colors.red[600],
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Free music'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()));
                    },
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.dstATop,
                            ),
                            image: AssetImage('assets/images/SETTINGS.jpg')),
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 20.0),
                        ],
                        border: Border.all(
                          color: Colors.red[600],
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Settings'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfflineDownloads()));
                    },
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.dstATop,
                            ),
                            image: AssetImage('assets/images/downs.png')),
                        boxShadow: [
                          BoxShadow(color: Colors.red, blurRadius: 20.0),
                        ],
                        border: Border.all(
                          color: Colors.red[600],
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'View offline downloads'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Future<void> getData() async {
//   var uri = 'https://simplemovie.p.rapidapi.com/movie/list/recent';

//   var response = await http.get(Uri.parse(uri), headers: {
//     'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
//   });
//   var convert = jsonDecode(response.body)['data'];
//   convert = Recent.parseRecent(convert);
// }
