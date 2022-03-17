import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:niiflicks/classes/seasonal_movies.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/home/episode_details.dart';
import 'package:niiflicks/view/screens/episodes_list.dart';

class SeasonalDetails extends StatefulWidget {
  final movie_cover;
  final season_id;
  final series_id;
  final movie_title;
  SeasonalDetails(
      {this.movie_cover, this.season_id, this.movie_title, this.series_id});

  @override
  State<SeasonalDetails> createState() => _SeasonalDetailsState();
}

class _SeasonalDetailsState extends State<SeasonalDetails> {
  Future<List<Seasons>> seasonalList() async {
    var url = 'https://www.niiflicks.com/niiflicks/apis/movies/get_season.php';
    var data = {'series_id': widget.series_id};
    print(widget.series_id);
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      // print(response.body);
      return Seasons.parseRecent(jsonDecode(response.body)["data"]);
    } else {
      print(response.body);
      throw Exception('Error in data flow');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seasonalList();
  }

  var connect = 'https://niiflicks.com/producers/storage/movie/filmposters/';
  var slash = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            bgColor: Colors.black,
            ctx: context,
            title: Text(
              'Seasons'.toUpperCase(),
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 20,
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
        body: SafeArea(
          child: Container(
              color: Colors.black,
              child: FutureBuilder(
                  future: seasonalList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Seasons>> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, int index) => SeasonalInformation(
                              season_id: snapshot.data[index].id,
                              filmposter: widget.movie_cover,
                              season_number: snapshot.data[index].seasonNumber,
                              series_id: snapshot.data[index].tvseriesId,
                              title: widget.movie_title));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('No seasons Available'));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })),
        ));
  }
}

class SeasonalInformation extends StatefulWidget {
  final season_id;
  final season_number;
  final filmposter;
  final overview;
  final series_id;
  final trailer;
  final title;

  SeasonalInformation(
      {this.season_id,
      this.season_number,
      this.filmposter,
      this.overview,
      this.trailer,
      this.series_id,
      this.title});

  @override
  _SeasonalInformationState createState() => _SeasonalInformationState();
}

class _SeasonalInformationState extends State<SeasonalInformation> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print(widget.season_id);
          print(widget.series_id);
          print(widget.filmposter);
          print(widget.title);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EpisodeList(
                        series_id: widget.series_id,
                        season_id: widget.season_id,
                        movie_cover: widget.filmposter,
                        movie_title: widget.title,
                        // movie_title: widget.title,
                      )));
        },
        child: Container(
          height: 200,
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.dstATop,
                ),
                image: NetworkImage(widget.filmposter)),
            boxShadow: [
              BoxShadow(color: Colors.red, blurRadius: 5.0),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Stack(children: [
                Container(
                  padding: EdgeInsets.only(bottom: 25, right: 24),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red[300],
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                        BoxShadow(
                            color: Colors.red[200],
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.red[700],
                            Colors.red[600],
                            Colors.red[500],
                            Colors.red[200],
                          ],
                          stops: [
                            0,
                            0.1,
                            0.3,
                            1
                          ])),
                  child: IconButton(
                    onPressed: () {
                      print(widget.filmposter);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EpisodeList(
                                    series_id: widget.season_id,
                                    season_id: widget.series_id,
                                    movie_cover: widget.filmposter,
                                    movie_title: widget.title,
                                    // movie_title: widget.title,
                                  )));
                    },
                    icon: Icon(
                      Icons.play_circle_outlined,
                      color: Colors.red[900],
                      size: 55,
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'Season ${widget.season_number}'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }
}
