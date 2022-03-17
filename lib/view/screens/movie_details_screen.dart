// import 'dart:convert';
// import 'package:progress_indicators/progress_indicators.dart';
// import 'package:provider/provider.dart';
// // import 'package:niiflicks/classes/trends.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:niiflicks/classes/trending.dart';

// class MovieDetailsScreen extends StatefulWidget {
//   // static const routeName = '/movie-details';

//   @override
//   _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
// }

// class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
//   Future<List<Trending>> movieDetails() async {
//     var url = Uri.parse('https://niiflicks.com/niiflicks/apis/movies/trending');
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       print(response.body);
//       return Trending.parseRecent(jsonDecode(response.body)["data"]);
//     } else {
//       throw Exception('Unable to reach server');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final routeArgs =
//     //     ModalRoute.of(context).settings.arguments as Map<String, String>;
//     // final id = routeArgs['id'];
//     // final rating = routeArgs['rating'];

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         // title: Text('Movie Details'),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
//       ),
//       body: FutureBuilder(
//         future: movieDetails(),
//         builder:
//             (BuildContext context, AsyncSnapshot<List<Trending>> snapshot) {
//           if (snapshot.hasData) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 10,
//                 horizontal: 20,
//               ),
//               child: Column(
//                 children: snapshot.data.asMap().entries.map((entry) {
//                   return Column(
//                     children: [
//                       Center(
//                         child: Card(
//                           elevation: 5,
//                           child: Container(
//                             height: 450,
//                             width: 300,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: NetworkImage(
//                                   entry.value.thumbnail,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         entry.value.title,
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: 2.5,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Card(
//                             color: Colors.black,
//                             elevation: 5,
//                             shadowColor: Colors.red,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 10,
//                                 horizontal: 40,
//                               ),
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(
//                                     Icons.timer,
//                                     size: 45,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     entry.value.duration,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Card(
//                             elevation: 5,
//                             shadowColor: Colors.red,
//                             color: Colors.black,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 10,
//                                 horizontal: 20,
//                               ),
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(
//                                     Icons.calendar_today,
//                                     size: 45,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     entry.value.releasedate.toString(),
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Text(
//                       //   // '$rating/10',
//                       //   '3',
//                       //   style: TextStyle(
//                       //       fontSize: 14, fontWeight: FontWeight.bold),
//                       // ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         entry.value.overview,
//                         style: TextStyle(
//                           fontSize: 18,
//                           height: 1.5,
//                           color: Colors.white,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             );
//           } else if (snapshot.hasError) {
//             print(snapshot.error);
//             return Center(
//               child: Text('No information was gotten'),
//             );
//           }
//           return Center(
//             child: JumpingDotsProgressIndicator(
//               numberOfDots: 5,
//               color: Colors.red,
//               fontSize: 100.0,
//               // valueColor:
//               //     new AlwaysStoppedAnimation<Color>(ColorConst.APP_COLOR),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Row(
//         children: <Widget>[
//           Expanded(
//             child: RaisedButton(
//               padding: const EdgeInsets.only(
//                 top: 20,
//                 bottom: 20,
//               ),
//               onPressed: () {},
//               color: Theme.of(context).primaryColor,
//               textColor: Colors.white,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Icon(
//                     Icons.play_circle_outline,
//                   ),
//                   Text(
//                     'Watch Trailer',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: RaisedButton(
//               padding: const EdgeInsets.only(
//                 top: 20,
//                 bottom: 20,
//               ),
//               onPressed: () {},
//               color: Colors.yellowAccent,
//               textColor: Colors.black,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     Icons.check_circle_outline,
//                   ),
//                   Container(
//                     height: 5,
//                     width: 5,
//                   ),
//                   Text(
//                     'Watch Later',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
