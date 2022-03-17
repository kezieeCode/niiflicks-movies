// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeLive extends StatefulWidget {
  // const YouTubeLive({Key key}) : super(key: key);
  final stream;
  YouTubeLive({this.stream});

  @override
  _YouTubeLiveState createState() => _YouTubeLiveState();
}

class _YouTubeLiveState extends State<YouTubeLive> {
  bool _isPlayerReady = false;
  YoutubeMetaData _videoMetaData;
  PlayerState _playerState;
  YoutubePlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(widget.stream);
    print(videoId);
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        isLive: true,
        hideControls: false,
        hideThumbnail: false,
        forceHD: true,
        autoPlay: true,
        mute: false,
      ),
    )..addListener(listener);
    // liveTv();
    // liveTvRecent();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(children: [
        SizedBox(
          height: 180,
        ),
        Container(
          height: 250,
          child: YoutubePlayer(
            controller: _controller,
          ),
        )
      ]),
    );
  }
}
