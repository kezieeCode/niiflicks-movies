import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:dash_chat/dash_chat.dart';
import 'package:niiflicks/classes/new_releases.dart';
import 'package:niiflicks/classes/related.dart';
import 'package:niiflicks/classes/watch_list.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/screens/home.dart';

import 'package:niiflicks/view/video/cast.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:niiflicks/view/screens/dashboard_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(VideoPlayerScreenApi());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreenApi(),
    );
  }
}

class VideoPlayerScreenApi extends StatefulWidget {
  final movie;
  final movie_stream;

  // ChromeCastController _controller;

  VideoPlayerScreenApi({this.movie, this.movie_stream});
  @override
  _VideoPlayerScreenApiState createState() => _VideoPlayerScreenApiState();
}

class _VideoPlayerScreenApiState extends State<VideoPlayerScreenApi> {
  // ChromeCastController _controller1;
  final _commentController = TextEditingController();

  void playBack() async {
    preference = await SharedPreferences.getInstance();
    String hasPlayBack = preference.getString('play-resume');
    if (hasPlayBack == null) {
      _controller.setLooping(true);
      print('nothing was paused');
    } else {
      print('payed back');
      Duration position = parseDuration(hasPlayBack);
      _controller.seekTo(position);
      _controller.setLooping(true);
    }
  }

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  SharedPreferences preference;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    playBack();
    _controller = VideoPlayerController.network(
      // 'https://gomo.to/movie/charlotte-moon-mysteries-green-on-the-greens'
      widget.movie,
    );
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.

    super.initState();
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  Future<bool> _setPlayResumeDurtion() async {
    if (_controller.position != _controller.value.duration) {
      // set the resume playback duration as the current position

      await preference.setString(
          "play-resume", _controller.position.toString());

      return true;
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _setPlayResumeDurtion,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            // ChromeCastButton(
            //   onButtonCreated: (controller) {
            //     setState(() => _controller1 = controller);
            //     _controller1?.addSessionListener();
            //   },
            //   onSessionStarted: () {
            //     _controller1?.loadMedia(widget.movie);
            //   },
            // )
            //   IconButton(
            //       onPressed: () {
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context) => MusicHomepage()));
            //       },
            //       icon: Icon(
            //         Icons.cast_connected,
            //         color: Colors.red,
            //       ))
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            },
          ),
        ),
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        body: Container(
          color: Colors.black,
          child: WebView(
            initialUrl: widget.movie_stream,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              // _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith(widget.movie_stream)) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.prevent;
            },
          ),
        ),
      ),
    );
  }
}
