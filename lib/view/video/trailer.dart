import 'dart:convert';
import 'package:niiflicks/view/home/detail.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/classes/new_releases.dart';
import 'package:niiflicks/classes/related.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/classes/watch_list.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/view/video/cast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trailers extends StatefulWidget {
  final movie;
  final movie_id;
  Trailers({this.movie, this.movie_id});

  @override
  _TrailersState createState() => _TrailersState();
}

class _TrailersState extends State<Trailers> {
  Future<List<Releases>> newreleases() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/newreleases');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      // return Releases.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future<List<GetRelated>> related() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getrelated');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return GetRelated.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future watchLater() async {
    BuildContext _context;
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    print(user_id);
    print(widget.movie_id);
    print(widget.movie);

    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/watchlist');
    var data = {'userid': user_id, 'movieid': widget.movie_id};
    print(data);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print(response.body);
      showSnackBar(_context, 'Comming Soon');
    } else {
      print(response.body);
    }
  }

  Future getwatchLater() async {
    BuildContext _context;
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('userid');
    print(user_id);
    print(widget.movie_id);
    print(widget.movie);

    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getwatchlist');
    var data = {
      'userid': user_id,
    };
    print(data);
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print(response.body);
      return GetWatchlist.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
    }
  }

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      widget.movie,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => MyHomePage()));
        //       },
        //       icon: Icon(
        //         Icons.cast_connected,
        //         color: Colors.red,
        //       ))
        // ],
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
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: ListView(children: [
        Stack(
            alignment: AlignmentDirectional.topCenter,
            fit: StackFit.loose,
            children: [
              AspectRatio(
                aspectRatio: 16 / 20,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(10, 20, 300, 0),
              //   child: Container(
              //       height: 40, child: Image.asset('assets/images/logo.png')),
              // ),
            ]),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Material(
            borderRadius: BorderRadius.circular(30),
            color: Colors.red,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                setState(() {
                  // If the video is playing, pause it.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    // If the video is paused, play it.
                    _controller.play();
                  }
                });
              },
              // Display the correct icon depending on the state of the player.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Watch trailer'.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Montserrat', color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 40, right: 40),
        //   child: Material(
        //     borderRadius: BorderRadius.circular(30),
        //     color: Colors.red,
        //     child: MaterialButton(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(30)),
        //       onPressed: () {
        //         watchLater();
        //       },
        //       // Display the correct icon depending on the state of the player.
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             'watch later'.toUpperCase(),
        //             style: TextStyle(
        //                 fontFamily: 'Montserrat',
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white),
        //           ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           Icon(
        //             Icons.watch_later,
        //             color: Colors.white,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),

        // Container(
        //   height: 280,
        //   child: FutureBuilder(
        //     future: getwatchLater(),
        //     builder: (BuildContext context, snapshot) {
        //       if (snapshot.hasData) {
        //         return ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             itemCount: snapshot.data.length,
        //             itemBuilder: (ctx, i) => Movie_Info(
        //                 movie_id: snapshot.data[i].id,
        //                 movie_title: snapshot.data[i].title,
        //                 movie_image: snapshot.data[i].images,
        //                 movie_thumbnail: snapshot.data[i].thumbnail,
        //                 movie_payment: snapshot.data[i].payment,
        //                 movie_price: snapshot.data[i].price,
        //                 movie_release_date: snapshot.data[i].releasedate,
        //                 movie_overview: snapshot.data[i].overview,
        //                 movie_trailer: snapshot.data[i].trailer,
        //                 movie_movie: snapshot.data[i].movie,
        //                 movie_duration: snapshot.data[i].duration));
        //       } else if (snapshot.hasError) {
        //         return Center(
        //           child: Text('No movies found'),
        //         );
        //       } else {
        //         return Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       }
        //     },
        //   ),
        // ),
      ]),
    );
  }
}

class Movie_Info extends StatefulWidget {
  final movie_id;
  final movie_price;
  final movie_title;
  final movie_trailer;
  final movie_image;
  final movie_thumbnail;
  final movie_release_date;
  final movie_payment;
  final movie_overview;
  final movie_duration;
  final movie_movie;
  Movie_Info(
      {this.movie_id,
      this.movie_price,
      this.movie_title,
      this.movie_trailer,
      this.movie_image,
      this.movie_thumbnail,
      this.movie_release_date,
      this.movie_payment,
      this.movie_overview,
      this.movie_duration,
      this.movie_movie});

  @override
  State<Movie_Info> createState() => _Movie_InfoState();
}

class _Movie_InfoState extends State<Movie_Info> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => DetailsScreen(
                 id: widget.movie_id,
                  description: widget.movie_overview,
                  cover: widget.movie_thumbnail,
                  movie: widget.movie_movie,
                  title: widget.movie_title,
                )));
      },
      child: Container(
        child: Card(
          color: Colors.black,
          shadowColor: Colors.red,
          elevation: 7,
          borderOnForeground: true,
          child: Image(
            image: NetworkImage(widget.movie_thumbnail),
            height: 100,
          ),
        ),
      ),
    );
  }
}
