import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'album.dart';
import 'song.dart';
import 'divider_widget.dart';
import 'player_widget.dart';
import 'artist_widget.dart';
import 'musicservice.dart';

class AlbumWidget extends StatefulWidget {
  final String albumId;
  final String albumName;
  AlbumWidget({this.albumId, this.albumName});
  @override
  State<StatefulWidget> createState() {
    return AlbumWidgetState();
  }
}

class AlbumWidgetState extends State<AlbumWidget> {
  Future<Album> _album;
  AppleMusicStore _musicStore = AppleMusicStore.instance;

  @override
  void initState() {
    super.initState();
    _album = _musicStore.fetchAlbumById(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.albumName,
            style: TextStyle(color: Colors.red),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<Album>(
            future: _album,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final album = snapshot.data;
                final List<Widget> list = [AlbumHeaderWidget(album: album)];
                int songIndex = 1;

                album.songs.forEach((s) {
                  list.add(AlbumSongItemWidget(
                    index: songIndex,
                    song: s,
                  ));
                  songIndex++;
                });

                return ListView(
                  children: list,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class AlbumHeaderWidget extends StatelessWidget {
  final Album album;

  AlbumHeaderWidget({this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24.0, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 8.0),
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          album.artworkUrl(512),
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )),
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    album.title,
                    style: TextStyle(color: Colors.red),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0)),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(CupertinoPageRoute(
                                builder: (context) => ArtistWidget(
                                      artistId: album.artistId,
                                      artistName: album.artistName,
                                    )));
                      },
                      child: Text(
                        album.artistName,
                        style: TextStyle(color: Colors.red),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0)),
                  Text(
                    "${album.title[0]}",
                    style: TextStyle(color: Colors.red),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Container(),
          DividerWidget(
            margin: EdgeInsets.only(left: 0),
          )
        ],
      ),
    );
  }
}

class AlbumSongItemWidget extends StatelessWidget {
  final int index;
  final Song song;

  AlbumSongItemWidget({this.index, this.song});

  @override
  Widget build(BuildContext context) {
    return Material(
        // color: Colors.white,
        child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => PlayerWidget(
                            song: song,
                          )));
            },
            child: Container(
                color: Colors.black,
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "$index",
                          style: TextStyle(color: Colors.red),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        Expanded(
                            child: Text(
                          song.title,
                          style: TextStyle(color: Colors.red),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        Icon(
                          Icons.play_arrow,
                          color: Colors.red,
                        )
                      ],
                    ),
                    DividerWidget(
                      margin: EdgeInsets.only(top: 8.0, left: 16.0),
                    )
                  ],
                ))));
  }
}
