import 'package:flutter/material.dart';

import 'package:niiflicks/classes/new_releases.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:niiflicks/classes/paid_movies_model.dart';
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/home/recent_detail.dart';
import 'package:progress_indicators/progress_indicators.dart';

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);

class PaidMoviess extends StatefulWidget {
  @override
  _PaidMovieState createState() => _PaidMovieState();
// }

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: PaidMoviess(),
    );
  }
}

class _PaidMovieState extends State<PaidMoviess> {
 

  Future<List<PaidMoviesz>> paidMoviesAll() async {
    var url =
        Uri.parse('https://www.niiflicks.com/niiflicks/apis/movies/d_movies.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return PaidMoviesz.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future<List<Recent>> movieList() async {
    var uri = 'https://simplemovie.p.rapidapi.com/movie/list/recent';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return Recent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      throw Exception('No data to display');
    }
  }
  // Future<List<Popular>> popular() async {
  //   var url =
  //       Uri.parse('https://niiflicks.com/niiflicks/apis/movies/getpopular');
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return Popular.parseRecent(jsonDecode(response.body)["data"]);
  //   } else {
  //     throw Exception('Check your internet connection');
  //   }
  // }

  @override
  var connect = 'https://niiflicks.com/producers/storage/movie/filmposters/';
  var trailer = 'https://niiflicks.com/producers/storage/movie/trailers/';
var movie = 'https://niiflicks.com/producers/storage/movie/movies/';
var slash = '/';
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              )),
          title: Text(
            'EXCLUSIVE MOVIES'.toUpperCase(),
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'NotoSerifJP-Light',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
            future: paidMoviesAll(),
            builder:
                (BuildContext context, AsyncSnapshot<List<PaidMoviesz>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: JumpingDotsProgressIndicator(
                    numberOfDots: 5,
                    color: Colors.red,
                    fontSize: 100.0,
                    // valueColor:
                    //     new AlwaysStoppedAnimation<Color>(ColorConst.APP_COLOR),
                  ),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    print(connect+slash+snapshot.data[index].filmposter,);
                    return Movie_Information(
                      movie_id: snapshot.data[index].id,
                      movie_description: snapshot.data[index].overview,
                      movie_movie: movie+snapshot.data[index].movie,
                      movie_date: snapshot.data[index].duration,
                      movie_title: snapshot.data[index].title,
                      movie_image: connect+snapshot.data[index].filmposter,
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}



class Movie_Information extends StatefulWidget {
  final movie_id;
  final movie_title;
  final movie_date;
  final movie_description;
  final movie_movie;
  final movie_image;

  Movie_Information({
    this.movie_id,
    this.movie_title,
    this.movie_description,
    this.movie_movie,
    this.movie_date,
    this.movie_image,
  });

  @override
  State<Movie_Information> createState() => _Movie_InformationState();
}

// ignore: camel_case_types
class _Movie_InformationState extends State<Movie_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      onTap: () {
        print(widget.movie_image);
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => DetailsScreen(
                id: widget.movie_id,
                  description: widget.movie_description,
                  cover: widget.movie_image,
                  movie: widget.movie_movie,
                  title: widget.movie_title)));
      },
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          width: 20,
          height: double.infinity,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.black,
              shadowColor: Colors.red,
              elevation: 1,
              borderOnForeground: true,
              child: Image(
            image: NetworkImage(widget.movie_image),
            height: 100,
          ),),
        ),
      ),
    );
  }
}
