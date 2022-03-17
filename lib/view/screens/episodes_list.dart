import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:niiflicks/classes/seasonal_movies.dart';
import 'package:niiflicks/utils/widgethelper/widget_helper.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/view/home/episode_details.dart';

class EpisodeList extends StatefulWidget {
  final movie_cover;
  final series_id;
  final season_id;
  final movie_title;
  EpisodeList(
      {this.movie_cover, this.series_id, this.movie_title, this.season_id});

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  Future<List<Seasons>> seasonalList() async {
    var url = 'https://www.niiflicks.com/niiflicks/apis/movies/get_episode.php';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.fields.addAll({
      'series_id': widget.series_id,
      'season_id': widget.season_id,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      Map dataMap = json.decode(data);
      print("movie data: $dataMap");

      return Seasons.parseRecent(dataMap['data']);
    } else {
      print(response.reasonPhrase);
      throw Exception('Error in data flow');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seasonalList();
  }

  var connect = 'https://niiflicks.com/producers/storage/filmposters/';
  var slash = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            bgColor: Colors.black,
            ctx: context,
            title: Text(
              'Episodes'.toUpperCase(),
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
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, int index) => SeasonalInformation(
                                episode_id: snapshot.data[index].id,
                                filmposter: widget.movie_cover,
                                title: widget.movie_title,
                                series_id: widget.series_id,
                                season_id: widget.season_id,
                                // trailer: snapshot.data[index].,
                              ));
                    } else if (snapshot.hasError) {
                      print("error: ${snapshot.error}");
                      return Center(child: Text('Episodes not available yet'));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })),
        ));
  }
}

class SeasonalInformation extends StatefulWidget {
  final episode_id;
  final title;
  final filmposter;
  final season_id;
  final series_id;
  // final overview;
  final trailer;

  SeasonalInformation(
      {this.episode_id,
      this.title,
      this.filmposter,
      this.trailer,
      this.season_id,
      this.series_id});

  @override
  _SeasonalInformationState createState() => _SeasonalInformationState();
}

class _SeasonalInformationState extends State<SeasonalInformation> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print(widget.episode_id);
          print(widget.title);
          print(widget.series_id);
          print(widget.season_id);
          print(widget.filmposter);
          // print(widget.trailer);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EpisodeDetails(
                        episode_id: widget.episode_id,
                        season_id: widget.season_id,
                        series_id: widget.series_id,
                        title: widget.title,
                        cover: widget.filmposter,

                        // trailer: widget.trailer,
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
                      print(widget.series_id);
                      print(widget.season_id);
                      print(widget.title);
                      print(widget.trailer);

                      print(widget.filmposter);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EpisodeDetails(
                                    episode_id: widget.episode_id,
                                    series_id: widget.series_id,
                                    season_id: widget.season_id,
                                    title: widget.title,
                                    cover: widget.filmposter,

                                    // trailer: widget.trailer,
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
                  widget.title.toUpperCase(),
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
