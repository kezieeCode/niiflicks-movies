import 'dart:convert';

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
import 'package:progress_indicators/progress_indicators.dart';
import 'package:niiflicks/classes/action.dart';
// import 'package:niiflicks/view/category/category_screen.dart';

class Animes extends StatefulWidget {
  const Animes({Key key}) : super(key: key);

  @override
  _AnimesState createState() => _AnimesState();
}

class _AnimesState extends State<Animes> {
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

  // Future<List<Seasonal>> seasonalMovies() async {
  //   Uri url = Uri.parse(
  //       'https://imdb-api.com/API/SeasonEpisodes/k_kyr1vihh/tt3107288/1');
  //   String apkey = 'k_kyr1vihh';
  //   var data = {'apiKey': apkey, 'id': 'tt3107288', 'seasonalMovies': '1'};
  //   final newUrl = url.replace(queryParameters: data);
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     print(response.body);

  //     return Seasonal.parseRecent(jsonDecode(response.body)['episodes']);
  //   } else {
  //     print(response.body);
  //     throw Exception('No data to display');
  //   }
  // }
  Future<List<Movies>> movies() async {
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/animation';

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
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/animation';

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
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/space';

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
    var uri = 'https://simplemovie.p.rapidapi.com/movie/search/romance';

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
    // TODO: implement initState
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
              'Kids'.toUpperCase(),
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
          child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              children: <Widget>[
                // FutureBuilder(
                //   future: movies(),
                //   builder: (context, AsyncSnapshot<List<Movies>> snapshot) {
                //     if (!snapshot.hasData) {
                //       return Center(child: Text('no data to display'));
                //     } else if (snapshot.hasData) {
                //       return CarouselSlider(
                //           items:
                //               //  [
                //               //   Image.asset('assets/images/mainbanner.jpg'),
                //               //   Image.asset('assets/images/jumanji.jpg'),
                //               //   Image.asset('assets/images/salt.jpg'),
                //               //   Image.asset('assets/images/wrath.jpg'),
                //               //   Image.asset('assets/images/justice.jpg')
                //               // ],
                //               snapshot.data
                //                   .asMap()
                //                   .entries
                //                   .map((e) => Container(
                //                         margin: EdgeInsets.all(5.0),
                //                         child: ClipRRect(
                //                           borderRadius:
                //                               BorderRadius.circular(10),
                //                           child: Stack(children: [
                //                             Image.network(
                //                               e.value.cover,
                //                               width: 150,
                //                               fit: BoxFit.fill,
                //                               filterQuality:
                //                                   FilterQuality.high,
                //                             ),
                //                             Positioned(
                //                                 bottom: 0.0,
                //                                 left: 0.0,
                //                                 right: 0.0,
                //                                 child: Container(
                //                                     padding:
                //                                         EdgeInsets.symmetric(
                //                                             vertical: 10.0,
                //                                             horizontal: 20.0),
                //                                     child: Text(
                //                                       'TV shows',
                //                                       style: TextStyle(
                //                                         color: Colors.white,
                //                                         fontSize: 20.0,
                //                                         fontWeight:
                //                                             FontWeight.bold,
                //                                       ),
                //                                     ),
                //                                     decoration: BoxDecoration(
                //                                       gradient:
                //                                           LinearGradient(
                //                                         colors: [
                //                                           Color.fromARGB(
                //                                               200, 0, 0, 0),
                //                                           Color.fromARGB(
                //                                               0, 0, 0, 0)
                //                                         ],
                //                                         begin: Alignment
                //                                             .centerLeft,
                //                                         end: Alignment
                //                                             .centerRight,
                //                                       ),
                //                                     )))
                //                           ]),
                //                         ),
                //                       ))
                //                   .toList(),
                //           options: CarouselOptions(
                //             height: 200,
                //             aspectRatio: 2.0,
                //             viewportFraction: 1.8,
                //             initialPage: 2,
                //             enableInfiniteScroll: true,
                //             reverse: false,
                //             autoPlay: true,
                //             autoPlayInterval: Duration(seconds: 20),
                //             autoPlayAnimationDuration:
                //                 Duration(milliseconds: 1000),
                //             autoPlayCurve: Curves.fastOutSlowIn,
                //             enlargeCenterPage: true,
                //             // onPageChanged: callbackFunction,
                //             scrollDirection: Axis.horizontal,
                //           ));
                //     } else {
                //       return Center(child: CircularProgressIndicator());
                //     }
                //   },
                // ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Animations',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Container(
                  child: FutureBuilder(
                      future: movieGenre(),
                      builder:
                          (context, AsyncSnapshot<List<Actionss>> snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'There was a problem somehwere',
                            style: TextStyle(color: Colors.white),
                          );
                        } else if (snapshot.hasData) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            height: MediaQuery.of(context).size.height,
                            child: GridView.builder(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              itemCount: snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return SeasonalInfo(
                                  covers: snapshot.data[index].cover,
                                  id: snapshot.data[index].vidId,
                                  date: snapshot.data[index].date,
                                  title: snapshot.data[index].title,
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
                // Padding(
                //   padding: EdgeInsets.only(left: 10),
                //   child: Text(
                //     'Sci-Fi',
                //     style: TextStyle(
                //         color: Colors.red,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20),
                //   ),
                // ),
                // Container(
                //   child: FutureBuilder(
                //       future: movieScience(),
                //       builder:
                //           (context, AsyncSnapshot<List<Science>> snapshot) {
                //         if (snapshot.hasError) {
                //           return Text(
                //             'There was a problem somehwere',
                //             style: TextStyle(color: Colors.white),
                //           );
                //         } else if (snapshot.hasData) {
                //           return Expanded(
                //             child: SizedBox(
                //               height: 200,
                //               child: ListView.builder(
                //                 itemCount: snapshot.data.length,
                //                 scrollDirection: Axis.horizontal,
                //                 itemBuilder: (context, index) {
                //                   return SeasonalInfo(
                //                     covers: snapshot.data[index].cover,
                //                   );
                //                 },
                //               ),
                //             ),
                //           );
                //         } else {
                //           return Center(
                //             child: CircularProgressIndicator(),
                //           );
                //         }
                //       }),
                // ),
                // SizedBox(
                //   height: 100,
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 10),
                //   child: Text(
                //     'Romance',
                //     style: TextStyle(
                //         color: Colors.red,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20),
                //   ),
                // ),
                // Container(
                //   child: FutureBuilder(
                //       future: movieRomance(),
                //       builder:
                //           (context, AsyncSnapshot<List<Romance>> snapshot) {
                //         if (snapshot.hasError) {
                //           return Text(
                //             'There was a problem somehwere',
                //             style: TextStyle(color: Colors.white),
                //           );
                //         } else if (snapshot.hasData) {
                //           return Expanded(
                //             child: SizedBox(
                //               height: 200,
                //               child: ListView.builder(
                //                 itemCount: snapshot.data.length,
                //                 scrollDirection: Axis.horizontal,
                //                 itemBuilder: (context, index) {
                //                   return SeasonalInfo(
                //                     covers: snapshot.data[index].cover,
                //                   );
                //                 },
                //               ),
                //             ),
                //           );
                //         } else {
                //           return Center(
                //             child: CircularProgressIndicator(),
                //           );
                //         }
                //       }),
                // ),
                // SizedBox(
                //   height: 500,
                // )

                // SizedBox(
                //   height: 100,
                // )
              ]),
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
                widget.covers,
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }
}
// SeasonalInfo(
//                                     covers: snapshot.data[index].cover,
//                                     id: snapshot.data[index].vidId,
//                                     date: snapshot.data[index].date,
//                                     title: snapshot.data[index].title,
//                                   );