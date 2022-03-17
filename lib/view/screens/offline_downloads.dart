import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/view/video/new_video_player.dart';
import 'package:niiflicks/view/video/offline%20video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';

class OfflineDownloads extends StatefulWidget {
  @override
  _OfflineDownloadsState createState() => _OfflineDownloadsState();
}

class _OfflineDownloadsState extends State<OfflineDownloads> {
  String movieName;
  String movieCoverImage;
  String movieLink;
  String episodeName;
  String episodeCoverImage;
  String episodeLink;
  File movie;
  File episode;

  @override
  void initState() {
    _getMovieDownloadDetails();
    _getEpisodeDownloadDetails();
    super.initState();
  }

  Future<void> _getMovieDownloadDetails() async {
    final prefs = await SharedPreferences.getInstance();
    movieName = prefs.getString("savedMovieName");
    movieCoverImage = prefs.getString("savedMovieCoverImage");
    movieLink = prefs.getString("savedMoviePath");

    final dir = Directory(movieLink);
    // var crypt = AesCrypt('niiflicks1234567890');
    // String decFilepath;

    // try {
    //   // Decrypts the file which has been just encrypted.
    //   // It returns a path to decrypted file.
    //   decFilepath = crypt.decryptFileSync(dir.path);
    //   print('The decryption has been completed successfully.');
    //   print('Decrypted file 1: $decFilepath');
    // } on AesCryptException catch (e) {
    //   if (e.type == AesCryptExceptionType.destFileExists) {
    //     print('The decryption has been completed unsuccessfully.');
    //     print(e.message);
    //   }
    // }

    movie = File(dir.path);
    print(dir.path);
    print(movie);
    setState(() {});
  }

  Future<void> getDir() async {
    List<FileSystemEntity> _folders;
    final folderName = "Niiflicks";
    final dir = Directory("storage/emulated/0/$folderName");
    String pdfDirectory = dir.path;
    final myDir = new Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    print(_folders);
  }

  Future<void> _getEpisodeDownloadDetails() async {
    final prefs = await SharedPreferences.getInstance();
    episodeName = prefs.getString("savedEpisodeName");
    episodeCoverImage = prefs.getString("savedEpisodeCoverImage");
    episodeLink = prefs.getString("savedEpisodePath");
    episode = File(episodeLink);
    setState(() {});
  }

  ScrollController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Offline Downloads'.toUpperCase(),
          style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSerifJP-Light'),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.red,
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        // bgbgColor: ColorConst.WHITE_BG_COLOR,
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              SizedBox(
                  height: 200.0,
                  width: 350.0,
                  child: Carousel(
                    images: [
                      NetworkImage('https://picsum.photos/200/300'),
                    ],
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.lightGreenAccent,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.red.withOpacity(0.5),
                    borderRadius: true,
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Movies',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                child: movieName == null
                    ? Center(
                        child: Text(
                        'No Saved Movie here',
                        style: TextStyle(color: Colors.white),
                      ))
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewVideoPlayer(
                                movie: movie,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(movieCoverImage),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Seasons',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
              Container(
                height: 280,
                child: episodeName == null
                    ? Center(
                        child: Text(
                          'No Saved Seasons here',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewVideoPlayer(
                                movie: episode,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              episodeName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(episodeCoverImage),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Offline_Information extends StatefulWidget {
  final offline_image;
  final movie_offline;

  const Offline_Information({Key key, this.offline_image, this.movie_offline})
      : super(key: key);

  // ignore: non_constant_identifier_names

  @override
  _Offline_InformationState createState() => _Offline_InformationState();
}

class _Offline_InformationState extends State<Offline_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => OfflineVideo(
                  savedMovie: widget.movie_offline,
                )));
      },
      child: Container(
        child: Card(
            color: Colors.black,
            shadowColor: Colors.red,
            elevation: 7,
            borderOnForeground: true,
            child: Image.network(
              widget.offline_image,
              height: 100,
            )
            // ==
            // null
            // ? Center(
            //     child: Text('No offline downloads',
            //         style: TextStyle(color: Colors.white)))
            // : Image.network(widget.offline_image, height: 100),
            ),
      ),
    );
  }
}
