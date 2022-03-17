import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:niiflicks/classes/live_tvs_recent_.dart';
import 'package:niiflicks/classes/live_tv.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/video/web_game.dart';
import 'package:niiflicks/view/video/youtube_player.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LiveTv extends StatefulWidget {
  const LiveTv({Key key}) : super(key: key);

  @override
  _LiveTvState createState() => _LiveTvState();
}

class _LiveTvState extends State<LiveTv> {
  Future<List<LiveTvs>> liveTv() async {
    var url = 'https://niiflicks.com/niiflicks/apis/movies/livetv.php';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      return LiveTvs.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Never communicated with the server');
    }
  }

  Future<List<LiveTvRecent>> liveTvRecent() async {
    var url = 'https://niiflicks.com/niiflicks/apis/movies/livetvrecent.php';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      return LiveTvRecent.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Never communicated with the server');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    liveTv();
    liveTvRecent();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: getAppBarWithBackBtn(
              bgColor: Colors.black,
              ctx: context,
              title: Text(
                'Live Games'.toUpperCase(),
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Montserrat-Regular',
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () => null,
                  icon: Icon(
                    Icons.live_tv,
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
              children: [
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 150, right: 120),
                  child: Text(
                    'Live Games',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontFamily: 'Montserrat-Regular',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: liveTv(),
                    builder: (context, AsyncSnapshot<List<LiveTvs>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Carousel(
                              showIndicator: false,
                              dotColor: Colors.white,
                              dotBgColor: Colors.transparent,
                              dotIncreasedColor: Colors.red,
                              images: snapshot.data
                                  .asMap()
                                  .entries
                                  .map((e) => InkWell(
                                        onTap: () {
                                          if (e.value.youtube == "yes") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        YouTubeLive(
                                                          stream: e.value.link,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WebGame(
                                                          stream: e.value.link,
                                                        )));
                                          }
                                        },
                                        child: Image.network(
                                          e.value.image,
                                          height: 140,
                                          width: 200,
                                          fit: BoxFit.fill,
                                        ),
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
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 120, right: 120),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Recent Games',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: FutureBuilder(
                      future: liveTvRecent(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<LiveTvRecent>> snapshot) {
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
                          return Expanded(
                            child: SizedBox(
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
                                  return Movie_Information(
                                    movie_id: snapshot.data[index].id,
                                    movie_link: snapshot.data[index].link,
                                    movie_title: snapshot.data[index].name,
                                    movie_image: snapshot.data[index].image,
                                    movie_youtube: snapshot.data[index].youtube,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ),
              ],
            ),
          )),
    );
  }
}

class Movie_Information extends StatelessWidget {
  final movie_id;
  final movie_title;
  final movie_link;
  final movie_image;
  final movie_youtube;

  Movie_Information(
      {this.movie_id,
      this.movie_title,
      this.movie_link,
      this.movie_image,
      this.movie_youtube});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(movie_youtube);
        if (movie_youtube == "yes") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => YouTubeLive(
                        stream: movie_link,
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebGame(
                        stream: movie_link,
                      )));
        }
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
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.black,
            shadowColor: Colors.red,
            elevation: 1,
            borderOnForeground: true,
            child: Image.network(
              movie_image,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
