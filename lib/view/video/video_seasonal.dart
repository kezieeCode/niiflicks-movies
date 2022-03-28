import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:dash_chat/dash_chat.dart';
import 'package:niiflicks/classes/new_releases.dart';
import 'package:niiflicks/classes/related.dart';
import 'package:niiflicks/classes/watch_list.dart';
import 'package:niiflicks/services/permission_service.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/screens/home.dart';
import 'package:chewie/chewie.dart';
import 'package:niiflicks/view/video/cast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:niiflicks/view/screens/dashboard_screen.dart';

class VideoPlayerScreens extends StatefulWidget {
  final trailer;
  final cover_picture;
  final series_id;
  final season_id;
  final episode_id;
  final title;

  // ChromeCastController _controller;
  VideoPlayerScreens({
    this.trailer,
    this.season_id,
    this.series_id,
    this.episode_id,
    this.cover_picture,
    this.title,
  });
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreens> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.trailer);
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
    // final taskId = await FlutterDownloader.enqueue(
    //   // saveInPublicStorage: true,
    //   fileName: "${widget.title}.mp4",
    //   url: url,
    //   savedDir: dir.path,
    //   showNotification:
    //       true, // show download progress in status bar (for Android)
    //   openFileFromNotification:
    //       true, // click on notification to open downloaded file (for Android)
    // );

    String ext = widget.trailer.substring(widget.trailer.lastIndexOf('.'));

    final prefs = await SharedPreferences.getInstance();

    prefs.setString("savedEpisodeName", widget.title);
    prefs.setString("savedEpisodeCoverImage", widget.cover_picture);
    prefs.setString("savedEpisodePath",
        '/storage/emulated/0/$folderName/${widget.title}$ext');
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
            onPressed: () => downloadFile(widget.trailer),
            icon: Icon(Icons.download, size: 18),
            label: Text("DOWNLOAD FOR OFFLINE"),
          ),
        ],
      ),
    );
  }
}
