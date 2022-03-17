import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NewVideoPlayer extends StatefulWidget {
  final File movie;
  const NewVideoPlayer({Key key, @required this.movie}) : super(key: key);

  @override
  _NewVideoPlayerState createState() => _NewVideoPlayerState();
}

class _NewVideoPlayerState extends State<NewVideoPlayer> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    print(widget.movie.existsSync());
    videoPlayerController = VideoPlayerController.file(widget.movie);
    initializeVideo();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  void initializeVideo() async {
    _initializeVideoPlayerFuture = videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(),
      appBar: _buildAppBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: BackButton(
        color: Colors.red,
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: Chewie(
                    controller: chewieController,
                  ),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          // AspectRatio(
          //   aspectRatio: videoPlayerController.value.aspectRatio,
          //   // Use the VideoPlayer widget to display the video.
          //   child: Chewie(
          //     controller: chewieController,
          //   ),
          // )
        ],
      ),
    );
  }
}
