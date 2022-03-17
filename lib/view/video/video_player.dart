import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:niiflicks/services/permission_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';

class VideoPlayerScreen extends StatefulWidget {
  final movie;
  final movie_name;
  final movie_id;
  final cover_movie;
  const VideoPlayerScreen(
      {Key key, this.movie, this.movie_name, this.movie_id, this.cover_movie})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.movie);
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
      looping: true,
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

  Future downloadFile(String url) async {
    bool permissionGranted =
        await PermissionService().requestAndroidStoragePermission();

    print("status: $permissionGranted");

    if (!permissionGranted) return;

    await _createFolder();
    final folderName = "Niiflicks";
    final dir = Directory("storage/emulated/0/$folderName");
    final taskId = await FlutterDownloader.enqueue(
      // saveInPublicStorage: true,
      fileName: "${widget.movie_name}.mp4",
      url: url,
      savedDir: dir.path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );

    String ext = widget.movie.substring(widget.movie.lastIndexOf('.'));

    final prefs = await SharedPreferences.getInstance();

    prefs.setString("savedMovieName", widget.movie_name);
    prefs.setString("savedMovieCoverImage", widget.cover_movie);
    prefs.setString("savedMoviePath",
        '/storage/emulated/0/$folderName/${widget.movie_name}$ext');
  }

  Future _createFolder() async {
    final folderName = "Niiflicks";
    final path = Directory("storage/emulated/0/$folderName");
    if ((await path.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      print("not exist");
      await path.create();
    }
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
          SizedBox(height: 20.0),
          ElevatedButton.icon(
            onPressed: () => downloadFile(widget.movie),
            icon: Icon(Icons.download, size: 18),
            label: Text("DOWNLOAD FOR OFFLINE"),
          ),
        ],
      ),
    );
  }
}
