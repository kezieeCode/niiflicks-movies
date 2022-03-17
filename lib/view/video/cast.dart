// import 'package:flutter/material.dart';
// import 'package:cast/cast.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cast Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: Scaffold(
//         appBar: AppBar(),
//         body: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Future<List<CastDevice>> _future;

//   @override
//   void initState() {
//     super.initState();
//     _startSearch();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<CastDevice>>(
//       future: _future,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error: ${snapshot.error.toString()}',
//             ),
//           );
//         } else if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         if (snapshot.data.isEmpty) {
//           return Material(
//             child: Container(
//               color: Colors.white,
//               child: Center(
//                 child: Text(
//                   'No Chromecast founded',
//                 ),
//               ),
//             ),
//           );
//         }

//         return Column(
//           children: snapshot.data.map((device) {
//             return ListTile(
//               title: Text(device.name),
//               onTap: () {
//                 // _connectToYourApp(context, device);
//                 _connectAndPlayMedia(context, device);
//               },
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   void _startSearch() {
//     _future = CastDiscoveryService().search();
//   }

//   Future<void> _connectToYourApp(
//       BuildContext context, CastDevice object) async {
//     final session = await CastSessionManager().startSession(object);

//     session.stateStream.listen((state) {
//       if (state == CastSessionState.connected) {
//         final snackBar = SnackBar(content: Text('Connected'));
//         Scaffold.of(context).showSnackBar(snackBar);

//         _sendMessageToYourApp(session);
//       }
//     });

//     session.messageStream.listen((message) {
//       print('receive message: $message');
//     });

//     session.sendMessage(CastSession.kNamespaceReceiver, {
//       'type': 'LAUNCH',
//       'appId': 'Youtube', // set the appId of your app here
//     });
//   }

//   void _sendMessageToYourApp(CastSession session) {
//     print('_sendMessageToYourApp');

//     session.sendMessage('urn:x-cast:namespace-of-the-app', {
//       'type': 'sample',
//     });
//   }

//   Future<void> _connectAndPlayMedia(
//       BuildContext context, CastDevice object) async {
//     final session = await CastSessionManager().startSession(object);

//     session.stateStream.listen((state) {
//       if (state == CastSessionState.connected) {
//         final snackBar = SnackBar(content: Text('Connected'));
//         Scaffold.of(context).showSnackBar(snackBar);
//       }
//     });

//     var index = 0;

//     session.messageStream.listen((message) {
//       index += 1;

//       print('receive message: $message');

//       if (index == 2) {
//         Future.delayed(Duration(seconds: 5)).then((x) {
//           _sendMessagePlayVideo(session);
//         });
//       }
//     });

//     session.sendMessage(CastSession.kNamespaceReceiver, {
//       'type': 'LAUNCH',
//       'appId': 'CC1AD845', // set the appId of your app here
//     });
//   }

//   void _sendMessagePlayVideo(CastSession session) {
//     print('_sendMessagePlayVideo');

//     var message = {
//       // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
//       'contentId':
//           'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
//       'contentType': 'video/mp4',
//       'streamType': 'BUFFERED', // or LIVE

//       // Title and cover displayed while buffering
//       'metadata': {
//         'type': 0,
//         'metadataType': 0,
//         'title': "Big Buck Bunny",
//         'images': [
//           {
//             'url':
//                 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg'
//           }
//         ]
//       }
//     };

//     session.sendMessage(CastSession.kNamespaceMedia, {
//       'type': 'LOAD',
//       'autoPlay': true,
//       'currentTime': 0,
//       'media': message,
//     });
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_video_cast/flutter_video_cast.dart';

// // class CastMovie extends StatefulWidget {
// //   final playing_movie;
// //   CastMovie({this.playing_movie});

// //   @override
// //   _CastMovieState createState() => _CastMovieState();
// // }

// // class _CastMovieState extends State<StatefulWidget> {
// //   ChromeCastController _controller;
// //   AppState _state = AppState.idle;
// //   bool _playing = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Watch Movie'),
// //         centerTitle: true,
// //         backgroundColor: Colors.black,
// //         actions: <Widget>[
// //           AirPlayButton(
// //             size: 30,
// //             color: Colors.white,
// //             activeColor: Colors.amber,
// //             onRoutesOpening: () => print('opening'),
// //             onRoutesClosed: () => print('closed'),
// //           ),
// //           ChromeCastButton(
// //             size: 30,
// //             color: Colors.white,
// //             onButtonCreated: _onButtonCreated,
// //             onSessionStarted: _onSessionStarted,
// //             onSessionEnded: () => setState(() => _state = AppState.idle),
// //             onRequestCompleted: _onRequestCompleted,
// //             onRequestFailed: _onRequestFailed,
// //           ),
// //         ],
// //       ),
// //       body: Center(child: _handleState()),
// //     );
// //   }

// //   Widget _handleState() {
// //     switch (_state) {
// //       case AppState.idle:
// //         return Text('ChromeCast not connected');
// //       case AppState.connected:
// //         return Text('No media loaded');
// //       case AppState.mediaLoaded:
// //         return _mediaControls();
// //       case AppState.error:
// //         return Text('An error has occurred');
// //       default:
// //         return Container();
// //     }
// //   }

// //   Widget _mediaControls() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: <Widget>[
// //         _RoundIconButton(
// //           icon: Icons.replay_10,
// //           onPressed: () => _controller.seek(relative: true, interval: -10.0),
// //         ),
// //         _RoundIconButton(
// //             icon: _playing ? Icons.pause : Icons.play_arrow,
// //             onPressed: _playPause),
// //         _RoundIconButton(
// //           icon: Icons.forward_10,
// //           onPressed: () => _controller.seek(relative: true, interval: 10.0),
// //         )
// //       ],
// //     );
// //   }

// //   Future<void> _playPause() async {
// //     final playing = await _controller.isPlaying();
// //     if (playing) {
// //       await _controller.pause();
// //     } else {
// //       await _controller.play();
// //     }
// //     setState(() => _playing = !playing);
// //   }

// //   Future<void> _onButtonCreated(ChromeCastController controller) async {
// //     _controller = controller;
// //     await _controller.addSessionListener();
// //   }

// //   Future<void> _onSessionStarted() async {
// //     setState(() => _state = AppState.connected);
// //     await _controller.loadMedia(
// //         'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
// //   }

// //   Future<void> _onRequestCompleted() async {
// //     final playing = await _controller.isPlaying();
// //     setState(() {
// //       _state = AppState.mediaLoaded;
// //       _playing = playing;
// //     });
// //   }

// //   Future<void> _onRequestFailed(String error) async {
// //     setState(() => _state = AppState.error);
// //     print(error);
// //   }
// // }

// // class _RoundIconButton extends StatelessWidget {
// //   final IconData icon;
// //   final VoidCallback onPressed;

// //   _RoundIconButton({@required this.icon, @required this.onPressed});

// //   @override
// //   Widget build(BuildContext context) {
// //     return RaisedButton(
// //         child: Icon(icon, color: Colors.white),
// //         padding: EdgeInsets.all(16.0),
// //         color: Colors.blue,
// //         shape: CircleBorder(),
// //         onPressed: onPressed);
// //   }
// // }

// // enum AppState { idle, connected, mediaLoaded, error }
