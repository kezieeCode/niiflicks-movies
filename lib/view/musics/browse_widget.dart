import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/view/musics/carousel_static.dart';
import 'package:niiflicks/view/musics/search_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'musicservice.dart';
import 'carousel_song_widget.dart';
import 'carousel_album.dart';
import 'album_widget.dart';
import 'home.dart';

class BrowseWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrowseWidgetState();
  }
}

class _BrowseWidgetState extends State<BrowseWidget> {
  final musicStore = AppleMusicStore.instance;
  Future<Home> _home;

  @override
  void initState() {
    super.initState();
    _home = musicStore.fetchBrowseHome();
  }

  var android = Platform.isAndroid;

  var ios = Platform.isIOS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              )),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.red,
                ),
                onPressed: () => navigationPush(context, SearchWidget()))
          ],
          title: Text(
            'My Music',
            style: TextStyle(
                color: Colors.red,
                fontSize: 27,
                fontFamily: 'Montserrat-Regular'),
          ),
        ),
        body: FutureBuilder<Home>(
          future: _home,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final albumChart = snapshot.data.chart.albumChart;

              final List<Widget> list = [];

              if (albumChart != null) {
                list.add(CarouselStatic(
                  title: 'MoonLight Afriqa',
                ));
                list.add(Padding(
                  padding: EdgeInsets.only(top: 16),
                ));
                list.add(CarouselAlbumWidget(
                  title: "Top Albums",
                  albums: albumChart.albums,
                ));
              }

              final songChart = snapshot.data.chart.songChart;

              if (songChart != null) {
                list.add(Padding(
                  padding: EdgeInsets.only(top: 16),
                ));
                list.add(CarouselSongWidget(
                  title: "Top Songs",
                  songs: songChart.songs,
                  cta: 'Swipe right',
                ));
              }

              snapshot.data.albums.forEach((f) {
                list.add(Padding(
                  padding: EdgeInsets.only(top: 16),
                ));
                // i commented the see all section because of the error in fetching files
                // list.add(CarouselSongWidget(
                //   title: f.title,
                //   songs: f.songs,
                //   cta: 'See Album',
                //   onCtaTapped: () {
                //     Navigator.of(context, rootNavigator: true)
                //         .push(MaterialPageRoute(
                //             builder: (context) => AlbumWidget(
                //                   albumId: f.id,
                //                   albumName: f.title,
                //                 )));
                //   },
                // ));
              });

              return ListView(
                children: list,
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return Center(
                child: JumpingDotsProgressIndicator(
              color: Colors.red,
              numberOfDots: 5,
              fontSize: 100,
            ));
          },
        ));
  }
}
