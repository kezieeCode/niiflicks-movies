import 'dart:convert' as convert;
import 'dart:io';

import 'package:livechatt/livechatt.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:niiflicks/classes/latest.dart';
import 'package:niiflicks/classes/movie_details.dart';
import 'package:niiflicks/view/home/recent_detail.dart';

import 'package:niiflicks/view/video/video_apis.dart';
import 'package:niiflicks/view/video/video_player.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:niiflicks/view/viewAll/all_seasons.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:startapp/startapp.dart';
import 'package:video_player/video_player.dart';
import 'package:niiflicks/classes/movie_details.dart';
import 'package:niiflicks/model/movie.dart';
import 'package:niiflicks/components/body.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class SeriesSeason extends StatefulWidget {
  // final Movie movie;

  // const SeriesSeason({Key key, this.movie}) : super(key: key);
  final id;
  final date_produced;
  final cover;
  final title;

  SeriesSeason({
    this.id,
    this.cover,
    this.date_produced,
    this.title,
  });
  @override
  _SeriesSeasonState createState() => _SeriesSeasonState();
}

class _SeriesSeasonState extends State<SeriesSeason> {
  var publicKey = 'pk_test_6698ce224b9e7ccb65dd708d4c143103f3b353ee';
  Future<Map<String, dynamic>> _value;
  List<LatestReleases> latestReleases = [];
  Future<Map<String, dynamic>> movieDetails() async {
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    var vid_id = widget.id;
    var data = {'slug': vid_id};
    print(data);
    var url = Uri.parse('https://universal-studios1.p.rapidapi.com/movie.php');
    final newUrl = url.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    print('response:${response.statusCode}');
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      throw Text('error data ',
          style: TextStyle(
            color: Colors.white,
          ));
    }
  }

  Future<List<LatestReleases>> getEpisodes() async {
    var vid_id = widget.id;
    var data = {'slug': vid_id};
    print(data);
    var url = Uri.parse('https://universal-studios1.p.rapidapi.com/movie.php');
    final newUrl = url.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    print('response:${response.statusCode}');
    if (response.statusCode == 200) {
      var returnedData = convert.json.decode(response.body);
      var datass = returnedData['data']['episodes'];
      datass.forEach((element) {
        latestReleases.add(LatestReleases.fromJson(element));
      });

      print("latest releases: ${datass}");
      return latestReleases;
    } else {
      throw Text('error data ',
          style: TextStyle(
            color: Colors.white,
          ));
    }
  }

  final _commentController = TextEditingController();
  Future addComments() async {
    String comments = _commentController.text;
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    print(user_id);
    print(widget.id);
    print(comments);
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/user/addcomments');
    var data = {'comment': comments, 'userid': user_id, 'movieid': widget.id};
    final newUrl = url.replace(queryParameters: data);
    var response = await http.post(newUrl);
    if (response.statusCode == 200) {
    } else {}
  }

  // Future getComments() async {
  //   var url = 'https://niiflicks.com/niiflicks/apis/user/getcomments.php';
  //   var data = {
  //     'movieid':
  //   };
  // }

  final kInnerDecoration = BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: Colors.red),
    borderRadius: BorderRadius.circular(32),
  );

  // Future addGetViews() async {
  //   var data = {'movieid': widget.id};
  //   var url = Uri.parse('https://niiflicks.com/niiflicks/apis/movies/addviews');
  //   var response = await http.post(url, body: data);
  //   if (response.statusCode == 200) {
  //
  //     print('you viewed this movie');
  //   } else {
  //
  //     print('you did not view it');
  //   }
  // }

  VideoPlayerController _controller;

  final _paystackPlugin = PaystackPlugin();
  bool press = true;
  bool _available = false;
  final cols = Colors.transparent;
