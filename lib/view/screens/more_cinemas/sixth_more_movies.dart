import 'package:flutter/material.dart';

import 'package:niiflicks/classes/new_releases.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/view/home/detail.dart';
import 'package:niiflicks/view/home/recent_detail.dart';
import 'package:niiflicks/view/home/recent_detail_paid.dart';
import 'package:niiflicks/view/screens/more_cinemas/seventh_more_movies.dart';
import 'package:progress_indicators/progress_indicators.dart';

final kTitleStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
final kInfoStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red);

class SixthMoreMovies extends StatefulWidget {
  @override
  _SixthMoreMoviesState createState() => _SixthMoreMoviesState();
// }

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: SixthMoreMovies(),
    );
  }
}

class _SixthMoreMoviesState extends State<SixthMoreMovies> {
  final _searchController = TextEditingController();
  Future searchMovie() async {
    String searches = _searchController.text;
    var url = Uri.parse('https://universal-studios1.p.rapidapi.com/search.php');
    var data = {'keyword': searches};
    final newUrl = url.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {});
      return Recent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception();
    }
  }

  Future<List<Releases>> newreleases() async {
    var url =
        Uri.parse('https://niiflicks.com/niiflicks/apis/movies/newreleases');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return Releases.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Check your internet connection');
    }
  }

  Future movieLists() async {
    var url = 'https://universal-studios1.p.rapidapi.com/cinema-movies.php';
    var uri = Uri.parse(url);
    final String second_page = '7';
    var data = {"page": second_page};
    final newUrl = uri.replace(queryParameters: data);
    var response = await http.get(newUrl, headers: {
      'x-rapidapi-host': 'universal-studios1.p.rapidapi.com',
      'x-rapidapi-key': '9744c92c83msh22f596ce6e8b136p1a7a46jsn04182d9769de'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return Recent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      throw Exception('No data to display');
    }
  }

  @override
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
          title: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 100, top: 10),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          searchMovie();
                        },
                      ),
                      hintText: 'Search',
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeventhMoreMovies()));
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red,
                ))
          ],
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
            future: movieLists(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    return Movie_Information(
                      movie_id: snapshot.data[index].slug,
                      movie_date: snapshot.data[index].date,
                      movie_title: snapshot.data[index].title,
                      movie_image: snapshot.data[index].thumbnail,
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

List<Widget> buildTrendingColumns(List<Releases> data) {
  if (data.isNotEmpty) {
    return data.asMap().entries.map((element) {
      return Column(
        children: [
          Container(
            height: 120,
            child: Card(
              shadowColor: Colors.red,
              color: Colors.black,
              elevation: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'poster-${element.value.id}',
                        child: Image.network(
                          element.value.thumbnail,
                          // height: 150
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            element.value.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 16.0, bottom: 8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                // children: movies.genreIds
                                //     .take(3)
                                //     .map(buildGenreChip)
                                //     .toList(),
                                ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, right: 8.0),
                          child: Text(
                            element.value.overview,
                            style: TextStyle(color: Colors.red),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    }).toList();
  } else {
    return [Container()].toList();
  }
}

class Movie_Information extends StatelessWidget {
  final movie_id;
  final movie_title;
  final movie_date;
  final movie_image;

  Movie_Information({
    this.movie_id,
    this.movie_title,
    this.movie_date,
    this.movie_image,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => RecentDetailsScreenPaid(
                id: movie_id,
                cover: movie_image,
                title: movie_title,
                date_produced: movie_date)));
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
              child: Image.network(
                movie_image,
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }
}
