import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niiflicks/view/screens/my_music_details.dart';
import 'song.dart';
import 'divider_widget.dart';

class CarouselStatic extends StatelessWidget {
  final String title;
  final List<Song> songs;
  final String cta;
  final dynamic onCtaTapped;
  final String music;

  CarouselStatic(
      {this.title, this.songs, this.cta, this.onCtaTapped, this.music});

  @override
  Widget build(BuildContext context) {
    // final List<Widget> songsItemWidget = songs
    //     .map((s) => CarouselStaticWidget(
    //           song: s,
    //         ))
    //     .toList();

    return Material(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                this.cta != null
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              this.onCtaTapped();
                            },
                            child: Text(
                              this.cta,
                              style: TextStyle(color: Colors.red),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )))
                    : Container()
              ],
            ),
          ),
          DividerWidget(
            margin: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
          ),
          Container(
            height: 260,
            child: CarouselStaticWidget(),
          )
        ],
      ),
    );
  }
}

class CarouselStaticWidget extends StatelessWidget {
  final Song song;
  String pics = 'assets/images/logo.png';
  String title = 'Watchu lookin for'.toUpperCase();
  String singer = 'MoonLight Afriqa';
  String musics = 'assets/wait.mp3';
  CarouselStaticWidget({this.song});

  @override
  Widget build(BuildContext context) {
    return Material(
        shadowColor: Colors.red,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => MyMusic(
                      picture: pics,
                      titles: title,
                      singer: singer,
                    )));
          },
          child: Container(
              child: Column(
            children: <Widget>[
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              pics,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )),
                      )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.red),
                        ),
                        Padding(padding: EdgeInsets.only(top: 4.0)),
                        Text(singer,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.red,
                  )
                ],
              )),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
              ),
              DividerWidget(
                margin: EdgeInsets.only(left: 50),
              )
            ],
          )),
        ));
  }
}
