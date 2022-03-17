import 'dart:convert';
import 'dart:io';

import 'package:livechatt/livechatt.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:niiflicks/classes/comment.dart';
import 'package:niiflicks/classes/get_views.dart';
import 'package:niiflicks/constant/color_const.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/view/screens/chats_screen.dart';
import 'package:niiflicks/view/screens/dashboard_screen.dart';
import 'package:niiflicks/view/screens/live_chat.dart';
import 'package:niiflicks/view/video/trailer.dart';
import 'package:niiflicks/view/video/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:video_player/video_player.dart';

import 'package:niiflicks/model/movie.dart';
import 'package:niiflicks/components/body.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  // final Movie movie;

  // const DetailsScreen({Key key, this.movie}) : super(key: key);
  final id;
  final cover;
  final title;
  final description;
  final movie;
  final status;

  DetailsScreen({
    this.id,
    this.cover,
    this.movie,
    this.title,
    this.status,
    this.description,
  });
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _commentController = TextEditingController();

  Future<List<Comments>> getComments() async {
    var url = 'https://niiflicks.com/niiflicks/apis/user/getcomments.php';
    var data = {'movieid': widget.id};
    final newUrl = Uri.parse(url).replace(queryParameters: data);
    var response = await http.get(newUrl);
    if (response.statusCode == 200) {
      return Comments.parseRecent(jsonDecode(response.body)['data']);
    } else {
      throw Exception('No data entered');
    }
  }

  var publicKey = 'pk_test_6698ce224b9e7ccb65dd708d4c143103f3b353ee';
  Future sendRatings() async {
    var ratings = 0;
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/addratings');
    var data = {'userid': user_id, 'movie_id': widget.id, 'ratings': ratings};
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print('success');
    } else {
      print('failure');
    }
  }

  final kInnerDecoration = BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: Colors.red),
    borderRadius: BorderRadius.circular(32),
  );
  Future getViews() async {
    var url = Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getviews');
    var data = {'movieid': widget.id};
    print(data);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print(response.body);
      return GetViews.fromJson(jsonDecode(response.body));
    } else {
      print('nothing came here');
    }
  }

  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);
  final token = TextEditingController();
  bool _isAuthenticating = false;
  bool visible = false;
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
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: token,
                  style: style,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabled: true,
                      contentPadding: EdgeInsets.all(20),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.red[900],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      hintText: "Token".toUpperCase(),
                      hintStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder()),
                )),
          ),
          SizedBox(
            height: 20,
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
            height: 20,
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
    var url = 'https://www.niiflicks.com/niiflicks/apis/movies/get_token.php';
    var user_mail = prefs.getString('regemail');
    var data = {'email': user_mail, 'mid': widget.id, 'tkn': tokens};
    final newUrl = Uri.parse(url);
    var response = await http.post(newUrl, body: data);
    var newresponse = jsonDecode(response.body)["error"];
    if (newresponse == false) {
      print(response.body);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                    movie: widget.movie,
                    movie_id: widget.id,
                    cover_movie: widget.cover,
                    movie_name: widget.title,
                  )));
    } else if (newresponse == true) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        title: 'Check e-mail properly, you have no valid token ',
        desc: 'Please Get Token',
        dialogBackgroundColor: Colors.yellow[50],
        btnOkOnPress: () {
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
    var movieid = widget.id;
    var moviename = widget.title;
    var url = 'https://www.niiflicks.com/single/${movieid}/${moviename}';
    launch(url);
  }

  Future addGetViews() async {
    var data = {'movieid': widget.id};
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

  @override
  void initState() {
    // AudioService.playMediaItem(item);

    getComments();
    super.initState();
    _controller = VideoPlayerController.network(widget.movie)
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
                        _showDialog();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => VideoPlayerScreen(
                        //           movie_name: widget.title,
                        //               movie: widget.movie,
                        //               cover_movie: widget.cover,
                        //               movie_id: widget.id,
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
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             VideoPlayerScreen(
                                  //               movie_name: widget.title,
                                  //               movie: widget.movie,
                                  //               cover_movie: widget.cover,
                                  //               movie_id: widget.id,
                                  //             )));
                                  print(widget.movie);
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
                              "Watch now".toUpperCase(),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overview'.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
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
                  Container(
                    height: 35,
                    child: Text(widget.description.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Muil',
                            fontWeight: FontWeight.bold)),
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
                        'Ratings :'.toUpperCase(),
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
                          sendRatings();
                        },
                      ),
                      SizedBox(
                        width: 10,
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
                width: 180,
                child: RaisedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => VideoPlayerScreen(
                    //               movie: widget.movie,
                    //               movie_id: widget.id,
                    //             )));
                    // setState(() {
                    //   press = !press;
                    // });
                    // _showDialog();
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.ini.niiflicks');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  color: Colors.red,
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

            SizedBox(
              height: 30,
            ),
          ]),
        ]),
      ]),
    );
  }
}
