import 'dart:convert';
import 'dart:io';

import 'package:livechatt/livechatt.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:niiflicks/view/home/seasonal_details.dart';
import 'package:niiflicks/view/video/video_seasonal.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import 'package:niiflicks/view/video/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

class EpisodeDetails extends StatefulWidget {
  // final Movie movie;

  // const SeriesDetails({Key key, this.movie}) : super(key: key);
  final episode_id;
  final cover;
  final title;
  final season_id;
  final series_id;
  // final overview;
  // final trailer;
  // final status;

  EpisodeDetails(
      {this.episode_id,
      this.cover,
      // this.trailer,
      this.title,
      this.season_id,
      this.series_id
      // this.status,
      // this.overview,
      });
  @override
  _EpisodeDetailsState createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {
  final _commentController = TextEditingController();

  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);
  final token = TextEditingController();
  bool _isAuthenticating = false;
  bool visible = false;

  Future addGetViews() async {
    var data = {'movieid': widget.episode_id};
    var url = Uri.parse('https://niiflicks.com/niiflicks/apis/movies/addviews');
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print(response.body);
      print('you viewed this movie');
    } else {
      print(response.body);
      print('you did not view it');
    }
  }

  VideoPlayerController _controller;

  final _paystackPlugin = PaystackPlugin();
  bool press = true;
  final cols = Colors.transparent;
// var item = MediaItem(
//   id: 'assets/niiflicks.mp3',
//   album: 'Album name',
//   title: 'Track title',
// );
  Future seeMovie() async {
    var url =
        'https://www.niiflicks.com/niiflicks/apis/movies/get_one_episode.php';
    var data = {
      'series_id': widget.series_id,
      'season_id': widget.season_id,
      'episode_id': widget.episode_id
    };
    print(data);
  }

  @override
  void initState() {
    // AudioService.playMediaItem(item);

    super.initState();
    // _controller = VideoPlayerController.network(widget.movie)
    // ..initialize().then((_) {
    //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //   setState(() {});
    // });
  }

  @override
  void _showDialog() {
    if (visible == true) {
      setState(() {
        visible = true;
      });
    } else {
      setState(() {
        visible = false;
      });
    }
    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: ListView(children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Material(
                color: Colors.red[800],
                borderRadius: BorderRadius.circular(10),
                child: MaterialButton(
                  elevation: 7,
                  hoverElevation: 12.0,
                  height: 60,
                  child: Text("unlock".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: 20,
                      )),
                  onPressed: () {
                    _isAuthenticating = true;
                    checkToken();
                  },
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Material(
                color: Colors.red[800],
                borderRadius: BorderRadius.circular(10),
                child: MaterialButton(
                  elevation: 7,
                  hoverElevation: 12.0,
                  height: 60,
                  child: Text("get token".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: 20,
                      )),
                  onPressed: () {
                    _isAuthenticating = true;
                    getToken();
                  },
                )),
          ),
          Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )),
              )),
        ]),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.red,
      backgroundColor: Colors.black,
    );
  }

  Future checkToken() async {
    if (visible == false) {
      setState(() {
        visible = true;
      });
    } else {
      setState(() {
        visible = false;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    String tokens = token.text;
    var url =
        'https://www.niiflicks.com/niiflicks/apis/movies/get_token_series.php';
    var user_mail = prefs.getString('regemail');
    var data = {
      'email': user_mail,
      'series_id': widget.series_id,
      'season_id': widget.season_id,
      'episode_id': widget.episode_id,
      // 'tkn': tokens
    };
    final newUrl = Uri.parse(url);
    var response = await http.post(newUrl, body: data);
    var newresponse = jsonDecode(response.body)["error"];
    var seasons = 'https://niiflicks.com/producers/storage/tvseries/episodes/';
    if (newresponse == false) {
      print(response.body);
      var videoPath = jsonDecode(response.body)["path"];
      print(videoPath);
      print(data);
      // print(object)
      print(
        seasons + videoPath,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreens(
                    trailer: seasons + videoPath,
                    cover_picture: widget.cover,
                    episode_id: widget.episode_id,
                    title: widget.title,
                  )));
    } else if (newresponse == true) {
      print(response.body);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        title: 'Check e-mail properly,you have no valid token ',
        desc: 'Please Get Token',
        dialogBackgroundColor: Colors.yellow[50],
        btnOkOnPress: () {
          Navigator.pop(context);
          getToken();
        },
      )..show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        title: 'Server Downtime',
        desc: 'Cross your legs with some popcorn while we fix it',
        dialogBackgroundColor: Colors.yellow[50],
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      )..show();
    }
  }

  Future getToken() async {
    var movieid = widget.series_id;
    var moviename = widget.title;
    var url =
        'https://niiflicks.com/series_single/${widget.series_id}/${widget.season_id}/${widget.episode_id}/${widget.title}';
    launch(url);
  }

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
                    fit: BoxFit.cover,
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
                padding: EdgeInsets.only(top: 120),
                child: Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          seeMovie();
                          _showDialog();
                          // print(widget.trailer);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => VideoPlayerScreens(
                          //               trailer: widget.trailer,
                          //             )));
                        },
                        child: Column(
                          children: [
                            Stack(children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 25, right: 24),
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
                                    _showDialog();
                                    //       print(widget.trailer);
                                    //        Navigator.push(
                                    // context,
                                    // MaterialPageRoute(
                                    //     builder: (context) => VideoPlayerScreens(
                                    //           trailer: widget.trailer,
                                    //         )));
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
                                  top: 20, right: 30, left: 30),
                              child: Text(
                                "${widget.title}".toUpperCase(),
                                style: TextStyle(
                                    fontFamily: 'Muli',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                  ),
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
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       'Overview'.toUpperCase(),
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           color: Colors.red,
                            //           fontFamily: 'Muli'),
                            //       overflow: TextOverflow.ellipsis,
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ]),
              )
            ])
          ])
        ]));
  }
}
