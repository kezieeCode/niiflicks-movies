import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
class OfflineVideo extends StatefulWidget {
 
final savedMovie;
final savedPicture;
OfflineVideo({this.savedMovie,this.savedPicture});
  @override
  _OfflineVideoState createState() => _OfflineVideoState();
}


class _OfflineVideoState extends State<OfflineVideo> {
  @override
  VideoPlayerController _controller;
  ChewieController chewieController;
  void initState() {
    // final prefs = await SharedPreferences.getInstance();
    // var savedtrailer =  prefs.getString('seasonDownload');
    // TODO: implement initState
    super.initState();
     _controller = VideoPlayerController.network(
      widget.savedMovie,
      // 'http://t365.in:80/0537308174/5273230578/400216137.m3u8'
    );
    chewieController = ChewieController(
      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.red,
      ),
      optionsTranslation: OptionsTranslation(
          playbackSpeedButtonText: 'PB', subtitlesButtonText: 'English'),
      allowPlaybackSpeedChanging: true,
      showControlsOnInitialize: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        // DeviceOrientation.portraitDown,
        // DeviceOrientation.portraitUp
      ],
      allowFullScreen: true,
      allowMuting: true,
      showOptions: true,
      // optionsTranslation:OptionsTranslation(subtitlesButtonText: ),
      showControls: true,
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
    );
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
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
    body: Container(
      color: Colors.black,
      child: ListView(children: [
            SizedBox(
              height: 180,
            ),
            Container(height: 250, child: Chewie(controller: chewieController)),
          
            SizedBox(
              height: 30,
            ),
            
    
          ]),
    ),
    );
  }
}