import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/classes/movies.dart';
import 'package:niiflicks/classes/new_movies.dart';
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/classes/romance.dart';
import 'package:niiflicks/classes/science.dart';
import 'package:niiflicks/classes/seasonal_movies.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:niiflicks/view/home/recent_detail.dart';
import 'package:niiflicks/view/viewAll/action_page.dart';
import 'package:niiflicks/view/viewAll/science_fiction.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:niiflicks/classes/action.dart';
// import 'package:niiflicks/view/category/category_screen.dart';

class TvShows extends StatefulWidget {
  const TvShows({Key key}) : super(key: key);

  @override
  _TvShowsState createState() => _TvShowsState();
}

class _TvShowsState extends State<TvShows> {
  Future<List<NewMovies>> moviesRecent() async {
    Uri url = Uri.parse('https://imdb-api.com/API/MostPopularTVs');
    String apkey = 'k_kyr1vihh';
    var data = {'apiKey': apkey};
    final newUrl = url.replace(queryParameters: data);
    var response = await http.get(newUrl);
    if (response.statusCode == 200) {
      print(response.body);

      return NewMovies.parseRecent(jsonDecode(response.body)['items']);
    } else {
      print(response.body);
      throw Exception('No data to display');
    }
  }

 
  Future<List<Movies>> movies() async {
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/action';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return Movies.parseRecent(jsonDecode(response.body)['data']);
    } else {
      print(response.body);
      throw Exception('No data to display');
    }
  }

  Future<List<Actionss>> movieGenre() async {
    // var uri = 'https://simplemovie.p.rapidapi.com/movie/search/Sword';
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/action';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return Actionss.parseRecent(jsonDecode(response.body)['data']);
    } else {
      print(response.body);
      throw Exception('No data to display');
    }
  }

  Future<List<Science>> movieScience() async {
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/Tech';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return Science.parseRecent(jsonDecode(response.body)['data']);
    } else {
      print(response.body);
      throw Exception('No data to display');
    }
  }

  Future<List<Romance>> movieRomance() async {
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/love';
    // var uri = 'https://simplemovie.p.rapidapi.com/movie/search/romance';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
    });
    if (response.statusCode == 200) {
      print(response.body);
      return Romance.parseRecent(jsonDecode(response.body)['data']);
    } else {
      print(response.body);
      throw Exception('No data to display');
    }
  }

  Future movieList() async {
    var uri = 'https://simplemovie.p.rapidapi.com/movie/list/recent';

    var response = await http.get(Uri.parse(uri), headers: {
      'x-rapidapi-key': '54955f88e7mshdd4f9ff2678e1c8p19ce0djsnd6af5e47672f'
    });
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    movieList();
    movieGenre();
    // seasonalMovies(); 

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: getAppBarWithBackBtn(
            bgColor: Colors.black,
            ctx: context,
            title: Text(
              'TV shows'.toUpperCase(),
              style: TextStyle(
                  color: Colors.red, fontFamily: 'Montserrat-Regular'),
            ),
            actions: [
              IconButton(
                onPressed: () => null,
                icon: Icon(
                  Icons.search,
                  color: Colors.red,
                ),
              )
            ],
            icon: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              ),
            )),
        body: Center(
          child: Container(
            child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  FutureBuilder(
                    future: movies(),
                    builder: (context, AsyncSnapshot<List<Movies>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('no data to display'));
                      } else if (snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: double.infinity,
                          child: Carousel(
                              showIndicator: false,
                              dotColor: Colors.white,
                              dotBgColor: Colors.transparent,
                              dotIncreasedColor: Colors.red,
                              images: snapshot.data
                                  .asMap()
                                  .entries
                                  .map((e) => Image.network(
                                        e.value.cover,
                                        height: 140,
                                        width: 200,
                                        fit: BoxFit.fill,
                                      ))
                                  .toList()
                              // AssetImage('assets/images/mainbanner.jpg'),
                              // AssetImage('assets/images/jumanji.jpg'),
                              // AssetImage('assets/images/salt.jpg'),
                              // AssetImage('assets/images/wrath.jpg'),
                              // AssetImage('assets/images/justice.jpg')

                              ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Action',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        FlatButton(
                          child: Text(
                            'View All',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActionMovies()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: movieGenre(),
                        builder:
                            (context, AsyncSnapshot<List<Actionss>> snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'There was a problem somewhere',
                              style: TextStyle(color: Colors.white),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              height: 200.0,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return SeasonalInfo(
                                    covers: snapshot.data[index].cover,
                                    id: snapshot.data[index].vidId,
                                    title: snapshot.data[index].title,
                                    date: snapshot.data[index].date,
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  // SizedBox(
                  //   height: 100,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Sci-Fi',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        FlatButton(
                          child: Text(
                            'View All',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScienceFiction()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: movieScience(),
                        builder:
                            (context, AsyncSnapshot<List<Science>> snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'There was a problem somewhere',
                              style: TextStyle(color: Colors.white),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              height: 200.0,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return SeasonalInfo(
                                    covers: snapshot.data[index].cover,
                                    id: snapshot.data[index].vidId,
                                    title: snapshot.data[index].title,
                                    date: snapshot.data[index].date,
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  // SizedBox(
                  //   height: 100,
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Romance',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: movieRomance(),
                        builder:
                            (context, AsyncSnapshot<List<Romance>> snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'There was a problem somewhere',
                              style: TextStyle(color: Colors.white),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              height: 200.0,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return SeasonalInfo(
                                      covers: snapshot.data[index].cover,
                                      id: snapshot.data[index].vidId,
                                      title: snapshot.data[index].title,
                                      date: snapshot.data[index].date);
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  // SizedBox(
                  //   height: 500,
                  // )

                  // SizedBox(
                  //   height: 100,
                  // )
                ]),
          ),
        ));
  }
}

class SeasonalInfo extends StatefulWidget {
  final id;
  final covers;
  final title;
  final date;

  SeasonalInfo({
    this.id,
    this.covers,
    this.title,
    this.date,
  });

  @override
  _SeasonalInfoState createState() => _SeasonalInfoState();
}

class _SeasonalInfoState extends State<SeasonalInfo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('im printed');
        print(widget.date);
        print(widget.id);
        print(widget.title);
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => RecentDetailsScreen(
                  id: widget.id,
                  date_produced: widget.date,
                  cover: widget.covers,
                  title: widget.title,
                )));
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            color: Colors.black,
            shadowColor: Colors.red,
            elevation: 7,
            borderOnForeground: true,
            child: Image(
              image: NetworkImage(widget.covers),
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}
