// import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:niiflicks/classes/recent.dart';
import 'package:niiflicks/view/home/recent_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Icon searchIcon = Icon(Icons.search);
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

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(9),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchMovie();
                    },
                  ),
                  hintText: 'Search any movie....',
                  border: InputBorder.none),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            )),
      ),
      body: Container(
        color: Colors.black,
        child: Container(
          height: double.infinity,
          child: FutureBuilder(
            future: searchMovie(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
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
                      id: snapshot.data[index].slug,
                      date: snapshot.data[index].date,
                      title: snapshot.data[index].title,
                      covers: snapshot.data[index].thumbnail,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'No movies found',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    ));
  }
}

class Movie_Information extends StatefulWidget {
  final id;
  final covers;
  final title;
  final date;

  Movie_Information({
    this.id,
    this.covers,
    this.title,
    this.date,
  });

  @override
  _Movie_InformationState createState() => _Movie_InformationState();
}

class _Movie_InformationState extends State<Movie_Information> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) => RecentDetailsScreen(
                    //id is the same as slug
                    id: widget.id,
                    date_produced: widget.date,
                    cover: widget.covers,
                    title: widget.title,
                  )),
        );
      },
      child: Container(
        width: 20,
        height: double.infinity,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.black,
            shadowColor: Colors.red,
            elevation: 1,
            borderOnForeground: true,
            child: Image.network(
              widget.covers,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
//  Padding(
//         padding: const EdgeInsets.only(top: 150),
//         child: Stack(
//           children: [
//             Container(
//               height: 200,
//               child: Card(
//                 color: Colors.black,
//                 shadowColor: Colors.red,
//                 elevation: 8,
//                 borderOnForeground: true,
//                 child: Image(
//                   image: NetworkImage(widget.covers),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),