// var item = MediaItem(
//   id: 'assets/niiflicks.mp3',
//   album: 'Album name',
//   title: 'Track title',
// );
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // RewardedAd rewardedAd;
  // InterstitialAd interstitialAd;
  @override
  void initState() {
    // _createRewardedAd();
    // AudioService.playMediaItem(item);
    movieDetails();
    getEpisodes();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
    _controller = VideoPlayerController.network(widget.title)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  int count;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(children: [
        Stack(children: [
          ClipPath(
            child: ClipRRect(
              child: CachedNetworkImage(
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black54,
                  filterQuality: FilterQuality.high,
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: widget.cover,
                  errorWidget: (context, url, error) => Container()),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Container(
              height: 250,
              child: FutureBuilder(
                future: movieDetails(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(top: 120),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            // StartApp.showInterstitialAd();
                          },
                          child: Column(
                            children: [
                              Stack(children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(bottom: 25, right: 24),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red[300],
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0),
                                        BoxShadow(
                                            color: Colors.red[200],
                                            offset: Offset(-4.0, -4.0),
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0),
                                      ],
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.red[700],
                                            Colors.red[600],
                                            Colors.red[500],
                                            Colors.red[200],
                                          ],
                                          stops: [
                                            0,
                                            0.1,
                                            0.3,
                                            1
                                          ])),
                                  child: IconButton(
                                    onPressed: () {
                                      //  StartApp.showInterstitialAd();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                            'Watch Ads to access Free Content'),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 20),
                                        action: SnackBarAction(
                                          label: '',
                                          onPressed: () {},
                                        ),
                                      ));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerScreenApi(
                                                      movie_stream: _available
                                                          ? 'N/A'
                                                          : '${snapshot.data['data']['stream_link']}')));
                                      print('is it available?');
                                      var newLoop =
                                          snapshot.data['data']['stream_link'];
                                      print(newLoop);

                                      // print(snapshot.data['data']);
                                    },
                                    icon: Icon(
                                      Icons.play_circle_outlined,
                                      color: Colors.red[900],
                                      size: 55,
                                    ),
                                  ),
                                ),
                              ]),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 10, left: 10),
                                child: Text(
                                  "Watch movies".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            SizedBox(
              height: 160,
            ),
            // VideoPlayerScreen(controller:),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Synopsis',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                  fontFamily: 'Muli'),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FutureBuilder(
                      future: movieDetails(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Container();
                        } else if (snapshot.hasData) {
                          return Container(
                            height: 35,
                            child: Text('${snapshot.data['data']['synopsis']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Muil',
                                    fontWeight: FontWeight.bold)),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                  Text(
                    'Movie title',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                        fontFamily: 'Muli'),
                    overflow: TextOverflow.ellipsis,
                  ),
                  FutureBuilder(
                    future: movieDetails(),
                    builder: (
                      context,
                      AsyncSnapshot snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Center(child: Container());
                      } else if (snapshot.hasData) {
                        print("data sent: ${snapshot.data['slug']}");
                        return Container(
                          height: 35,
                          child: Text(widget.title,
                              // _available
                              //     ? '${snapshot.data['data'][0]['description']}'
                              //     : 'N/A',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Muil',
                                  fontWeight: FontWeight.bold)),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, bottom: 10),
              child: Container(
                width: 410,
                height: 60,
                child: Card(
                  elevation: 7,
                  shadowColor: Colors.red,
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                      ),
                      Text(
                        'Ratings :',
                        style: TextStyle(color: Colors.red),
                      ),
                      RatingBar.builder(
                        initialRating: 1,
                        minRating: 1,
                        glowColor: Colors.red,
                        itemSize: 30,
                        glow: true,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // sendRatings();
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Container(
                // decoration: kInnerDecoration,
                height: 50,
                width: 120,
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      press = !press;
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.thumb_down,
                        color: Colors.white,
                      ),
                      Text(
                        'Inapropriate',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  color: press ? Colors.red : cols,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.red,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ]),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 280,
          child: FutureBuilder(
            future: getEpisodes(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, i) => Movie_Information(
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
      ]),
    );
  }
}

class Movie_Information extends StatefulWidget {
  final id;
  final covers;
  final title;

  Movie_Information({
    this.id,
    this.covers,
    this.title,
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

                      cover: widget.covers,
                      title: widget.title,
                    )),
          );
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  child: Card(
                    color: Colors.black,
                    shadowColor: Colors.red,
                    elevation: 8,
                    borderOnForeground: true,
                    child: Image(
                      image: NetworkImage(widget.covers),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 120,
              child: Text(
                widget.title,
                overflow: TextOverflow.clip,
                maxLines: 3,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }
}
