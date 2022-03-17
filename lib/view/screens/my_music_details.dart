import 'dart:ui';

// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:volume_control/volume_control.dart';

class MyMusic extends StatefulWidget {
  final picture;
  final titles;
  final singer;
  MyMusic({this.picture, this.titles, this.singer});

  @override
  _MyMusicState createState() => _MyMusicState();
}

ScrollController _controller;
bool _available = true;
Future music() async {
  var url = Uri.parse('uri');
}

@override
class _MyMusicState extends State<MyMusic> {
  bool playing = false; // at the begining we are not playing any song
  bool looping = false;
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon
  IconData playRpt = Icons.repeat_on;
  //Now let's start by creating our music player
  //first let's declare some object
  AudioPlayer _player;
  // AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  //we will create a custom slider

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  void _playSound() async {
    // Set the new volume value, between 0-1
    VolumeControl.setVolume(1);
    _player = AudioPlayer();
    await _player
        .setUrl('https://niiflicks.com/niiflicks/apis/others/niiflicks.aac');
    await _player.setVolume(1.0);
    await _player.setLoopMode(LoopMode.one);
    _player.play();
  }

  // void _pause() async {
  //   // Set the new volume value, between 0-1
  //   VolumeControl.setVolume(1);
  //   _player = AudioPlayer();
  //   await _player
  //       .setUrl('https://niiflicks.com/niiflicks/apis/others/niiflicks.aac');
  //   await _player.setVolume(1.0);
  //   // await _player.setLoopMode(LoopMode.one);
  //   _player.pause();
  //   _player.dispose();
  // }

  //Now let's initialize our player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    // cache = AudioCache(fixedPlayer: _player);

    //now let's handle the audioplayer time

    //this function will allow you to get the music duration
    // _player.onDurationChanged.listen((Duration d) {
    //   setState(() {
    //     musicLength = d;
    //   });
    // });

    // _player.onAudioPositionChanged
    //     .listen((Duration p) => {setState(() => position = p)});
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            ctx: context,
            title: Text('My music'),
            icon: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              ),
            ),
            bgColor: Colors.black),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red[800],
                  Colors.red[200],
                ]),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 48.0,
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Let's add some text title
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      widget.singer,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      widget.titles,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  //Let's add the music cover
                  Center(
                    child: Container(
                      width: 280.0,
                      height: 280.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                            image: AssetImage(widget.picture),
                          )),
                    ),
                  ),

                  SizedBox(
                    height: 18.0,
                  ),

                  SizedBox(
                    height: 30.0,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Let's start by adding the controller
                          //let's add the time indicator text

                          // Container(
                          //   width: 500.0,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                          //         style: TextStyle(
                          //             fontSize: 18.0, color: Colors.red),
                          //       ),
                          //       slider(),
                          //       Text(
                          //         "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                          //         style: TextStyle(
                          //             fontSize: 18.0, color: Colors.red),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 45.0,
                                color: Colors.red,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.skip_previous,
                                ),
                              ),
                              IconButton(
                                iconSize: 62.0,
                                color: Colors.red[800],
                                onPressed: () {
                                  //here we will add the functionality of the play button
                                  if (!playing) {
                                    //now let's play the song
                                    // cache.play("what is it.mp3");
                                    _playSound();
                                    setState(() {
                                      playBtn = Icons.pause;
                                      playing = true;
                                    });
                                  } else if (playing) {
                                    _player.pause();
                                    setState(() {
                                      playBtn = Icons.stop;
                                      playing = false;
                                    });
                                  } else {
                                    return Icon(Icons.play_arrow);
                                  }
                                },
                                icon: Icon(
                                  playBtn,
                                ),
                              ),
                              IconButton(
                                  iconSize: 45.0,
                                  color: Colors.red,
                                  onPressed: () {
                                    if (!looping) {
                                      _player.setLoopMode(LoopMode.one);
                                      setState(() {
                                        playRpt = Icons.repeat_on_rounded;
                                        playing = true;
                                      });
                                    } else {
                                      setState(() {
                                        playRpt = Icons.repeat;
                                        playing = true;
                                      });
                                    }
                                  },
                                  icon: Icon(playRpt)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
